from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QTextEdit, QLineEdit, QLabel, QFormLayout
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

# Set up Web3 connection
infura_url = os.getenv('ETH_RPC_URL')
web3 = Web3(Web3.HTTPProvider(infura_url))

if not web3.is_connected():
    raise ConnectionError("Failed to connect to Ethereum network")

# Contract ABI for Product
product_contract_abi = [
    {
        "constant": True,
        "inputs": [],
        "name": "getProductDetails",
        "outputs": [
            {"name": "sku", "type": "uint256"},
            {"name": "name", "type": "string"},
            {"name": "description", "type": "string"},
            {"name": "minCTemperature", "type": "uint256"},
            {"name": "maxCTemperature", "type": "uint256"}
        ],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    }
]

class ProductDetailPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.init_ui()

    def init_ui(self):
        self.layout = QVBoxLayout()

        self.form_layout = QFormLayout()

        self.product_address_input = QLineEdit()
        self.form_layout.addRow(QLabel("Product Address:"), self.product_address_input)

        self.get_product_details_button = QPushButton("Get Product Details")
        self.get_product_details_button.clicked.connect(self.get_product_details)

        self.result_text_edit = QTextEdit(self)
        self.result_text_edit.setReadOnly(True)

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)

        self.layout.addLayout(self.form_layout)
        self.layout.addWidget(self.get_product_details_button)
        self.layout.addWidget(self.result_text_edit)
        self.layout.addWidget(self.back_button)

        self.setLayout(self.layout)

    def get_product_details(self):
        product_address = self.product_address_input.text()

        if not product_address:
            self.result_text_edit.setHtml("<b>Error:</b> Product Address should not be empty.")
            return

        try:
            product_contract = web3.eth.contract(address=web3.to_checksum_address(product_address), abi=product_contract_abi)
            details = product_contract.functions.getProductDetails().call()

            details_html = (
                f"<b>SKU:</b> {details[0]}<br>"
                f"<b>Name:</b> {details[1]}<br>"
                f"<b>Description:</b> {details[2]}<br>"
                f"<b>Min Temperature:</b> {details[3]}<br>"
                f"<b>Max Temperature:</b> {details[4]}<br>"
            )

            self.result_text_edit.setHtml(details_html)
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
