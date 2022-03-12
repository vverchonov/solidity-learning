from audioop import add
from solcx import compile_standard, install_solc
import json
import os
from dotenv import load_dotenv
from web3 import Web3

load_dotenv()

# get json
with open("./storage.sol", "r") as file:
    storage_file = file.read()

install_solc("0.8.0")
compile_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"storage.sol": {"content": storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]
                }
            }
        }
    },
    solc_version="0.8.0"
)

with open("compiled_code.json", "w") as file:
    json.dump(compile_sol, file)

# get bytecode
bytecode = compile_sol["contracts"]["storage.sol"]["Storage"]["evm"]["bytecode"]["object"]

# get abi
abi = compile_sol["contracts"]["storage.sol"]["Storage"]["abi"]

# connect to kovan
# w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
w3 = Web3(Web3.HTTPProvider(
    "https://kovan.infura.io/v3/2d94c469c91e4e8f8236e7615c565a34"))
chain_id = 42
myAddress = "0xAfA829D6AA8FFA38727400f7176b6c862f38f2Ef"
#p_key = "0xc23457a7e7445700c4540d00c8c5450c8424798bf92dcabec27ab633376307dd"
private_key = os.getenv("PRIVATE_KEY")


myStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
# print(Storage)

nonce = w3.eth.getTransactionCount(myAddress)
# print(nonce)

transaction = myStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": myAddress,
        "nonce": nonce
    }
)

singed_transaction = w3.eth.account.sign_transaction(
    transaction, private_key=private_key)

tx_hash = w3.eth.send_raw_transaction(singed_transaction.rawTransaction)

# wait for transaction to finish
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

myStorage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

print("printed = ", myStorage.functions.showNumber().call())


store_transaction = myStorage.functions.store(10).buildTransaction({
    "chainId": chain_id,
    "gasPrice": w3.eth.gas_price,
    "from": myAddress,
    "nonce": nonce+1
})
store_transaction = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key)

store_transaction = w3.eth.send_raw_transaction(
    store_transaction.rawTransaction)

store_transaction = w3.eth.wait_for_transaction_receipt(store_transaction)

print("printed = ", myStorage.functions.showNumber().call())
