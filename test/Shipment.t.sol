// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Shipment} from "../src/Shipment.sol";
import {Product} from "../src/Product.sol";
import {WeatherOracle} from "../src/Oracle.sol";
import {AccessControl} from "../src/AccessControl.sol";

// Mock Oracle Contract for testing
contract MockOracle {
    function requestCurrTemp(string memory location, string memory dataType) public returns (uint256) {
        // Mock implementation for testing
    }

    function getTemp() public pure returns (uint256) {
        // Mock implementation for testing
        return 20000; // Example: 25.0°C in the required format
    }
}

contract ShipmentTest is Test {
    Shipment shipment;
    Product product;
    MockOracle mockOracle;
    address manager;
    address receiver;

    function setUp() public {
        manager = address(this);
        receiver = address(0x123);
        product = new Product(manager, 1, "Egg", "An egg", 10, 30);
        mockOracle = new MockOracle();

        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";

        shipment = new Shipment(
            manager, 1, receiver, address(product), 10, block.timestamp, block.timestamp, locations, address(mockOracle)
        );
    }

    function testCreateShipment() public {
        (
            ,
            address _receiver,
            address _productAddress,
            uint256 _productQuantity,
            uint256 _productProdDate,
            uint256 _productExpDate,
            string memory _location,
            string[] memory _locations,
            string memory _status,
            ,
        ) = shipment.getShipmentDetails();

        assertEq(_receiver, receiver);
        assertEq(_productAddress, address(product));
        assertEq(_productQuantity, 10);
        assertEq(_productProdDate, block.timestamp);
        assertEq(_productExpDate, block.timestamp);
        assertEq(_location, "Sydney");
        assertEq(_locations.length, 2);
        assertEq(_status, "Preparing");
    }

    function testInvalidTimestamp() public {
        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";

        vm.expectRevert();
        new Shipment(
            manager,
            2,
            receiver,
            address(product),
            10,
            block.timestamp + 1000, // Invalid production date
            block.timestamp + 2000,
            locations,
            address(mockOracle)
        );
    }

    function testMoveShipment() public {
        shipment.moveShipment(3600); // Move shipment 1 hour later
        (,,,,,,,, string memory _status,,) = shipment.getShipmentDetails();
        assertEq(_status, "Shipping");
        assertTrue(shipment.checkNotExpired());
        assertTrue(shipment.checkWithinAllowedWeatherCondition());
    }

    function testUpdateShipmentLocation() public {
        shipment.moveShipment(3600); // Move shipment 1 hour later
        vm.warp(block.timestamp + 3601); // Warp time by 1 hour to trigger location update
        shipment.updateShipmentLocation();
        (,,,,,, string memory _currentLocation,, string memory _status,,) = shipment.getShipmentDetails();
        assertEq(_currentLocation, "Melbourne");
        assertEq(_status, "Delivered");
    }

    function testCancelShipment() public {
        shipment.moveShipment(3600); // Move shipment 1 hour later
        shipment.cancelShipment();
        vm.expectRevert();
        shipment.moveShipment(3600); // Attempt to move shipment after cancellation
    }

    function testDelivererVerify() public {
        shipment.moveShipment(3600); // Move shipment 1 hour later
        vm.warp(block.timestamp + 3600); // Warp time by 1 hour to trigger location update
        shipment.updateShipmentLocation();
        shipment.delivererVerify();
        (,,,,,,,, string memory _status,,) = shipment.getShipmentDetails();
        assertEq(_status, "Verified by Deliverer");
    }

    function testReceiverVerify() public {
        shipment.moveShipment(3600); // Move shipment 1 hour later
        vm.warp(block.timestamp + 3600); // Warp time by 1 hour to trigger location update
        shipment.updateShipmentLocation();
        shipment.delivererVerify();
        vm.prank(receiver);
        shipment.receiverVerify();
        (,,,,,,,, string memory _status,,) = shipment.getShipmentDetails();
        assertEq(_status, "Finalized");
    }

    function testCheckWithinAllowedWeatherCondition() public {
        // Mocking the weather oracle response
        // Assuming the temperature is within the allowed range
        vm.mockCall(
            address(mockOracle),
            abi.encodeWithSignature("getTemp()"),
            abi.encode(20000) // Example: 25.0°C in the required format
        );
        assertTrue(shipment.checkWithinAllowedWeatherCondition());
    }

    function testCheckNotExpired() public {
        assertTrue(shipment.checkNotExpired());
        vm.warp(block.timestamp + 2 days); // Warp time to expire the product
        assertFalse(shipment.checkNotExpired());
    }

    function testUnauthorizedReceiver() public {
        vm.prank(address(0x456));
        vm.expectRevert(abi.encodeWithSelector(AccessControl.Unauthorized.selector, address(0x456)));
        shipment.receiverVerify();
    }

    function testShipmentFinalized() public {
        shipment.moveShipment(3600); // Move shipment 1 hour later
        vm.warp(block.timestamp + 3600); // Warp time by 1 hour to trigger location update
        shipment.updateShipmentLocation();
        vm.expectRevert();
        shipment.moveShipment(3600); // Attempt to move shipment after cancellation
    }
}
