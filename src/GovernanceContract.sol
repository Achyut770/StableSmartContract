// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./reserveContract.sol";
import "./stableCoin.sol";

contract Governance is Ownable {
    address private immutable reserveContract;
    address private immutable stabelAddress;

    AggregatorV3Interface private constant usdtPriceChainLink =
        AggregatorV3Interface(0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E);
    AggregatorV3Interface private constant ethPriceChainlink =
        AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

    constructor(address _reserveContract, address _stabelAddress) Ownable(msg.sender) {
        reserveContract = _reserveContract;
        stabelAddress = _stabelAddress;
    }

    event ValidatePeg(string indexed method, uint time, uint256 reserveValue, uint256 stableTotalSupply);

    function getPrice() public view returns (uint256 usdt_price, uint256 eth_price) {
        (, int256 usdtPrice,,,) = usdtPriceChainLink.latestRoundData();
        (, int256 ethPrice,,,) = ethPriceChainlink.latestRoundData();
        usdt_price = uint256(usdtPrice);
        eth_price = uint256(ethPrice);
    }

    function validatePeg() external onlyOwner {
        (uint256 usdt_price, uint256 eth_price) = getPrice();

        (, uint256 usdt_amount) = ReserveContract(reserveContract).rsvMap(0);
        (, uint256 eth_amount) = ReserveContract(reserveContract).rsvMap(1);

        uint256 totalValueInCollateral = usdt_price * usdt_amount / 1e8 + eth_price * eth_amount / 1e8;
        uint256 totalSupply = IERC20(stabelAddress).totalSupply();
        if (totalSupply < totalValueInCollateral) {
            uint256 diff = totalValueInCollateral - totalSupply;
            Stablecoin(stabelAddress).mint(diff);
            emit ValidatePeg("Mint", block.timestamp, totalValueInCollateral, totalSupply);
        } else if (totalSupply > totalValueInCollateral) {
            uint256 diff = totalSupply - totalValueInCollateral;
            Stablecoin(stabelAddress).burn(diff);
            emit ValidatePeg("Burn", block.timestamp, totalValueInCollateral, totalSupply);
        }
    }
}
