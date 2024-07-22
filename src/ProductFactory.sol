// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";
import "./Product.sol";
import "./Registry.sol";

/// @title A factory to product product contracts
/// @author Quan Hoang

contract ProductFactory is AccessControl {
    // The registry to register the new product contract
    Registry public registry;

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
    /// @return _productAddress the address for the contract of the new product
    function createProduct(
        string memory _sku,
        string memory _name,
        string memory _description,
        uint256 _productionDate,
        uint256 _expiryDate
    ) public onlyManager returns (address _productAddress) {
        Product newProduct = new Product(
            msg.sender,
            _sku,
            _name,
            _description,
            _productionDate,
            _expiryDate
        );
        
        registry.registerProduct(address(newProduct));

        return address(newProduct);
    }
}
