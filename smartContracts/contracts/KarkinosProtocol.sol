//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import { KarkinosRound } from "./KarkinosRound.sol";

contract KarkinosProtocol
{
    struct roundData
    {
        uint roundId;
        address roundAddress;
        uint creationTimestamp;
    }

    uint nextRoundId = 0;
    address worldIdRouterAddress;

    mapping(uint => roundData) rounds;

    

    function createNewRound(uint permittedFundingPerAddressParam) public
    {
        KarkinosRound newRound = new KarkinosRound(worldIdRouterAddress, permittedFundingPerAddressParam);
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