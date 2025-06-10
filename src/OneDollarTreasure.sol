// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "forge-std/console.sol";

import "./OneDollarTreasureStorage.sol";
import "./interfaces/IOneDollarTreasure.sol";


contract OneDollarTreasure is  Initializable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, IOneDollarTreasure, OneDollarTreasureStorage {
    address public constant TheWeb3TreasureAddress = address(0xe3b4ECd2EC88026F84cF17fef8bABfD9184C94F0);

    using SafeERC20 for IERC20;

    uint32 public periodTime;

    IERC20 public tokenAddress;

    function initialize(IERC20 _tokenAddress) public initializer {
        roundNumber = 1;
        roundAmount = 0;
        periodTime = 21 days;
        roundEndTime[roundNumber] = block.timestamp + periodTime;
        tokenAddress = _tokenAddress;
    }

    function betting(address better, uint256 amount) external nonReentrant {
        if (IERC20(tokenAddress).balanceOf(better) < amount) {
            revert NotEnoughToken(address(tokenAddress));
        }
        if (amount < 10 ** 6) {
            revert NotRightAmountToken(address(tokenAddress));
        }

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

        tokenAddress.safeTransferFrom(better, address(this), amount);

        emit BettingInfo(
            better,
            amount
        );
    }

    function lotteryAndGenerateNewRound(uint256 roundSeed) external nonReentrant {
        if (block.timestamp < roundEndTime[roundNumber]) {
            revert ThisPeriodNoExpiration();
        }
        address[] memory addressList = bettingMembers[roundNumber];

        address rewardAddress = addressList[roundSeed];
        uint256 rewardAmount = (roundBetting[roundNumber].totalAmount * 95) / 100;
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

        roundEndTime[roundNumber] = block.timestamp + periodTime;
    }

    function getBettingRound(uint256 roundNumber) view external returns (RoundBettingInfo memory) {
        return roundBetting[roundNumber];
    }
}
