// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/GovernanceContract.sol";
import "../src/reserveContract.sol";
import "../src/stableCoin.sol";

//  Hash: 0x5acf04185d98faea1c2447f0cf0e610dbe1650bc79436b5ee08fa4ec4d46468d
// Contract Address: 0x193aafdE1cB1564d69764aB1733939a37702CDb7

contract GovernanceContract is Script {
    Governance governance;

    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        new Governance(0x5814A7a953c83E1E65d04cC6D8962Bf99f156C39, 0x82A69E25a60D487447B32d7e9e1425e85ab4D8e9);
        vm.stopBroadcast();
    }
}
