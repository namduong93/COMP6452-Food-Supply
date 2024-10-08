## Documentation

We use Foundry and Forge to develop our project. Detailed usage can be found below.

## Contracts

- (Weather) Oracle : 0x71d5f126bb92368c89b0469aa3d967db14ff18d8
- Registry : 0x97202d6077445d2bBDb494f25AEA21C8D5d81f0b
- ProductFactory : 0x4396B646812D390ecd5E1Ef10baE75f2767B86d8
- ShipmentFactory : 0xe73834B4A307b019e0f8b24fCfBf250cCF754B2c

- Example Product (Egg) : 0xA8c84D8F79F28acB57D5f869FBc88b5c61703790
- Example Shipment (Egg) : 0x7A412F0a973DaE924e3c32E3D78f0D0f34569811

## Usage

If you are using Remix, delete the remappings.txt file so that Oracle.sol compiles correctly.

If you are using VSCode, when open terminal use Git Bash terminal to run the below commands.

### Download Foundry

```shell
$ curl -L https://foundry.paradigm.xyz | bash
$ source ~/.bashrc
$ foundryup
```

### (Already downloaded) before usage

```shell
$ source ~/.bashrc
```

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Run Script & Local UI
Create a .env file in the root directory and add the following line:

```shell
ETH_RPC_URL=<SEPOLIA_TESTNET_LINK>
PRIVATE_KEY=<YOUR_PRIVATE_KEY>
DELIVERER_PRIVATE_KEY=<YOUR_PRIVATE_KEY>
DELIVERER_ADDRESS=<YOUR_ACCOUNT_ADDRESS>
RECEIVER_PRIVATE_KEY=<ANY_PRIVATE_KEY>
RECEIVER_ADDRESS=<ANY_ACCOUNT_ADDRESS>
WEATHER_ORACLE_ADDRESS=0x71d5f126bb92368c89b0469aa3d967db14ff18d8
REGISTRY_ADDRESS=0x97202d6077445d2bBDb494f25AEA21C8D5d81f0b
PRODUCT_FACTORY_ADDRESS=0x4396B646812D390ecd5E1Ef10baE75f2767B86d8
SHIPMENT_FACTORY_ADDRESS=0xe73834B4A307b019e0f8b24fCfBf250cCF754B2c
```

Script

```shell
$ forge script script/<SCRIPT_NAME> --fork-url <SEPOLIA_TESTNET_LINK> --broadcast --via-ir
```

Local UI

```shell
$ pip install python-dotenv
$ pip install web3
$ pip install PyQt5

$ python3 script.py
```

## Test Coverage

Oracle.sol and the Oracle contract cannot be tested in general because it requires a deployed contract on the main Sepolia testnet with LINK tokens (required for Chainlink) in its balance.

### All unit tests

![alt text](image/unit_tests.png)

### Coverage

![alt text](image/test_coverage.png)
