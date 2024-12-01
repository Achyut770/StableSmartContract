// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/reserveContract.sol";

//Address = 0x5814A7a953c83E1E65d04cC6D8962Bf99f156C39
//Hash=0xdffab7e512fd55d2ac00a8803903e0ccb4ef7c6fde7fe32228801365a0f3ac0e

contract GovernanceContract is Script {
    ReserveContract reserveContract;

    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        new ReserveContract();

        vm.stopBroadcast();
    }
}
