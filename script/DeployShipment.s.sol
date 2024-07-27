// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Registry} from "../src/Registry.sol";
import {WeatherOracle} from "../src/Oracle.sol";
import {ProductFactory} from "../src/ProductFactory.sol";
import {Product} from "../src/Product.sol";
import {ShipmentFactory} from "../src/ShipmentFactory.sol";
import {Shipment} from "../src/Shipment.sol";

contract DeployShipment is Script {
    function test() public {} // Ignore test/coverage

    function run() public {
        uint256 delivererPrivateKey = vm.envUint("DELIVERER_PRIVATE_KEY");

        address receiverAddress = vm.envAddress("RECEIVER_ADDRESS");

        // Deploy Registry
        vm.startBroadcast(delivererPrivateKey);
        Registry registry = new Registry();

        // Deploy ProductFactory
        ProductFactory productFactory = new ProductFactory(address(registry));

        // Deploy Product
        address productAddress = productFactory.createProduct("Egg", "An egg", 10, 30);
        Product product = Product(productAddress);
        (uint256 sku, string memory name, string memory desc, uint256 minTemp, uint256 maxTemp) =
            product.getProductDetails();
        console.log("Product Created:");
        console.log("SKU:", sku);
        console.log("Name:", name);
        console.log("Description:", desc);
        console.log("Min Temperature:", minTemp);
        console.log("Max Temperature:", maxTemp);
        console.log("============================");

        // Deploy ShipmentFactory
        ShipmentFactory shipmentFactory = new ShipmentFactory(address(registry));

        // Deploy Shipment
        string[] memory locations = new string[](2);
        locations[0] = "Sydney";
        locations[1] = "Melbourne";

        address shipmentAddress = shipmentFactory.createShipment(
            receiverAddress, productAddress, 100, block.timestamp, block.timestamp + 30 days, locations, address(0x789)
        );

        Shipment shipment = Shipment(shipmentAddress);
        (
            uint256 shipmentCode,
            address receiver,
            address productAddr,
            uint256 productQuantity,
            uint256 productProdDate,
            uint256 productExpDate,
            string memory currentLocation,
            ,
            string memory status,
            uint256 moveTimestamp,
            address weatherOracleAddress
        ) = shipment.getShipmentDetails();

        console.log("Shipment Created:");
        console.log("Shipment Code:", shipmentCode);
        console.log("Receiver:", receiver);
        console.log("Product Address:", productAddr);
        console.log("Product Quantity:", productQuantity);
        console.log("Product Production Date:", productProdDate);
        console.log("Product Expiry Date:", productExpDate);
        console.log("Current Location:", currentLocation);
        console.log("Status:", status);
        console.log("Move Timestamp:", moveTimestamp);
        console.log("Weather Oracle Address:", weatherOracleAddress);
        console.log("============================");
    }
}
