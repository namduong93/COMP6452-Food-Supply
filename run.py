from dotenv import load_dotenv
import os
from web3 import Web3

# Load environment variables from .env file
load_dotenv()

# Set up Web3 connection
infura_url = os.getenv('ETH_RPC_URL')
web3 = Web3(Web3.HTTPProvider(infura_url))

# Check if connected to Ethereum
if not web3.is_connected():
    raise ConnectionError("Failed to connect to Ethereum network")

# Contract address and ABI
product_factory_address = os.getenv('PRODUCT_FACTORY_ADDRESS')
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

# Call the getManagers function
def get_managers():
    try:
        managers = contract.functions.getManagers().call()
        print('Managers:', managers)
    except Exception as e:
        print(f'Error: {e}')

# Execute function
if __name__ == "__main__":
    get_managers()
