pragma solidity ^0.8.0;

import "../src/GovernanceContract.sol";
import "../src/reserveContract.sol";
import "../src/stableCoin.sol";
import "../src/USDT.sol";
import "../src/WETH.sol";
import "forge-std/Test.sol";

contract GovernanceToken is Test {
    Governance governance;
    Stablecoin stablecoin;
    ReserveContract reserveContract;
    USDT usdt;
    WETH weth;

    function setUp() public {
        stablecoin = new Stablecoin();
        reserveContract = new ReserveContract();
        governance = new Governance(address(reserveContract), address(stablecoin));
        usdt = new USDT();
        weth = new WETH();
    }

    function testValidatePegErrorNotOwner() public {
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", address(1)));
        vm.prank(address(1));
        governance.validatePeg();
    }

    event ValidatePeg(string indexed method, uint time, uint256 reserveValue, uint256 stableTotalSupply);

    function testPegPrice() public {
        (uint256 usdt_price, uint256 eth_price) = governance.getPrice();

        uint256 totalSupply = stablecoin.totalSupply();

        usdt.approve(address(reserveContract), 1e10 * 1e18);
        reserveContract.deposit(address(usdt), 1e5 * 1e18);

        weth.approve(address(reserveContract), 1e10 * 1e18);
        reserveContract.deposit(address(weth), 1e5 * 1e18);

        reserveContract.transferOwnership(address(governance));
        stablecoin.transferOwnership(address(governance));

        uint256 totalValuePegged = usdt_price * 1e5 * 1e18 / 1e8 + eth_price * 1e5 * 1e18 / 1e8;

        vm.expectEmit(true, false, false, true);
        emit ValidatePeg("Mint",block.timestamp, totalValuePegged, totalSupply);

        governance.validatePeg();

        assertEq(stablecoin.totalSupply(), totalValuePegged);
    }
}
