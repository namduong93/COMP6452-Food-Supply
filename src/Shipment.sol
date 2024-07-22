// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";
import "./Product.sol";

/// @title Contract to manage shipments with scheduled location updates in seconds
/// @author

contract Shipment is AccessControl {
    string shipmentCode; // Code/Identifier for the shipment
    address productAddress; // Address to a deployed contract for a Product with all its details
    string currentLocation; // Current location of the shipment
    string targetLocation; // Target location to move to
    uint256 moveTimestamp; // Timestamp in seconds when the location should change

    // Define an event to be emitted when a shipment's location is updated
    event LocationUpdated(string newLocation);

    /// @notice constructor to create a new shipment
    /// @param _shipper shipper of the shipment
    /// @param _shipmentCode code for the shipment
    /// @param _productAddress address of the product being shipped
    /// @param _currentLocation starting location of the shipment
    /// @param _targetLocation target location/destination for the shipment
    constructor(
        address _shipper,
        string memory _shipmentCode,
        address _productAddress,
        string memory _currentLocation,
        string memory _targetLocation
    ) AccessControl(_shipper) {
        shipmentCode = _shipmentCode;
        productAddress = _productAddress;
        currentLocation = _currentLocation;
        targetLocation = _targetLocation;
        moveTimestamp = block.timestamp;
    }

    /// @notice Get the details of the location of a shipment
    /// @return code for the shipment
    /// @return address of the contract for the product
    /// @return current location of the shipment
    /// @return target location/destination for the shipment
    //  @return most recent time when the location is changed
    function getShipmentDetails()
        public
        view
        returns (
            string memory,
            address,
            string memory,
            string memory,
            uint256
        )
    {
        return (
            shipmentCode,
            productAddress,
            currentLocation,
            targetLocation,
            moveTimestamp
        );
    }

    /// @notice Move the shipment to a new location after a specified number of seconds
    /// @param _seconds Number of seconds after which the location should change
    /// @param _targetLocation Target location to move to
    function moveShipment(uint256 _seconds, string memory _targetLocation)
        public
        onlyManager
    {
        uint256 temp_c = 20; // Hard-coded temperature value for this example
        require(
            temp_c >= 15 && temp_c <= 25,
            "Temperature is not suitable for departure"
        );

        targetLocation = _targetLocation;
        moveTimestamp = block.timestamp + _seconds; // Add the delay in seconds to the current timestamp

        // Emit event to log the update
        emit LocationUpdated(currentLocation);
    }

    /// @notice Check if the location should be updated and perform the update if necessary
    function updateShipmentLocation() public {
        if (block.timestamp >= moveTimestamp && moveTimestamp != 0) {
            currentLocation = targetLocation;
            targetLocation = ""; // Clear target location after update
            moveTimestamp = 0; // Reset timestamp
            emit LocationUpdated(currentLocation); // Emit event
        }
    }
}
