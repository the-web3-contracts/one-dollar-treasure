// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/contracts/OneDollarTreasure.sol";
import "../src/access/proxy/Proxy.sol";

import "./DappLinkToken.sol";


contract OneDollarTreasureTest is Script, Test {
    using SafeERC20 for IERC20;

    OneDollarTreasure  public oneDollarTreasure;
    DappLinkToken public dappLinkToken;

    Proxy public proxyOneDollarTreasure;
    Proxy public proxyDappLinkToken;

    function setUp() external {
        vm.startBroadcast();
        address admin = msg.sender;

        dappLinkToken = new DappLinkToken();
        proxyDappLinkToken = new Proxy(address(dappLinkToken), address(admin), "");
        DappLinkToken(address(proxyDappLinkToken)).initialize(admin);

        oneDollarTreasure = new OneDollarTreasure();
        proxyOneDollarTreasure = new Proxy(address(oneDollarTreasure), address(admin), "");
        OneDollarTreasure(address(proxyOneDollarTreasure)).initialize(IERC20(address(proxyDappLinkToken)));

        vm.stopBroadcast();
    }

    function testBetting() public {
        uint256 amount = 10 ** 6;
        vm.prank(msg.sender);
        DappLinkToken(address(proxyDappLinkToken)).approve(address(proxyOneDollarTreasure), amount * 10);

        vm.prank(msg.sender);
        OneDollarTreasure(address(proxyOneDollarTreasure)).betting(msg.sender, amount);

        OneDollarTreasure.RoundBettingInfo memory rBinfoItme = OneDollarTreasure(address(proxyOneDollarTreasure)).getBettingRound(1);

        assertEq(rBinfoItme.totalAmount, 1000000);
        assertEq(rBinfoItme.status, 0);
    }
}
