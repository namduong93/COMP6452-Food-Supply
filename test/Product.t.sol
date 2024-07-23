// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Product} from "../src/Product.sol";

contract ProductTest is Test {
    Product product;
    address owner;

    function setUp() public {
        owner = address(this);
        product = new Product(owner, 1, "Product1", "Description1", 0, 100);
    }

    function testGetProductDetails() view public {
        (
            uint256 sku,
            string memory name,
            string memory description,
            Product.AllowedWeatherCondition memory condition
        ) = product.getProductDetails();
        assertEq(sku, 1);
        assertEq(name, "Product1");
        assertEq(description, "Description1");
        assertEq(condition.minCTemperature, 0);
        assertEq(condition.maxCTemperature, 100);
    }

    function testGetAllowedWeatherCondition() view public {
        Product.AllowedWeatherCondition memory condition = product
            .getAllowedWeatherCondition();
        assertEq(condition.minCTemperature, 0);
        assertEq(condition.maxCTemperature, 100);
    }
}
