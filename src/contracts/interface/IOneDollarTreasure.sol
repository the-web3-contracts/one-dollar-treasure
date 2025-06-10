// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../OneDollarTreasureStorage.sol";

interface IOneDollarTreasure {
    function betting(address better, uint256 amount) external;
    function lotteryAndGenerateNewRound(uint256 roundSeed) external;
    function getBettingRound(uint256 roundNumber) view external returns (OneDollarTreasureStorage.RoundBettingInfo memory);
}
