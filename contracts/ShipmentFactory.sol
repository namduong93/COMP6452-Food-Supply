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
    event ShipmentCreated(uint256 shipmentCode); // Events to announce whenever a shipment is created

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */ 
    /// @notice constructor to create the shipment factory
    /// @param _registryAddress the address of the registry
    constructor(address _registryAddress) AccessControl(msg.sender) {
        registry = Registry(_registryAddress);
    }

    /// @notice create a new shipment and log its contract into the registry
    /// @param _receiver receiver of the shipment
    /// @param _productAddress address of the product being shipped
    /// @param _productQuantity quantity of the product being shipped
    /// @param _productProdDate the date when this batch of product is produced
    /// @param _productExpDate the date when this batch of product will expire
    /// @param _locations starting point, delivery points, and final destination for the shipment
    /// @return The address for the contract of the new shipment
    function createShipment(
        address _receiver,
        address _productAddress,
        uint256 _productQuantity,
        uint256 _productProdDate,
        uint256 _productExpDate,
        string[] memory _locations
    ) public onlyManager returns (address) {
        // block timestamp as shipment code
        uint256 timestamp = block.timestamp;

        Shipment newShipment = new Shipment(
            msg.sender,
            timestamp,
            _receiver,
            _productAddress,
            _productQuantity,
            _productProdDate,
            _productExpDate,
            _locations
        );

        registry.registerShipment(address(newShipment), timestamp);
        emit ShipmentCreated(timestamp);

        return address(newShipment);
    }
}
