// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Registry} from "../src/Registry.sol";

contract RegistryTest is Test {
    Registry registry;

    address addr1 = address(0x123);

    function setUp() public {
        registry = new Registry();
    }

    function testRegisterProduct() public {
        registry.registerProduct(addr1);
        address[] memory products = registry.getProducts();
        assertEq(products.length, 1);
    }

    function testRegisterShipment() public {
        registry.registerShipment(addr1);
        address[] memory shipments = registry.getShipments();
        assertEq(shipments.length, 1);
    }
}
