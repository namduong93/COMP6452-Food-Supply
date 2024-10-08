// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {AccessControl} from "../src/AccessControl.sol";
import {Registry} from "../src/Registry.sol";
import {ShipmentFactory} from "../src/ShipmentFactory.sol";
import {Shipment} from "../src/Shipment.sol";

contract ShipmentFactoryTest is Test {
    Registry registry;
    ShipmentFactory shipmentFactory;
    address owner;
    address addr1 = address(0x123);
    address addr2 = address(0x456);

    function setUp() public {
        registry = new Registry();
        shipmentFactory = new ShipmentFactory(address(registry));
    }

    function testCreateShipment() public {
        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";
        address oracle = address(0x71D5F126bB92368c89b0469AA3D967Db14fF18D8);
        shipmentFactory.createShipment(addr2, addr1, 100, block.timestamp, block.timestamp + 86400, locations, oracle);
        address[] memory shipmentCodes = registry.getShipments();
        assertEq(shipmentCodes.length, 1);
    }

    function testCreateShipmentFail() public {
        vm.prank(address(0x123));
        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";
        address oracle = address(0x71D5F126bB92368c89b0469AA3D967Db14fF18D8);
        vm.expectRevert(abi.encodeWithSelector(AccessControl.Unauthorized.selector, address(0x123)));
        shipmentFactory.createShipment(addr2, addr1, 100, block.timestamp, block.timestamp + 86400, locations, oracle);
    }

    function testCreateShipmentWithInvalidDates() public {
        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";
        address oracle = address(0x71D5F126bB92368c89b0469AA3D967Db14fF18D8);

        vm.expectRevert();
        shipmentFactory.createShipment(
            addr2, addr1, 100, block.timestamp + 86400, block.timestamp - 86400, locations, oracle
        );
    }

    function testCreateShipmentUnauthorizedAccess() public {
        address unauthorized = address(0x789);
        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";
        address oracle = address(0x71D5F126bB92368c89b0469AA3D967Db14fF18D8);

        vm.prank(unauthorized);
        vm.expectRevert(abi.encodeWithSelector(AccessControl.Unauthorized.selector, unauthorized));
        shipmentFactory.createShipment(addr2, addr1, 100, block.timestamp, block.timestamp + 86400, locations, oracle);
    }

    function testCreateMultipleShipments() public {
        string[] memory locations1 = new string[](2);
        locations1[0] = "Sydney";
        locations1[1] = "Melbourne";
        address oracle = address(0x71D5F126bB92368c89b0469AA3D967Db14fF18D8);
        shipmentFactory.createShipment(addr2, addr1, 100, block.timestamp, block.timestamp + 86400, locations1, oracle);

        string[] memory locations2 = new string[](2);
        locations2[0] = "Melbourne";
        locations2[1] = "Adelaide";
        shipmentFactory.createShipment(addr2, addr1, 150, block.timestamp, block.timestamp + 172800, locations2, oracle);

        address[] memory shipmentCodes = registry.getShipments();
        assertEq(shipmentCodes.length, 2);
    }
}
