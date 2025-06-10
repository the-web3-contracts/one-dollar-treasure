// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";


contract ProxyTimeLockController is TimelockController {
    constructor(
        uint256 minDelay,
        address[] memory proposers,
        address[] memory executors,
        address admin
    ) TimelockController(minDelay, proposers, executors, admin) {}

    function setRoleAdmin(
        bytes32 role,
        bytes32 adminRole
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _setRoleAdmin(role, adminRole);
    }

    function setRelayer(
        address pool,
        address _relayer
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        AccessControlUpgradeable(pool).grantRole(
            0x0685f9a33ecc8d58f6db2634bbe92aa174d2b8ca9e4e571760206f3509a84e00,
            _relayer
        );
    }
}
