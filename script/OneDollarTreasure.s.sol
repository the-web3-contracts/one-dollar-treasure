// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {Script, console} from "forge-std/Script.sol";
import "../src/OneDollarTreasure.sol";
import "../src/access/proxy/Proxy.sol";

contract OneDollarTreasureScript is Script {
    OneDollarTreasure  public oneDollarTreasure;

    Proxy public proxyOneDollarTreasure;

    function run() public {
        vm.startBroadcast();
        address admin = msg.sender;

        IERC20 tokenAddress = IERC20(address(0x8A791620dd6260079BF849Dc5567aDC3F2FdC318));

        oneDollarTreasure = new OneDollarTreasure();

        proxyOneDollarTreasure = new Proxy(address(oneDollarTreasure), address(admin), "");

        console.log("oneDollarTreasure===", address(oneDollarTreasure));
        console.log("proxyOneDollarTreasure===", address(proxyOneDollarTreasure));

        OneDollarTreasure(address(proxyOneDollarTreasure)).initialize(tokenAddress);


        vm.stopBroadcast();
    }
}
