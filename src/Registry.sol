// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

/// @title A contract registry to keep track of individual contracts for different products and shipments
/// @author Quan Hoang

contract Registry {
    // Two arrays to store the addresses for deployed products and shipments
    address[] public products;
    address[] public shipments;

    // Events to announce whenever a product/shipment is registered
    event ProductRegistered(address productAddress);
    event ShipmentRegistered(address shipmentAddress);

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
}
