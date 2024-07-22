// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";
import "./Product.sol";

/// @title Contract to manage shipments with scheduled location updates in seconds
/// @author

contract Shipment is AccessControl {
    // Shipment status
    enum ShipmentStatus {
        PREPARING,
        SHIPPING,
        DELIVERED,
        VERIFIED
    }

    string shipmentCode; // Code/Identifier for the shipment
    address productAddress; // Address to a deployed contract for a Product with all its details
    uint256 currentLocation; // Current location of the shipment expressed as an index
    string[] locations; // Starting point, delivery points, and final destination for the shipment
    ShipmentStatus status; // Current status of the shipment
    uint256 moveTimestamp; // Timestamp in seconds when the shipment should arrive at the next location

    // Define an event to be emitted when a shipment's location is updated
    event LocationUpdated(string newLocation);

    // @notice custom error indicating that the shipment has been delivered
    error OrderDelivered(ShipmentStatus status);

    // @notice check whether the shipment has not been succesfully delivered
    modifier notDelivered() {
        if (status == ShipmentStatus.DELIVERED || status == ShipmentStatus.VERIFIED) {
            revert OrderDelivered(status);
        }
        _;
    }

    /// @notice constructor to create a new shipment
    /// @param _manager manager of the shipment
    /// @param _shipmentCode code for the shipment
    /// @param _productAddress address of the product being shipped
    /// @param _locations starting point, delivery points, and final destination for the shipment
    constructor(
        address _manager,
        string memory _shipmentCode,
        address _productAddress,
        string[] memory _locations
    ) AccessControl(_manager) {
        shipmentCode = _shipmentCode;
        productAddress = _productAddress;
        locations = _locations;
        currentLocation = 0; // Starting point so index 0
        status = ShipmentStatus.PREPARING;
        moveTimestamp = 0; // 0 also means the shipment is not being shipped so there is no "expected" arrive time
    }

    /// @notice Get the details of the location of a shipment
    /// @return _shipmentCode code for the shipment
    /// @return _productAddress address of the contract for the product
    /// @return _currentLocation current location of the shipment
    /// @return _locations starting point, delivery points, and final destination for the shipment
    /// @return _status current status of shipment
    //  @return _moveTimestamp time at which the shipment arrives at the next location
    function getShipmentDetails()
        public
        view
        returns (
            string memory,
            address,
            string memory,
            string[] memory,
            string memory,
            uint256
        )
    {
        return (
            shipmentCode,
            productAddress,
            locations[currentLocation],
            locations,
            printShipmentStatus(status),
            moveTimestamp
        );
    }

    /// @notice Move the shipment to a new location after a specified number of seconds
    /// @param _seconds Number of seconds after which the location should change
    function moveShipment(uint256 _seconds)
        public
        onlyManager
        notDelivered
    {
        uint256 temp_c = 20; // Hard-coded temperature value for this example
        require(
            temp_c >= 15 && temp_c <= 25,
            "Temperature is not suitable for departure"
        );

        status = ShipmentStatus.SHIPPING;
        moveTimestamp = block.timestamp + _seconds; // Add the delay in seconds to the current timestamp

        emit LocationUpdated(locations[currentLocation]); // Emit event to log the update
    }

    /// @notice Check if the location should be updated and perform the update if necessary
    function updateShipmentLocation() public notDelivered {
        if (block.timestamp >= moveTimestamp && moveTimestamp != 0) {
            // Move current location to the next one
            currentLocation++;

            if (currentLocation == locations.length - 1) {
                status = ShipmentStatus.DELIVERED;
            } else {
                status = ShipmentStatus.PREPARING;
            }

            moveTimestamp = 0; // Reset timestamp
            
            emit LocationUpdated(locations[currentLocation]); // Emit event to log the update
        }
    }

    // @notice Helper function to get the string representation of the status
    function printShipmentStatus(ShipmentStatus _status) public pure returns (string memory) {
        if (_status == ShipmentStatus.PREPARING) return "Preparing";
        if (_status == ShipmentStatus.SHIPPING) return "Shipping";
        if (_status == ShipmentStatus.DELIVERED) return "Delivered";
        if (_status == ShipmentStatus.VERIFIED) return "Verified";
        return "";
    }
}
