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
    },
    {
        "constant": True,
        "inputs": [],
        "name": "registry",
        "outputs": [{"name": "", "type": "address"}],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": False,
        "inputs": [{"name": "_manager", "type": "address"}],
        "name": "addManager",
        "outputs": [],
        "payable": False,
        "stateMutability": "nonpayable",
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

def view_registry():
    try:
        registry_address = contract.functions.registry().call()
        return web3.to_checksum_address(registry_address)
    except Exception as e:
        raise RuntimeError(f'Error calling viewRegistry: {e}')

def add_manager(manager_address):
    try:
        private_key = os.getenv('PRIVATE_KEY')
        account = web3.eth.account.from_key(private_key)

        # Prepare transaction
        nonce = web3.eth.get_transaction_count(account.address)
        tx = {
            'chainId': 11155111,  # Sepolia Testnet Chain ID
            'gas': 2000000,
            'gasPrice': web3.to_wei('50', 'gwei'),
            'nonce': nonce,
            'to': product_factory_address,
            'data': contract.encodeABI(fn_name='addManager', args=[web3.to_checksum_address(manager_address)])
        }

        # Sign transaction
        signed_tx = web3.eth.account.sign_transaction(tx, private_key)

        # Send transaction
        tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)

        # Wait for transaction receipt
        tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
        return tx_receipt
    except Exception as e:
        raise RuntimeError(f'Error calling addManager: {e}')
