//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RenzoMockup is ERC20, Ownable
{
    constructor(address initialOwner) ERC20("ezEth", "ezEth") Ownable(initialOwner)
    {}

    function deposit(address staker, IERC20 token, uint tokenAmount) public returns(uint256 shares)
    {
        token.transferFrom(staker, address(this), tokenAmount);
        _mint(staker, tokenAmount);
        
        return tokenAmount;
    }

    function mint(address to, uint256 amount) public 
    {
        _mint(to, amount);
    }
}