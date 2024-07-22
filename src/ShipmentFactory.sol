// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "./AccessControl.sol";
import "./Shipment.sol";
import "./Registry.sol";

/// @title A factory to product product contracts
/// @author Quan Hoang

contract ShipmentFactory is AccessControl {
    // The registry to register the new shipment contract
    Registry public registry;

    /// @notice constructor to create the shipment factory
    /// @param _registryAddress the address of the registry
    constructor(address _registryAddress) AccessControl(msg.sender) {
        registry = Registry(_registryAddress);
    }

    /// @notice create a new shipment and log its contract into the registry
    /// @param _shipmentCode code for the shipment
    /// @param _productAddress address of the product being shipped
    /// @param _productQuantity quantity for the product being shipped
    /// @param _currentLocation starting location of the shipment
    /// @param _targetLocation target location/destination for the shipment
    /// @return _shipmentAddress the address for the contract of the new shipment
    function createShipment(
        string memory _shipmentCode,
        address _productAddress,
        uint256 _productQuantity,
        string memory _currentLocation,
        string memory _targetLocation
    ) public onlyManager returns (address _shipmentAddress) {
        Shipment newShipment = new Shipment(
            msg.sender,
            _shipmentCode,
            _productAddress,
            _productQuantity,
            _currentLocation,
            _targetLocation
        );

        registry.registerShipment(address(newShipment));

        return address(newShipment);
    }
}
