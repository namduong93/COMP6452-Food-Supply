# contract_interactions/registry.py
from dotenv import load_dotenv
import os
from web3 import Web3
from web3.middleware import geth_poa_middleware

# Load environment variables
load_dotenv()

# Set up Web3 connection
infura_url = os.getenv('ETH_RPC_URL')
web3 = Web3(Web3.HTTPProvider(infura_url))

# Add POA middleware for Sepolia network (if required)
web3.middleware_onion.add(geth_poa_middleware)

if not web3.is_connected():
    raise ConnectionError("Failed to connect to Ethereum network")

# Contract address and ABI
registry_address = web3.to_checksum_address(os.getenv('REGISTRY_ADDRESS'))
registry_abi = [
    {
        "constant": True,
        "inputs": [],
        "name": "getProducts",
        "outputs": [{"name": "", "type": "address[]"}],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": True,
        "inputs": [],
        "name": "getShipments",
        "outputs": [{"name": "", "type": "address[]"}],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    }
]

# Initialize contract
registry_contract = web3.eth.contract(address=registry_address, abi=registry_abi)

def get_products():
    try:
        products = registry_contract.functions.getProducts().call()
        return [web3.to_checksum_address(product) for product in products]
    except Exception as e:
        raise RuntimeError(f'Error calling getProducts: {e}')

def get_shipments():
    try:
        shipments = registry_contract.functions.getShipments().call()
        return [web3.to_checksum_address(shipment) for shipment in shipments]
    except Exception as e:
        raise RuntimeError(f'Error calling getShipments: {e}')
