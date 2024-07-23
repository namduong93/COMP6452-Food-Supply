// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

/// @title A contract registry to keep track of individual contracts for different products and shipments
/// @author Quan Hoang

contract Registry {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */ 
    // Arrays to store all the product SKUs and shipment codes
    uint256[] productSKUs;
    uint256[] shipmentCodes;

    // Mappings to store product by SKU and shipment by code
    mapping(uint256 => address) products;
    mapping(uint256 => address) shipments;

    /* --------------------------------------------- EVENTS --------------------------------------------- */ 
    event ProductRegistered(address productAddress); // Events to announce whenever a product is registered
    event ShipmentRegistered(address shipmentAddress); // Events to announce whenever a shipment is registered

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */ 
    /// @notice Register a product contract into the registry
    /// @param _productAddress The address for the product contract
    /// @param _sku Stockeeping unit
    function registerProduct(address _productAddress, uint256 _sku) public {
        productSKUs.push(_sku);
        products[_sku] = _productAddress;
        emit ProductRegistered(_productAddress);
    }

    /// @notice Register a shipment contract into the registry
    /// @param _shipmentAddress The address for the shipment contract
    /// @param _shipmentCode The code for the shipment
    function registerShipment(address _shipmentAddress, uint256 _shipmentCode) public {
        shipmentCodes.push(_shipmentCode);
        shipments[_shipmentCode] = _shipmentAddress;
        emit ShipmentRegistered(_shipmentAddress);
    }

    /// @notice Get all SKUs for all listed products
    /// @return The array of all product SKUs
    function getProductSKUs() public view returns (uint256[] memory) {
        return productSKUs;
    }

    /// @notice Get all shipment codes for all shipments
    /// @return The array of all shipment codes
    function getShipmentCodes() public view returns (uint256[] memory) {
        return shipmentCodes;
    }

    /// @notice Get the address for the contract of a product using the SKU
    /// @param _sku Stockeeping unit
    /// @return The address for the contract of the product
    function getProductAddress(uint256 _sku) public view returns (address) {
        return products[_sku];
    }

    /// @notice Get the address for the contract of a shipment using its code
    /// @param _shipmentCode The code for the shipment
    /// @return The address for the contract of the shipment
    function getShipmentAddress(uint256 _shipmentCode) public view returns (address) {
        return shipments[_shipmentCode];
    }
}
