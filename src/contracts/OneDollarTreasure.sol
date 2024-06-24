// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./OneDollarTreasureStorage.sol";
import "forge-std/console.sol";

contract OneDollarTreasure is  Initializable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, OneDollarTreasureStorage {
    address public constant TheWeb3TreasureAddress = address(0xe3b4ECd2EC88026F84cF17fef8bABfD9184C94F0);

    using SafeERC20 for IERC20;

    function initialize() public initializer {
        roundNumber = 1;
        roundAmount = 0;
    }

    function betting(IERC20 tokenAddress, address better, uint256 amount) external {
        if (IERC20(tokenAddress).balanceOf(better) < amount) {
            revert NotEnoughToken(address(tokenAddress));
        }
        if (amount <= 10) {
            revert NotRightAmountToken(address(tokenAddress));
        }
        console.log("OneDollar", address(this));
        tokenAddress.safeTransferFrom(better, address(this), amount);
        if (roundBetting[roundNumber].totalAmount <= 0) {
            RoundBettingInfo memory rBInfo = RoundBettingInfo({
                totalAmount: amount,
                status:0
            });
            roundBetting[roundNumber] = rBInfo;
        } else {
            roundBetting[roundNumber].totalAmount += amount;
        }
        bettingMembers[roundNumber].push(better);
        emit BettingInfo(
            better,
            amount
        );
    }

    function lotteryAndGenerateNewRound(IERC20 tokenAddress, uint256 roundSeed) external {
        address[] memory addressList = bettingMembers[roundNumber];

        address rewardAddress = addressList[roundSeed];
        uint256 rewardAmount = (roundBetting[roundNumber].totalAmount * 90) / 100;
        uint256 middleFee =  roundBetting[roundNumber].totalAmount - rewardAmount;

        if (roundSeed > addressList.length) {
            revert RoundNumberIsBig();
        }

        tokenAddress.safeTransferFrom(address(this), rewardAddress, rewardAmount);

        tokenAddress.safeTransferFrom(address(this), TheWeb3TreasureAddress, middleFee);

        emit LotteryAndGenerateNewRound(
            rewardAddress,
            rewardAmount,
            middleFee,
            roundNumber
        );

        roundNumber++;
    }

    function getBettingRound(uint256 roundNumber) external returns (RoundBettingInfo memory) {
        return roundBetting[roundNumber];
    }
}
