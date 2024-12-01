// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/access/Ownable.sol";

contract Stablecoin is ERC20, Ownable {
    constructor() ERC20("Achyut Adhikari", "Achyut") Ownable(msg.sender) {}

    function mint(uint256 _amount) external onlyOwner {
        _mint(msg.sender, _amount);
    }

    function burn(uint256 _amount) external onlyOwner {
        _burn(msg.sender, _amount);
    }
}
