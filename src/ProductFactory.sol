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
    event ProductCreated(string sku); // Events to announce whenever a product is created

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */ 
    /// @notice constructor to create the product factory
    /// @param _registryAddress the address of the registry
    constructor(address _registryAddress) AccessControl(msg.sender) {
        registry = Registry(_registryAddress);
    }

    /// @notice create a new product and log its contract into the registry
    /// @param _sku stock keeping unit
    /// @param _name name of the product
    /// @param _description description of the product
    /// @param _productionDate date the product is produced in UNIX
    /// @param _expiryDate date the product is expired in UNIX
    /// @param _minCTemperature minimum allowed temperature in C
    /// @param _maxCTemperature maximum allowed temperature in C
    /// @return The address for the contract of the new product
    function createProduct(
        string memory _sku,
        string memory _name,
        string memory _description,
        uint _productionDate,
        uint _expiryDate,
        uint256 _minCTemperature,  
        uint256 _maxCTemperature
    ) public onlyManager returns (address) {
        Product newProduct = new Product(
            msg.sender,
            _sku,
            _name,
            _description,
            _productionDate,
            _expiryDate,
            _minCTemperature,  
            _maxCTemperature
        );
        
        registry.registerProduct(address(newProduct), _sku);
        emit ProductCreated(_sku);

        return address(newProduct);
    }
}
