from dotenv import load_dotenv
import os
from web3 import Web3
from web3.middleware import geth_poa_middleware

# Load environment variables from .env file
load_dotenv()

# Set up Web3 connection
infura_url = os.getenv('ETH_RPC_URL')
web3 = Web3(Web3.HTTPProvider(infura_url))

# Add POA middleware for Sepolia network (if required)
web3.middleware_onion.add(geth_poa_middleware)

# Check if connected to Ethereum
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

# Private key
private_key = os.getenv('PRIVATE_KEY')
account = web3.eth.account.from_key(private_key)

def get_managers():
    try:
        managers = contract.functions.getManagers().call()
        print('Managers:', managers)
    except Exception as e:
        print(f'Error: {e}')

def add_manager(manager_address):
    try:
        # Build transaction
        tx = {
            'from': account.address,
            'to': product_factory_address,
            'chainId': 11155111,  # Sepolia Testnet Chain ID
            'gas': 2000000,
            'gasPrice': web3.to_wei('50', 'gwei'),
            'nonce': web3.eth.get_transaction_count(account.address),
            'data': contract.encodeABI(fn_name='addManager', args=[web3.to_checksum_address(manager_address)])
        }

        # Sign transaction
        signed_tx = web3.eth.account.sign_transaction(tx, private_key)

        # Send transaction
        tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
        print(f'Transaction sent. Hash: {web3.to_hex(tx_hash)}')

        # Wait for transaction receipt
        tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
        print(f'Transaction receipt: {tx_receipt}')

    except Exception as e:
        print(f'Error: {e}')

# Execute functions
if __name__ == "__main__":
    # Example usage
    get_managers()

    # Add a new manager (replace with actual manager address)
    new_manager_address = '0x8E8C0c0a1cc079f43132F7a9ad227DC7F8060541'  # Replace with actual address
    if web3.is_address(new_manager_address):
        add_manager(new_manager_address)
    else:
        print("Invalid manager address.")
