# frontend/registry.py
from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QTextEdit, QFrame
from contract_interactions.registry import get_products, get_shipments
from utils.formatter import format_list_as_lines

class RegistryPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.init_ui()

    def init_ui(self):
        self.layout = QVBoxLayout()

        # Buttons for actions
        self.get_products_button = QPushButton("Get Products")
        self.get_products_button.clicked.connect(self.display_products)

        self.get_shipments_button = QPushButton("Get Shipments")
        self.get_shipments_button.clicked.connect(self.display_shipments)

        self.divider = QFrame()
        self.divider.setFrameShape(QFrame.HLine)
        self.divider.setFrameShadow(QFrame.Sunken)
        self.layout.addWidget(self.divider)

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)

        # Result display
        self.result_text_edit = QTextEdit(self)
        self.result_text_edit.setReadOnly(True)

        self.layout.addWidget(self.get_products_button)
        self.layout.addWidget(self.get_shipments_button)
        self.layout.addWidget(self.result_text_edit)
        self.layout.addWidget(self.back_button)
        self.setLayout(self.layout)

    def display_products(self):
        try:
            products = get_products()
            formatted_products = format_list_as_lines(products)
            self.result_text_edit.setHtml(f"<b>Products:</b><br>{formatted_products}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def display_shipments(self):
        try:
            shipments = get_shipments()
            formatted_shipments = format_list_as_lines(shipments)
            self.result_text_edit.setHtml(f"<b>Shipments:</b><br>{formatted_shipments}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
