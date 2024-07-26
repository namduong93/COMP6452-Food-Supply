/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import "./AccessControl.sol";

/// @title A contract for suppliers/sellers to list their product(s) on the market
/// @author Quan Hoang

contract Product is AccessControl {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */
    // Data type to store the allowed weather condition fot this product
    struct AllowedWeatherCondition {
        int256 minCTemperature; // Minimum allowed temperature in C
        int256 maxCTemperature; // Maximum allowed temperature in C
    }

    uint256 sku; // Stock-keeping unit for the product
    string name; // Name of the product
    string description; // Description of the product
    AllowedWeatherCondition allowedWeatherCondition; // The allowed weather condition for this product

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */
    /// @notice constructor to create a product
    /// @param _manager manager of the product
    /// @param _sku stock keeping unit
    /// @param _name name of the product
    /// @param _description description of the product
    /// @param _minCTemperature minimum allowed temperature in C
    /// @param _maxCTemperature maximum allowed temperature in C
    constructor(
        address _manager,
        uint256 _sku,
        string memory _name,
        string memory _description,
        int256 _minCTemperature,
        int256 _maxCTemperature
    ) AccessControl(_manager) {
        sku = _sku;
        name = _name;
        description = _description;
        allowedWeatherCondition = AllowedWeatherCondition(_minCTemperature, _maxCTemperature);
    }

    /// @notice Get the details of the product
    /// @return stock keeping unit
    /// @return name of the product
    /// @return description of the product
    /// @return the last recorded weather condition where the product is shipped
    function getProductDetails()
        public
        view
        returns (uint256, string memory, string memory, AllowedWeatherCondition memory)
    {
        return (sku, name, description, allowedWeatherCondition);
    }

    /// @notice Get the allowed weather condition for the product
    function getAllowedWeatherCondition() external view returns (AllowedWeatherCondition memory) {
        return allowedWeatherCondition;
    }
}
