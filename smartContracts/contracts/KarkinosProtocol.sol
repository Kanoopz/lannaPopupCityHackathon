//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////    "IMPORTS"                                                                                                                                 //////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import { KarkinosRound } from "./KarkinosRound.sol";

contract KarkinosProtocol
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////    "STRUCTS"                                                                                                                                 //////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    struct roundData
    {
        uint roundId;
        address roundAddress;
        uint creationTimestamp;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////    "storageVariables"                                                                                                                        //////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////
    //    "VARIABLES"                                ///
    ////////////////////////////////////////////////////
    uint nextRoundId = 0;

    address worldIdRouterAddress = 0x469449f251692E0779667583026b5A1E99512157;
    address lidoLiquidStakingAddress = 0xeAde2E3f4C3226f90206c0b5BFa6A689BC478BC0;
    address renzoReestakingAddress = 0x646FbcfE3cFc4cADb99c4adD4C07FD7E558cfae4;

    ////////////////////////////////////////////////////
    //    "MAPPINGS"                                 ///
    ////////////////////////////////////////////////////
    mapping(uint => roundData) rounds;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////    "FUNCTIONS"                                                                                                                               //////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    function createNewRound(uint permittedFundingPerAddressParam,  string memory _appId, string memory _actionId) public
    {
        KarkinosRound newRound = new KarkinosRound(msg.sender, _appId, _actionId, permittedFundingPerAddressParam);
        address newRoundAddress = address(newRound);

        roundData memory newRoundData = roundData(nextRoundId, newRoundAddress, block.timestamp);

        rounds[nextRoundId] = newRoundData;

        nextRoundId++;
    }

    function getRoundData(uint roundIdParam) public view returns(roundData memory)
    {
        return rounds[roundIdParam];
    }

    function getRoundAddress(uint roundIdParam) public view returns(address)
    {
        return rounds[roundIdParam].roundAddress;
    }

    function getRoundCreationTimestamp(uint roundIdParam) public view returns(uint)
    {
        return rounds[roundIdParam].creationTimestamp;
    }
}