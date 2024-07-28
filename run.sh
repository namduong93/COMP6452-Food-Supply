#!/bin/bash

# Set environment variables
export ETH_RPC_URL=https://sepolia.infura.io/v3/66ff7a15b79045fa95094247ea1eb268

# Contract address and ABI function signature
CONTRACT_ADDRESS=0xfbc9dcf337278bf941031821aeae62ce9af620dc
FUNCTION_SIGNATURE="getManagers()"

# Query the contract
cast call $CONTRACT_ADDRESS "getManagers()(address[])" --rpc-url $ETH_RPC_URL
