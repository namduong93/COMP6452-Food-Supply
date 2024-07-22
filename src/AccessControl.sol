// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract AccessControl {
    // Array for all managers of this contract
    address[] managers;

    /// @notice constructor to create the overall access control to the product/shipment
    /// @param _manager first manager/creator of the contract
    constructor(address _manager) {
        managers.push(_manager);
    }

    // custom error
    error Unauthorized(address);

    /// @notice modifier to check if sender is a manager
    modifier onlyManager() {
        bool isManager = false;

        for (uint i = 0; i < managers.length; i++) {
            if (managers[i] == msg.sender) {
                isManager = true;
                break;
            }
        }

        if (!isManager) {
            revert Unauthorized(msg.sender);
        }

        _;
    }

    /// @notice add a new manager to the contract
    /// @param _manager new manager/creator of the contract
    function addManager(address _manager) public onlyManager {
        managers.push(_manager);
    }

    /// @notice get all managers of the contract
    function getManagers() public view returns(address[] memory) {
        return managers;
    }
}
