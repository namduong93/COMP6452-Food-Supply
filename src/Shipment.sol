// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

/// @title Contract to manage shipments with scheduled location updates in seconds
/// @author 

contract Shipment {
    address public manager; // Contract manager

    // Data type to store shipment details
    struct ShipmentDetails {
        uint id; // Shipment ID
        string deliveryName; // Delivery name for the shipment
        string location; // Current location of the shipment
        string targetLocation; // Target location to move to
        uint moveTimestamp; // Timestamp in seconds when the location should change
    }

    uint public shipmentCount; // Counter to keep track of shipment IDs
    mapping(uint => ShipmentDetails) public shipments; // Mapping to store shipment details by ID

    // Define an event to be emitted when a shipment's location is updated
    event LocationUpdated(uint id, string newLocation);

    /// @notice Constructor to set the manager of the contract
    constructor() {
        manager = msg.sender;
        shipmentCount = 0; // Initialize shipment counter
    }

    /// @notice Create a new shipment with a delivery name and location
    /// @param _deliveryName Name of the delivery for the shipment
    /// @param _location Location of the shipment
    /// @return The ID of the newly created shipment
    function createShipment(string memory _deliveryName, string memory _location) public returns (uint) {
        require(msg.sender == manager, "Only the manager can create a shipment"); // Access control
        shipmentCount++;
        uint shipmentId = shipmentCount; // Use a simple incrementing ID
        shipments[shipmentId] = ShipmentDetails(shipmentId, _deliveryName, _location, "", 0);
        return shipmentId;
    }

    /// @notice Move the shipment to a new location after a specified number of seconds
    /// @param _shipmentId ID of the shipment to update
    /// @param _seconds Number of seconds after which the location should change
    /// @param _targetLocation Target location to move to
    function moveShipment(uint _shipmentId, uint _seconds, string memory _targetLocation) public {
        require(msg.sender == manager, "Only the manager can move the shipment"); // Access control
        require(_shipmentId > 0 && _shipmentId <= shipmentCount, "Shipment ID is invalid");

        uint temp_c = 20; // Hard-coded temperature value for this example
        require(temp_c >= 15 && temp_c <= 25, "Temperature is not suitable for departure");

        ShipmentDetails storage shipment = shipments[_shipmentId];
        shipment.targetLocation = _targetLocation;
        shipment.moveTimestamp = block.timestamp + _seconds; // Add the delay in seconds to the current timestamp

        // Emit event to log the update
        emit LocationUpdated(_shipmentId, shipment.location);
    }

    /// @notice Check if the location should be updated and perform the update if necessary
    /// @param _shipmentId ID of the shipment to check
    function updateShipmentLocation(uint _shipmentId) public {
        require(_shipmentId > 0 && _shipmentId <= shipmentCount, "Shipment ID is invalid");

        ShipmentDetails storage shipment = shipments[_shipmentId];

        if (block.timestamp >= shipment.moveTimestamp && shipment.moveTimestamp != 0) {
            shipment.location = shipment.targetLocation;
            shipment.targetLocation = ""; // Clear target location after update
            shipment.moveTimestamp = 0; // Reset timestamp
            emit LocationUpdated(_shipmentId, shipment.location); // Emit event
        }
    }

    /// @notice Get the details of a shipment by ID
    /// @param _shipmentId ID of the shipment
    /// @return deliveryName The delivery name of the shipment
    /// @return location The current location of the shipment
    /// @return targetLocation The target location to move to
    /// @return moveTimestamp The timestamp in seconds when the location should change
    function getShipmentDetails(uint _shipmentId) public view returns (string memory deliveryName, string memory location, string memory targetLocation, uint moveTimestamp) {
        require(_shipmentId > 0 && _shipmentId <= shipmentCount, "Shipment ID is invalid");
        ShipmentDetails memory details = shipments[_shipmentId];
        return (details.deliveryName, details.location, details.targetLocation, details.moveTimestamp);
    }
}
