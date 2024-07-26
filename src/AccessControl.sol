// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract AccessControl {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */
    // Array for all managers of this contract
    mapping(address => bool) private managersMap;
    address[] managers;

    /* --------------------------------------------- EVENTS --------------------------------------------- */
    event ManagerAdded(address); // Events to announce a manager has been added

    /* --------------------------------------------- ERRORS --------------------------------------------- */
    error Unauthorized(address); // Error denoting that this address is not authorized/not a manager
    error ManagerAlreadyAdded(address); // Error indicating that this address is already a manager

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */
    /// @notice constructor to create the overall access control to the product/shipment
    /// @param _manager first manager/creator of the contract
    constructor(address _manager) {
        managersMap[_manager] = true;
        managers.push(_manager);
    }

    /// @notice modifier to check if sender is a manager
    modifier onlyManager() {
        if (!managersMap[msg.sender]) {
            revert Unauthorized(msg.sender);
        }
        _;
    }

    /// @notice add a new manager to the contract
    /// @param _manager new manager/creator of the contract
    function addManager(address _manager) public onlyManager {
        if (managersMap[_manager]) {
            revert ManagerAlreadyAdded(_manager);
        }

        managersMap[_manager] = true;
        managers.push(_manager);
        emit ManagerAdded(_manager);
    }

    /// @notice get all managers of the contract
    function getManagers() public view returns (address[] memory) {
        return managers;
    }
}
