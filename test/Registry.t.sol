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
        registry.registerProduct(addr1, 1);
        address productAddress = registry.getProductAddress(1);
        assertEq(productAddress, addr1);
    }

    function testRegisterShipment() public {
        registry.registerShipment(addr1, 1);
        address shipmentAddress = registry.getShipmentAddress(1);
        assertEq(shipmentAddress, addr1);
    }

    function testGetProductSKUs() public {
        registry.registerProduct(addr1, 1);
        registry.registerProduct(addr1, 2);
        uint256[] memory skus = registry.getProductSKUs();
        assertEq(skus.length, 2);
        assertEq(skus[0], 1);
        assertEq(skus[1], 2);
    }

    function testGetShipmentCodes() public {
        registry.registerShipment(addr1, 1);
        registry.registerShipment(addr1, 2);
        uint256[] memory codes = registry.getShipmentCodes();
        assertEq(codes.length, 2);
        assertEq(codes[0], 1);
        assertEq(codes[1], 2);
    }
}
