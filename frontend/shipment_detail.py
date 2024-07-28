# frontend/shipment_detail.py

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

# Contract ABI for Shipment
shipment_contract_abi = [
    {
        "constant": True,
        "inputs": [],
        "name": "getShipmentDetails",
        "outputs": [
            {"name": "_shipmentCode", "type": "uint256"},
            {"name": "_receiver", "type": "address"},
            {"name": "_productAddress", "type": "address"},
            {"name": "_productQuantity", "type": "uint256"},
            {"name": "_productProdDate", "type": "uint256"},
            {"name": "_productExpDate", "type": "uint256"},
            {"name": "_currentLocation", "type": "string"},
            {"name": "_locations", "type": "string[]"},
            {"name": "_status", "type": "string"},
            {"name": "_moveTimestamp", "type": "uint256"},
            {"name": "_weatherOracleAddress", "type": "address"}
        ],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": True,
        "inputs": [],
        "name": "checkWithinAllowedWeatherCondition",
        "outputs": [
            {"name": "", "type": "bool"}
        ],
        "payable": False,
        "stateMutability": "view",
        "type": "function"
    }
]

class ShipmentDetailPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.init_ui()

    def init_ui(self):
        self.layout = QVBoxLayout()

        self.form_layout = QFormLayout()

        self.shipment_address_input = QLineEdit()
        self.form_layout.addRow(QLabel("Shipment Address:"), self.shipment_address_input)

        self.get_shipment_details_button = QPushButton("Get Shipment Details")
        self.get_shipment_details_button.clicked.connect(self.get_shipment_details)

        self.check_weather_button = QPushButton("Check Weather Condition")
        self.check_weather_button.clicked.connect(self.check_weather_condition)

        self.result_text_edit = QTextEdit(self)
        self.result_text_edit.setReadOnly(True)

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)

        self.layout.addLayout(self.form_layout)
        self.layout.addWidget(self.get_shipment_details_button)
        self.layout.addWidget(self.check_weather_button)
        self.layout.addWidget(self.result_text_edit)
        self.layout.addWidget(self.back_button)

        self.setLayout(self.layout)

    def get_shipment_details(self):
        shipment_address = self.shipment_address_input.text()

        if not shipment_address:
            self.result_text_edit.setHtml("<b>Error:</b> Shipment Address should not be empty.")
            return

        try:
            shipment_contract = web3.eth.contract(address=web3.to_checksum_address(shipment_address), abi=shipment_contract_abi)
            details = shipment_contract.functions.getShipmentDetails().call()

            details_html = (
                f"<b>Shipment Code:</b> {details[0]}<br>"
                f"<b>Receiver:</b> {details[1]}<br>"
                f"<b>Product Address:</b> {details[2]}<br>"
                f"<b>Product Quantity:</b> {details[3]}<br>"
                f"<b>Production Date:</b> {details[4]}<br>"
                f"<b>Expiry Date:</b> {details[5]}<br>"
                f"<b>Current Location:</b> {details[6]}<br>"
                f"<b>Locations:</b> {details[7]}<br>"
                f"<b>Status:</b> {details[8]}<br>"
                f"<b>Move Timestamp:</b> {details[9]}<br>"
                f"<b>Weather Oracle Address:</b> {details[10]}<br>"
            )

            self.result_text_edit.setHtml(details_html)
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def check_weather_condition(self):
        shipment_address = self.shipment_address_input.text()

        if not shipment_address:
            self.result_text_edit.setHtml("<b>Error:</b> Shipment Address should not be empty.")
            return

        try:
            shipment_contract = web3.eth.contract(address=web3.to_checksum_address(shipment_address), abi=shipment_contract_abi)
            is_within_condition = shipment_contract.functions.checkWithinAllowedWeatherCondition().call()

            condition_html = "<b>Weather Condition:</b> " + ("Within Allowed Range" if is_within_condition else "Out of Allowed Range")
            self.result_text_edit.setHtml(condition_html)
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
