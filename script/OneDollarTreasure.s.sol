// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {Script, console} from "forge-std/Script.sol";
import "../src/contracts/OneDollarTreasure.sol";
import "../src/access/proxy/Proxy.sol";

contract OneDollarTreasureScript is Script {
    OneDollarTreasure  public oneDollarTreasure;

    Proxy public proxyOneDollarTreasure;

    function run() public {
        vm.startBroadcast();
        address admin = msg.sender;

        IERC20 tokenAddress = IERC20(address(0xe3b4ECd2EC88026F84cF17fef8bABfD9184C94F0));

        oneDollarTreasure = new OneDollarTreasure();
        proxyOneDollarTreasure = new Proxy(address(oneDollarTreasure), address(admin), "");
        OneDollarTreasure(address(proxyOneDollarTreasure)).initialize(tokenAddress);

        vm.stopBroadcast();
    }
}
