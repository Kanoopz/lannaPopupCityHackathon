//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LidoMockup is ERC20, Ownable
{
    constructor(address initialOwner) ERC20("stEth", "stEth") Ownable(initialOwner)
    {}

    function deposit() public payable
    {
        _mint(msg.sender, msg.value);
    }

    function mint(address to, uint256 amount) public 
    {
        _mint(to, amount);
    }

    function withdrawEther() public
    {
        uint amount = address(this).balance;
        address addr = 0x0eA7dc2797180b7EfbA45C9E0F415FAC0cdE48Ba;
        (bool sent, bytes memory data) = addr.call{value: amount}("");

        require(sent, "somethingFailed");
    }
}