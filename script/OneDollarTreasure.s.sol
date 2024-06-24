// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {Script, console} from "forge-std/Script.sol";
import "../src/contracts/OneDollarTreasure.sol";

contract CounterScript is Script {
    OneDollarTreasure  public oneDollarTreasure;

    Proxy public proxyOneDollarTreasure;

    function run() public {
        vm.broadcast();
        address admin = msg.sender;

        oneDollarTreasure = new OneDollarTreasure();
        proxyOneDollarTreasure = new Proxy(address(oneDollarTreasure), address(admin), "");
        OneDollarTreasure(address(proxyOneDollarTreasure)).initialize();

        vm.stopBroadcast();
    }
}
