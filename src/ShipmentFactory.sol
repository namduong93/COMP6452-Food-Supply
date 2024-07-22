// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";
import "./Shipment.sol";
import "./Registry.sol";

/// @title A factory to product product contracts
/// @author Quan Hoang

contract ShipmentFactory is AccessControl {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */ 
    Registry public registry; // The registry to register the new shipment contract

    /* --------------------------------------------- EVENTS --------------------------------------------- */ 
    event ShipmentCreated(string shipmentCode); // Events to announce whenever a shipment is created

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */ 
    /// @notice constructor to create the shipment factory
    /// @param _registryAddress the address of the registry
    constructor(address _registryAddress) AccessControl(msg.sender) {
        registry = Registry(_registryAddress);
    }

    /// @notice create a new shipment and log its contract into the registry
    /// @param _shipmentCode code for the shipment
    /// @param _receiver receiver of the shipment
    /// @param _productAddress address of the product being shipped
    /// @param _locations starting point, delivery points, and final destination for the shipment
    /// @return The address for the contract of the new shipment
    function createShipment(
        string memory _shipmentCode,
        address _receiver,
        address _productAddress,
        string[] memory _locations
    ) public onlyManager returns (address) {
        Shipment newShipment = new Shipment(
            msg.sender,
            _shipmentCode,
            _receiver,
            _productAddress,
            _locations
        );

        registry.registerShipment(address(newShipment), _shipmentCode);
        emit ShipmentCreated(_shipmentCode);

        return address(newShipment);
    }
}
