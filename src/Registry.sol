// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

/// @title A contract registry to keep track of individual contracts for different products and shipments
/// @author Quan Hoang

contract Registry {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */
    // Arrays to store all the product SKUs and shipment codese
    address[] public products;
    address[] public shipments;

    /* --------------------------------------------- EVENTS --------------------------------------------- */
    event ProductRegistered(address productAddress); // Events to announce whenever a product is registered
    event ShipmentRegistered(address shipmentAddress); // Events to announce whenever a shipment is registered

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */
    /// @notice Register a product contract into the registry
    /// @param _productAddress The address for the product contract
    function registerProduct(address _productAddress) public {
        products.push(_productAddress);
        emit ProductRegistered(_productAddress);
    }

    /// @notice Register a shipment contract into the registry
    /// @param _shipmentAddress The address for the shipment contract
    function registerShipment(address _shipmentAddress) public {
        shipments.push(_shipmentAddress);
        emit ShipmentRegistered(_shipmentAddress);
    }

    /// @notice Get all SKUs for all listed products
    /// @return The array of all product SKUs
    function getProducts() public view returns (address[] memory) {
        return products;
    }

    /// @notice Get all shipment codes for all shipments
    /// @return The array of all shipment codes
    function getShipments() public view returns (address[] memory) {
        return shipments;
    }
}
