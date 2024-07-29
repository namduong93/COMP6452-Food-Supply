// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {AccessControl} from "../src/AccessControl.sol";
import {Registry} from "../src/Registry.sol";
import {ProductFactory} from "../src/ProductFactory.sol";

contract ProductFactoryTest is Test {
    Registry registry;
    ProductFactory productFactory;
    address owner;

    function setUp() public {
        registry = new Registry();
        productFactory = new ProductFactory(address(registry));
        owner = address(this);
    }

    function testCreateProduct() public {
        productFactory.createProduct("Product1", "Description1", 0, 100);
        address[] memory skus = registry.getProducts();
        assertEq(skus.length, 1);
    }

    function testCreateProductFail() public {
        vm.prank(address(0x123));
        vm.expectRevert(abi.encodeWithSelector(AccessControl.Unauthorized.selector, address(0x123)));
        productFactory.createProduct("Product1", "Description1", 0, 100);
    }
}
