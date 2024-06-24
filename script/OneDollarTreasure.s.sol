// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/contracts/OneDollarTreasure.sol";

contract CounterScript is Script {
    OneDollarTreasure  public oneDollarTreasure;

    function run() public {
        vm.broadcast();

        oneDollarTreasure = new OneDollarTreasure();
        oneDollarTreasure.initialize();

        vm.stopBroadcast();
    }
}
