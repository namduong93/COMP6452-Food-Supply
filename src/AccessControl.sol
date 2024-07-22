// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract AccessControl {
    address public manager;

    constructor(address _manager) {
        manager = _manager;
    }

    error Unauthorized(address caller);

    modifier onlyManager() {
        if (msg.sender != manager) {
            revert Unauthorized(msg.sender);
        }
        _;
    }
}
