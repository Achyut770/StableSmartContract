// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/stableCoin.sol";

// Address = 0x82A69E25a60D487447B32d7e9e1425e85ab4D8e9
//Hash = 0x219abe90c84f58f410679930f745f0a6f59d71078b46ddeb57c8af9c33a7b327

contract StableCoinScript is Script {
    Stablecoin stableCoin;

    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        console.log("Private Key", privateKey);
        address account = vm.addr(privateKey);
        console.log("Account", account);
        vm.startBroadcast(privateKey);

        new Stablecoin();

        vm.stopBroadcast();
    }
}
