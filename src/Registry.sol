// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

/// @title A contract registry to keep track of individual contracts for different products and shipments
/// @author Quan Hoang

contract Registry {
    // Arrays to store all the product SKUs and shipment codes
    string[] productSKUs;
    string[] shipmentCodes;

    // Mappings to store product by SKU and shipment by code
    mapping(string => address) products;
    mapping(string => address) shipments;

    // Events to announce whenever a product/shipment is registered
    event ProductRegistered(address productAddress);
    event ShipmentRegistered(address shipmentAddress);

    /// @notice Register a product contract into the registry
    /// @param _productAddress The address for the product contract
    /// @param _sku Stockeeping unit
    function registerProduct(address _productAddress, string memory _sku) public {
        productSKUs.push(_sku);
        products[_sku] = _productAddress;
        emit ProductRegistered(_productAddress);
    }

    /// @notice Register a shipment contract into the registry
    /// @param _shipmentAddress The address for the shipment contract
    /// @param _shipmentCode The code for the shipment
    function registerShipment(address _shipmentAddress, string memory _shipmentCode) public {
        shipmentCodes.push(_shipmentCode);
        shipments[_shipmentCode] = _shipmentAddress;
        emit ShipmentRegistered(_shipmentAddress);
    }

    /// @notice Get all SKUs for all listed products
    /// @return The array of all product SKUs
    function getProductSKUs() public view returns (string[] memory) {
        return productSKUs;
    }

    /// @notice Get all shipment codes for all shipments
    /// @return The array of all shipment codes
    function getShipmentCodes() public view returns (string[] memory) {
        return shipmentCodes;
    }

    /// @notice Get the address for the contract of a product using the SKU
    /// @param _sku Stockeeping unit
    /// @return The address for the contract of the product
    function getProductAddress(string memory _sku) public view returns (address) {
        return products[_sku];
    }

    /// @notice Get the address for the contract of a shipment using its code
    /// @param _shipmentCode The code for the shipment
    /// @return The address for the contract of the shipment
    function getShipmentAddress(string memory _shipmentCode) public view returns (address) {
        return products[_shipmentCode];
    }
}
