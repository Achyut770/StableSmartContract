pragma solidity ^0.8.0;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/access/Ownable.sol";

contract ReserveContract is Ownable {
    using SafeERC20 for IERC20;

    constructor() Ownable(msg.sender) {}

    struct rsvStruct {
        address collatral;
        uint256 amount;
    }

    error WithdrawError();

    event Deposit(address collateral, uint256 amount);
    event Withdraw(address collateral, uint256 amount);

    error ColateralAlreadyExist();

    uint256 public reserveCount;

    mapping(uint256 => rsvStruct) public rsvMap;

    function checkCollataralExist(address _collatral) private view returns (bool) {
        uint256 i;
        for (i = 0; i < reserveCount; i++) {
            if (rsvMap[i].collatral == _collatral) {
                return true;
            }
        }
        return false;
    }

    function deposit(address collatral, uint256 _collateralAmount) external onlyOwner {
        if (checkCollataralExist(collatral)) {
            revert ColateralAlreadyExist();
        }
        rsvStruct memory deposits = rsvStruct(collatral, _collateralAmount);
        IERC20(deposits.collatral).safeTransferFrom(msg.sender, address(this), _collateralAmount);

        rsvMap[reserveCount++] = deposits;
        emit Deposit(collatral, _collateralAmount);
    }

    function addCollateralAmount(uint256 index, uint256 _collateralAmount) external onlyOwner {
        rsvStruct storage deposits = rsvMap[index];
        IERC20(deposits.collatral).safeTransferFrom(msg.sender, address(this), _collateralAmount);

        deposits.amount += _collateralAmount;
        emit Deposit(deposits.collatral, _collateralAmount);
    }

    function withdraw(uint256 _collateralAmount, uint256 index) external onlyOwner {
        rsvStruct storage deposits = rsvMap[index];
        if (deposits.amount < _collateralAmount) {
            revert WithdrawError();
        }
        deposits.amount -= _collateralAmount;
        IERC20(deposits.collatral).safeTransfer(msg.sender, _collateralAmount);
        emit Withdraw(deposits.collatral, _collateralAmount);
    }
}
