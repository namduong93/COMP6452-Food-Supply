/// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";

/// @title A contract for suppliers/sellers to list their product(s) on the market
/// @author Quan Hoang

contract Product is AccessControl {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */
    // Data type to store the allowed weather condition fot this product
    struct AllowedWeatherCondition {
        uint256 minCTemperature; // Minimum allowed temperature in C
        uint256 maxCTemperature; // Maximum allowed temperature in C
    }

    string sku; // Stock-keeping unit for the product
    string name; // Name of the product
    string description; // Description of the product
    uint256 productionDate; // The date when the product is produced in UNIX
    uint256 expiryDate; // The date when the product is expired in UNIX
    AllowedWeatherCondition allowedWeatherCondition; // The allowed weather condition for this product

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */
    /// @notice constructor to create a product
    /// @param _manager manager of the product
    /// @param _sku stock keeping unit
    /// @param _name name of the product
    /// @param _description description of the product
    /// @param _productionDate date the product is produced in UNIX
    /// @param _expiryDate date the product is expired in UNIX
    /// @param _minCTemperature minimum allowed temperature in C
    /// @param _maxCTemperature maximum allowed temperature in C
    constructor(
        address _manager,
        string memory _sku,
        string memory _name,
        string memory _description,
        uint256 _productionDate,
        uint256 _expiryDate,
        uint256 _minCTemperature,
        uint256 _maxCTemperature
    ) AccessControl(_manager) {
        sku = _sku;
        name = _name;
        description = _description;
        productionDate = _productionDate;
        expiryDate = _expiryDate;
        allowedWeatherCondition = AllowedWeatherCondition(
            _minCTemperature,
            _maxCTemperature
        );
    }

    /// @notice Get the details of the product
    /// @return stock keeping unit
    /// @return name of the product
    /// @return description of the product
    /// @return date the product is produced in UNIX
    /// @return date the product is expired in UNIX
    /// @return the last recorded weather condition where the product is shipped
    function getProductDetails()
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256,
            uint256,
            AllowedWeatherCondition memory
        )
    {
        return (
            sku,
            name,
            description,
            productionDate,
            expiryDate,
            allowedWeatherCondition
        );
    }

    /// @notice Get the allowed weather condition for the product
    function getAllowedWeatherCondition()
        external
        view
        returns (AllowedWeatherCondition memory)
    {
        return allowedWeatherCondition;
    }
}
