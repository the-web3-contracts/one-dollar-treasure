// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

abstract contract OneDollarTreasureStorage {
    uint256 public roundNumber;
    uint256 public roundAmount;

    struct RoundBettingInfo {
        uint256 totalAmount;
        uint status;           // 0: outgoing, 1:end
    }

    mapping(uint256 => RoundBettingInfo) public roundBetting;
    mapping(uint256 => address[]) public bettingMembers;
    mapping(uint256 => uint256) public roundEndTime;


    event BettingInfo(
        address indexed msgSender,
        uint256 amount
    );

    event LotteryAndGenerateNewRound(
        address indexed rewardAddress,
        uint256 rewardAmount,
        uint256 middleFee,
        uint256 roundNumber
    );

    error NotEnoughToken(address ERC20Address);
    error NotRightAmountToken(address ERC20Address);
    error RoundNumberIsBig();
    error ThisPeriodNoExpiration();
}
