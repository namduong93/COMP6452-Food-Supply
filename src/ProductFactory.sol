// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";
import "./Product.sol";
import "./Registry.sol";

/// @title A factory to product product contracts
/// @author Quan Hoang

contract ProductFactory is AccessControl {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */ 
    Registry public registry; // The registry to register the new product contract

    /* --------------------------------------------- EVENTS --------------------------------------------- */ 
    event ProductCreated(uint256 sku); // Events to announce whenever a product is created

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */ 
    /// @notice constructor to create the product factory
    /// @param _registryAddress the address of the registry
    constructor(address _registryAddress) AccessControl(msg.sender) {
        registry = Registry(_registryAddress);
    }

    /// @notice create a new product and log its contract into the registry
    /// @param _name name of the product
    /// @param _description description of the product
    /// @param _minCTemperature minimum allowed temperature in C
    /// @param _maxCTemperature maximum allowed temperature in C
    /// @return The address for the contract of the new product
    function createProduct(
        string memory _name,
        string memory _description,
        uint256 _minCTemperature,  
        uint256 _maxCTemperature
    ) public onlyManager returns (address) {
        // length of SKU array + 1 = new SKU
        uint256 newSKU = registry.getProductSKUs().length + 1;

        Product newProduct = new Product(
            msg.sender,
            newSKU,
            _name,
            _description,
            _minCTemperature,  
            _maxCTemperature
        );
        
        registry.registerProduct(address(newProduct), newSKU);
        emit ProductCreated(newSKU);

        return address(newProduct);
    }
}
