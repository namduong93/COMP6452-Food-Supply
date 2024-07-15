/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title A contract for suppliers/sellers to list their product(s) on the market
/// @author Quan Hoang

contract Product {
    // Data type to store weather condition
    struct WeatherCondition {
        uint temperature; // Recorded temperature at transit point
        string description; // Description of the weather at transit point
        uint date; // The date the product arrives at the transit point
        string transitPoint; // Name of the transit point
    }

    address public supplier; // Product supplier/Contract manager
    string public sku; // Stock-keeping unit for the product
    string public name; // Name of the product
    string public description; // Description of the product
    uint public quantity; // Quantity of the product being sold/delivered
    uint public productionDate; // The date when the product is produced in UNIX
    uint public expiryDate; // The date when the product is expired in UNIX
    WeatherCondition public latestWeatherCondition; // Last recorded weather condition at the last transit point

    /// @notice constructor to create a product
    /// @param _sku stock keeping unit
    /// @param _name name of the product
    /// @param _description description of the product
    /// @param _quantity quantity to sell the product
    /// @param _productionDate date the product is produced in UNIX
    /// @param _expiryDate date the product is expired in UNIX
    constructor(
        string memory _sku,
        string memory _name,
        string memory _description,
        uint _quantity,
        uint _productionDate,
        uint _expiryDate
    ) {
        supplier = msg.sender;
        sku = _sku;
        name = _name;
        description = _description;
        quantity = _quantity;
        productionDate = _productionDate;
        expiryDate = _expiryDate;
    }

    /// @notice set a new weather condition when the product arrives at a new transit point
    /// @param _temperature recorded temperature at transit point
    /// @param _description description of the weather at transit point
    /// @param _date the date the product arrives at the transit point
    /// @param _transitPoint name of the transit point
    function setWeatherCondition(
        uint _temperature,
        string memory _description,
        uint _date,
        string memory _transitPoint
    ) public {
        latestWeatherCondition = WeatherCondition(_temperature, _description, _date, _transitPoint);
    }
}
