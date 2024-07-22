/// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";

/// @title A contract for suppliers/sellers to list their product(s) on the market
/// @author Quan Hoang

contract Product is AccessControl {
    /* --------------------------------------------- DATA FIELDS --------------------------------------------- */ 
    // Data type to store weather condition
    struct WeatherCondition {
        uint256 temperature; // Recorded temperature at transit point
        string description; // Description of the weather at transit point
        uint256 date; // The date the product arrives at the transit point
        string transitPoint; // Name of the transit point
    }

    string sku; // Stock-keeping unit for the product
    string name; // Name of the product
    string description; // Description of the product
    uint256 quantity; // The quantity of the product
    uint256 productionDate; // The date when the product is produced in UNIX
    uint256 expiryDate; // The date when the product is expired in UNIX
    WeatherCondition latestWeatherCondition; // Last recorded weather condition at the last transit point

    /* --------------------------------------------- FUNCTIONS --------------------------------------------- */ 
    /// @notice constructor to create a product
    /// @param _manager manager of the product
    /// @param _sku stock keeping unit
    /// @param _name name of the product
    /// @param _description description of the product
    /// @param _productionDate date the product is produced in UNIX
    /// @param _expiryDate date the product is expired in UNIX
    constructor(
        address _manager,
        string memory _sku,
        string memory _name,
        string memory _description,
        uint256 _quantity,
        uint256 _productionDate,
        uint256 _expiryDate
    ) AccessControl(_manager) {
        sku = _sku;
        name = _name;
        description = _description;
        quantity = _quantity;
        productionDate = _productionDate;
        expiryDate = _expiryDate;
    }

    /// @notice Get the details of the product
    /// @return stock keeping unit
    /// @return name of the product
    /// @return description of the product
    /// @return quantity of the product
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
            uint256,
            WeatherCondition memory
        )
    {
        return (
            sku,
            name,
            description,
            quantity,
            productionDate,
            expiryDate,
            latestWeatherCondition
        );
    }

    /// @notice set a new weather condition when the product arrives at a new transit point
    /// @param _temperature recorded temperature at transit point
    /// @param _description description of the weather at transit point
    /// @param _date the date the product arrives at the transit point
    /// @param _transitPoint name of the transit point
    function setWeatherCondition(
        uint256 _temperature,
        string memory _description,
        uint256 _date,
        string memory _transitPoint
    ) public onlyManager {
        latestWeatherCondition = WeatherCondition(
            _temperature,
            _description,
            _date,
            _transitPoint
        );
    }
}
