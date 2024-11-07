//SPDX-License-Identifier

import { IERC20 } from "./IERC20.sol";

pragma solidity 0.8.24;

contract GearboxProtocol
{
    address ezEthAddress = 0x646FbcfE3cFc4cADb99c4adD4C07FD7E558cfae4;

    function provideLiquidityToCurve(uint256 ezETHAmount, uint16 leverageFactor) public
    {
        IERC20(ezEthAddress).transferFrom(msg.sender, address(this), ezETHAmount);
    }
}