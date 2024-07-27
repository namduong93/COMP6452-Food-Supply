// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Registry} from "../src/Registry.sol";
import {ProductFactory} from "../src/ProductFactory.sol";
import {Product} from "../src/Product.sol";

contract DeployProduct is Script {
    function run() public {
        uint256 delivererPrivateKey = vm.envUint("DELIVERER_PRIVATE_KEY");

        // Deploy Registry
        vm.startBroadcast(delivererPrivateKey);
        Registry registry = new Registry();
        
        // Deploy ProductFactory
        ProductFactory productFactory = new ProductFactory(address(registry));

        // Deploy Product
        address productAddress = productFactory.createProduct("Egg", "An egg", 10, 30);
        Product product = Product(productAddress);
        (uint256 _sku, string memory _name, string memory _desc, uint256 _minTemp, uint256 _maxTemp) = product.getProductDetails();
        console.logUint(_sku);
        console.logString(_name);
        console.logString(_desc);
        console.logUint(_minTemp);
        console.logUint(_maxTemp);

        vm.stopBroadcast();
    }
}
