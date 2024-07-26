// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Product} from "../src/Product.sol";
import {AccessControl} from "../src/AccessControl.sol";

contract ProductTest is Test {
    Product product;
    address owner;

    function setUp() public {
        owner = address(this);
        product = new Product(owner, 1, "Product1", "Description1", 0, 100);
    }

    function testGetProductDetails() public view {
        (uint256 sku, string memory name, string memory description, uint256 _minCTemp, uint256 _maxCTemp) =
            product.getProductDetails();
        assertEq(sku, 1);
        assertEq(name, "Product1");
        assertEq(description, "Description1");
        assertEq(_minCTemp, 0);
        assertEq(_maxCTemp, 100);
    }
}
