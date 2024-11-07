//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////    "IMPORTS"                                                                                                                                 //////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import { IERC20 } from "./IERC20.sol";
import { ByteHasher } from "./ByteHasher.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////    "INTERFACES"                                                                                                                              //////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
interface ILidoLiquidStaking
{
    function deposit() external payable;
    function approve(address spender, uint256 value) external returns (bool);
}

interface IRenzoReestaking
{
    function deposit(address staker, IERC20 token, uint tokenAmount) external returns(uint256 shares);
}

interface IGearboxProtocol
{ 
    function provideLiquidityToCurve(uint256 ezETHAmount, uint16 leverageFactor) external;
}

interface IWorldId
{
	/// @notice Reverts if the zero-knowledge proof is invalid.
	/// @param root The of the Merkle tree
	/// @param groupId The id of the Semaphore group
	/// @param signalHash A keccak256 hash of the Semaphore signal
	/// @param nullifierHash The nullifier hash
	/// @param externalNullifierHash A keccak256 hash of the external nullifier
	/// @param proof The zero-knowledge proof
	/// @dev  Note that a double-signaling check is not included here, and should be carried by the caller.
	function verifyProof(
		uint256 root,
		uint256 groupId,
		uint256 signalHash,
		uint256 nullifierHash,
		uint256 externalNullifierHash,
		uint256[8] calldata proof
	) external view;
}

