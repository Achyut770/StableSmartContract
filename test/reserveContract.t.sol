pragma solidity ^0.8.0;

import "../src/WETH.sol";
import "../src/reserveContract.sol";
import "../src/USDT.sol";
import "forge-std/Test.sol";
import "@openzeppelin/access/Ownable.sol";

contract ReserveTest is Test {
    WETH weth;
    USDT usdt;
    ReserveContract reserveContract;

    function setUp() public {
        weth = new WETH();
        usdt = new USDT();
        reserveContract = new ReserveContract();
    }

    function testDeposit() public {
        weth.approve(address(reserveContract), 1e5 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);

        (address collataral, uint256 amount) = reserveContract.rsvMap(0);
        assertEq(collataral, address(weth));
        assertEq(amount, 1e5 * 1e18);
    }

    function testDepositNotOnwer() public {
        weth.approve(address(reserveContract), 1e5 * 1e18);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", address(1)));
        vm.prank(address(1));
        reserveContract.deposit(address(weth), 1e5 * 1e18);
    }

    function testDepositAlreadyExist() public {
        weth.approve(address(reserveContract), 1e10 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);
        vm.expectRevert(ReserveContract.ColateralAlreadyExist.selector);
        reserveContract.deposit(address(weth), 1e5 * 1e18);
    }

    function testAddCollateralNotOnwer() public {
        weth.approve(address(reserveContract), 1e5 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", address(1)));

        vm.prank(address(1));

        reserveContract.addCollateralAmount(0, 1e5 * 1e18);
    }

    function testAddCollataral() public {
        weth.approve(address(reserveContract), 1e10 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);

        reserveContract.addCollateralAmount(0, 1e5 * 1e18);
        (address collataral, uint256 amount) = reserveContract.rsvMap(0);
        assertEq(collataral, address(weth));
        assertEq(amount, 2e5 * 1e18);
    }

    function testMoreAmountWithdraw() public {
        weth.approve(address(reserveContract), 1e5 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);
        vm.expectRevert(ReserveContract.WithdrawError.selector);
        reserveContract.withdraw(1e6 * 1e18, 0);
    }

    function testWithdrawNotOnwer() public {
        weth.approve(address(reserveContract), 1e5 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", address(1)));
        vm.prank(address(1));
        reserveContract.withdraw(0, 1e5 * 1e18);
    }

    function testWithdraw() public {
        weth.approve(address(reserveContract), 1e5 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);
        reserveContract.withdraw(1e5 * 1e18, 0);

        (, uint256 amount) = reserveContract.rsvMap(0);
        assertEq(amount, 0);
    }
}
