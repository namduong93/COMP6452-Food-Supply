import os
from web3 import Web3
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Set up Web3 connection
infura_url = os.getenv('ETH_RPC_URL')
web3 = Web3(Web3.HTTPProvider(infura_url))

if not web3.is_connected():
    raise ConnectionError("Failed to connect to Ethereum network")

# Contract address and ABI
product_factory_address = web3.to_checksum_address(os.getenv('PRODUCT_FACTORY_ADDRESS'))
contract_abi = [
    {
        "constant": True,
        "inputs": [],
        "name": "getManagers",
        "outputs": [{"name": "", "type": "address[]"}],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    }
]

# Initialize contract
contract = web3.eth.contract(address=product_factory_address, abi=contract_abi)

def get_managers():
    try:
        managers = contract.functions.getManagers().call()
        return [web3.to_checksum_address(manager) for manager in managers]
    except Exception as e:
        raise RuntimeError(f'Error calling getManagers: {e}')

def register():
    # Implement the register functionality here
    pass