contract KarkinosRound
{
    using ByteHasher for bytes;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////    "STRUCTS"                                                                                                                                 //////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    struct projectData
    {
        uint projectId;
        string projectName;
        string projectDescription;
        address projectAdmin;
    }

    struct phaseOneFundingOrder
    {
        uint fundingOrderId;
        address funderAddress;
        uint funddedAmountInWei;
    }

    struct phaseTwoFundingOrder
    {
        uint fundingTwoOrderId;
        address funderAddress;
        uint funddedAmountInWei;
        uint funddedReestakedAmount18Decimals;
        uint projectIdFunded;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////    "storageVariables"                                                                                                                        //////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////
    //    "interfaceVariables"                       ///
    ////////////////////////////////////////////////////
    IWorldId worldIdRouter;

    ////////////////////////////////////////////////////
    //    "VARIABLES"                                ///
    ////////////////////////////////////////////////////
    address public admin;
    address public lidoLiquidStakingAddress = 0xeAde2E3f4C3226f90206c0b5BFa6A689BC478BC0;
    address public renzoReestakingAddress = 0x646FbcfE3cFc4cADb99c4adD4C07FD7E558cfae4;
    address public gearboxProtocolAddress = 0x34cEC27B13197436d2ff792FEe4fFfFa4059A908;

    uint public permmitedFundingPerAddress;

    uint256 internal immutable externalNullifier;

    uint public totalPhaseOneFunddedEtherInWei;
    uint public AvailablePhaseOneFunddedEtherInWei;

    uint public nextProjectId;
    uint public nextPhaseOneFundingOrder;
    uint public nextPhaseTwoFundingOrder;

    uint public actualPhase; // 0 for projectRegistration, 1 for preFunding, 2 for funding, 3 roundEnded ///

    ////////////////////////////////////////////////////
    //    "MAPPINGS"                                 ///
    ////////////////////////////////////////////////////
    mapping(uint256 => uint256) worldFunndedCounter;
    mapping(uint => projectData) projects;

    mapping(uint => phaseOneFundingOrder) phaseOneFundingOrders;
    mapping(address => uint[]) addressPhaseOneFundedOrders;
    mapping(address => bool) claimedPhaseOneFundding;

    mapping(uint => phaseTwoFundingOrder) phaseTwoFundingOrders;
    mapping(address => uint[]) addressPhaseTwoFundedOrders;

    mapping(uint => uint) projectsFundding;
    mapping(uint => bool) projectsFunddingClaimed;

    mapping(uint => bool) phaseOneClaimedOrder;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////    "FUNCTIONS"                                                                                                                               //////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////
    //    "CONSTRUCTOR"                              ///
    ////////////////////////////////////////////////////
    constructor(address adminParam, string memory _appId, string memory _actionId, uint fundingQuantityParam)
    {
        admin = adminParam;
        worldIdRouter = IWorldId(0x469449f251692E0779667583026b5A1E99512157);

        externalNullifier = abi.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId).hashToField();

        permmitedFundingPerAddress = fundingQuantityParam;
        actualPhase = 0;

        totalPhaseOneFunddedEtherInWei = 0;
        AvailablePhaseOneFunddedEtherInWei = 0;

        nextProjectId = 1;
        nextPhaseOneFundingOrder = 1;
        nextPhaseTwoFundingOrder = 1;
    }

    ////////////////////////////////////////////////////
    //    "FUNCS"                                    ///
    ////////////////////////////////////////////////////
    function registerProject(string memory projectNameParam, string memory projectDescriptionParam) public
    {
        require(actualPhase == 0, "Registration phase already ended.");

        projectData memory newProject = projectData(nextProjectId, projectNameParam, projectDescriptionParam, msg.sender);
        projects[nextProjectId] = newProject;
        nextProjectId++;
    }

    function fundPhaseOne() public payable
    {
        require(actualPhase == 1, "Not yet on fund phase one or already ended.");

        phaseOneFundingOrder memory newPhaseOneFundingOrder = phaseOneFundingOrder(nextPhaseOneFundingOrder, msg.sender, msg.value);
        totalPhaseOneFunddedEtherInWei += msg.value;
        AvailablePhaseOneFunddedEtherInWei += msg.value;
        phaseOneFundingOrders[nextPhaseOneFundingOrder] = newPhaseOneFundingOrder;
        

        uint[] storage senderOrders = addressPhaseOneFundedOrders[msg.sender];
        senderOrders.push(nextPhaseOneFundingOrder);
        addressPhaseOneFundedOrders[msg.sender] = senderOrders;

        nextPhaseOneFundingOrder++;
    }

    function fundPhaseTwo(uint projectIdParam, uint256 root, uint256 nullifierHash, uint256[8] calldata proof) public payable
    {
        require(actualPhase == 2, "Not yet on fund phase two or already ended.");
        require(projectIdParam < nextProjectId, "The project doesnt existe.");
        require(worldFunndedCounter[nullifierHash] < permmitedFundingPerAddress, "Farming protection reached.");

        uint uintSignal = worldFunndedCounter[nullifierHash];

        worldIdRouter.verifyProof(
			root,
			// groupId,
			1,
			uintSignal,
			nullifierHash,
			externalNullifier,
			proof
		);

        uint funddingValue = msg.value;

        // a - 100   ->      b - funddingValue
        // c - 91     ->      x - ?
        // x = (b * c) / a   ->  ? = (funddingValue * 91) / 100
        uint actualValueWithoutFutureAccruedYield = (funddingValue * 91) / 100;
        uint instantLiquidFunding = funddingValue - actualValueWithoutFutureAccruedYield;

        ILidoLiquidStaking(lidoLiquidStakingAddress).deposit{value: actualValueWithoutFutureAccruedYield}();
        ILidoLiquidStaking(lidoLiquidStakingAddress).approve(renzoReestakingAddress, actualValueWithoutFutureAccruedYield);
        IRenzoReestaking(renzoReestakingAddress).deposit(address(this), IERC20(lidoLiquidStakingAddress), actualValueWithoutFutureAccruedYield);



        IERC20(renzoReestakingAddress).approve(gearboxProtocolAddress, actualValueWithoutFutureAccruedYield);
        IGearboxProtocol(gearboxProtocolAddress).provideLiquidityToCurve(actualValueWithoutFutureAccruedYield, 0);



        phaseTwoFundingOrder memory newPhaseTwoFundingOrder = phaseTwoFundingOrder(nextPhaseTwoFundingOrder, msg.sender, msg.value, actualValueWithoutFutureAccruedYield, projectIdParam);
        phaseTwoFundingOrders[nextPhaseTwoFundingOrder] = newPhaseTwoFundingOrder;

        uint[] storage phaseTwoFundedOrders = addressPhaseTwoFundedOrders[msg.sender];
        phaseTwoFundedOrders.push(nextPhaseTwoFundingOrder);
        addressPhaseTwoFundedOrders[msg.sender] = phaseTwoFundedOrders;

        projectsFundding[projectIdParam] += instantLiquidFunding;
        nextPhaseTwoFundingOrder++;
        worldFunndedCounter[nullifierHash]++;
    }

    function claimPhaseOneFunding() public
    {
        require(actualPhase == 3, "Not ready to claim phaseOne funding yet.");
        require(!claimedPhaseOneFundding[msg.sender], "User already claimed his phaseOne fundded orders.");

        uint[] memory userOrders = addressPhaseOneFundedOrders[msg.sender];
        uint totalEtherFundded = 0;

        for(uint i = 0 ; i < userOrders.length ; i++)
        {
            phaseOneFundingOrder memory actualOrderChecking = phaseOneFundingOrders[userOrders[i]];
            totalEtherFundded += actualOrderChecking.funddedAmountInWei;
        }

        (bool sent, bytes memory data) = (msg.sender).call{value: totalEtherFundded}("");
        require(sent, "Failed to send funds");

        claimedPhaseOneFundding[msg.sender] = true;
    }

    function projectAdminClaimProjectFunding(uint projectIdParam) public
    {
        require(actualPhase == 3, "Not ready to claim project funding yet.");
        require(!projectsFunddingClaimed[projectIdParam], "Project admin already claimed funding.");
        require(getProjectAdmin(projectIdParam) == msg.sender, "Caller not admin of the project.");

        uint funddedAmount = projectsFundding[projectIdParam];
        (bool sent, bytes memory data) = (msg.sender).call{value: funddedAmount}("");
        require(sent, "Failed to send funds");

        projectsFunddingClaimed[projectIdParam] = true;
    }

    function endPhase0() public
    {
        require(actualPhase == 0, "Not on the correct phase.");
        require(msg.sender == admin, "Caller not roundAdmin.");

        actualPhase++;
    }

    function endPhase1() public
    {
        require(actualPhase == 1, "Not on the correct phase.");
        require(msg.sender == admin, "Caller not roundAdmin.");

        actualPhase++;
    }

    function endPhase2() public
    {
        require(actualPhase == 2, "Not on the correct phase.");
        require(msg.sender == admin, "Caller not roundAdmin.");

        actualPhase++;
    }

    function getProjectData(uint projectIdParam) public view returns(projectData memory)
    {
        return projects[projectIdParam];
    }

    function getProjectName(uint projectIdParam) public view returns(string memory)
    {
        return projects[projectIdParam].projectName;
    }

    function getProjectDescription(uint projectIdParam) public view returns(string memory)
    {
        return projects[projectIdParam].projectDescription;
    }

    function getProjectAdmin(uint projectIdParam) public view returns(address)
    {
        return projects[projectIdParam].projectAdmin;
    }

    function getWorldIdFunddedCounterForSignal(uint256 nullifierHashParam) public view returns(uint)
    {
        return worldFunndedCounter[nullifierHashParam];
    }
}