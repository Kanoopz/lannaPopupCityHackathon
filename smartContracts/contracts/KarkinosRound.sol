//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

interface liquidStaking
{}

interface reestaking
{}

interface IWorldId
{}

contract KarkinosRound
{
    struct projectData
    {
        uint projectId;
        string projectName;
        string projectDescription;
        address projectAdmin;
    }

    IWorldId worldIdRouter;

    uint permmitedFundingPerAddress;
    uint ethDonated;
    uint nextProjectId;
    uint actualPhase; // 0 for projectRegistration, 1 for preFunding, 2 for postFunding ///

    mapping(address => uint) addressfunddedCounter;
    mapping(uint => projectData) projects;
    
    // mapping(uint => uint) ¿¿¿¿FUND OR VOTE????

    constructor(address worldIdRouterAddressParam, uint fundingQuantityParam)
    {
        worldIdRouter = IWorldId(worldIdRouterAddressParam);
        permmitedFundingPerAddress = fundingQuantityParam;
    }

    function registerProject(string memory projectNameParam, string memory projectDescriptionParam) public
    {
        projectData memory newProject = projectData(nextProjectId, projectNameParam, projectDescriptionParam, msg.sender);
        projects[nextProjectId] = newProject;
        nextProjectId++;
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
}