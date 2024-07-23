// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {AccessControl} from "../src/AccessControl.sol";
import {Registry} from "../src/Registry.sol";
import {ShipmentFactory} from "../src/ShipmentFactory.sol";

contract ShipmentFactoryTest is Test {
    Registry registry;
    ShipmentFactory shipmentFactory;
    address owner;
    address addr1 = address(0x123);
    address addr2 = address(0x456);

    function setUp() public {
        registry = new Registry();
        shipmentFactory = new ShipmentFactory(address(registry));
        owner = address(this);
        registry.registerProduct(addr1, 1);
    }

    function testCreateShipment() public {
        string[] memory locations = new string[](2);
        locations[0] = "Location1";
        locations[1] = "Location2";
        shipmentFactory.createShipment(
            addr2,
            addr1,
            100,
            block.timestamp,
            block.timestamp + 86400,
            locations
        );
        uint256[] memory shipmentCodes = registry.getShipmentCodes();
        assertEq(shipmentCodes.length, 1);
        assertEq(shipmentCodes[0], 1);
    }

    function testCreateShipmentFail() public {
        vm.prank(address(0x123));
        string[] memory locations = new string[](2);
        locations[0] = "Location1";
        locations[1] = "Location2";
        vm.expectRevert(abi.encodeWithSelector(AccessControl.Unauthorized.selector, address(0x123)));
        shipmentFactory.createShipment(
            addr2,
            addr1,
            100,
            block.timestamp,
            block.timestamp + 86400,
            locations
        );
    }
}
