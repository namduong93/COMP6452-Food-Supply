from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QTextEdit, QLineEdit

from contract_interactions.product_factory import get_managers, view_registry, add_manager
from utils.formatter import format_list_as_lines

class ProductPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.layout = QVBoxLayout()

        # Button to get managers
        self.get_manager_button = QPushButton("Get Manager")
        self.get_manager_button.clicked.connect(self.display_managers)

        # Button to view registry
        self.view_registry_button = QPushButton("View Registry")
        self.view_registry_button.clicked.connect(self.view_registry)

        # Input for manager address
        self.manager_input = QLineEdit()
        self.manager_input.setPlaceholderText('Enter manager address')

        # Button to add manager
        self.add_manager_button = QPushButton("Add Manager")
        self.add_manager_button.clicked.connect(self.add_manager)

        # Back button
        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)

        # Text area for results and messages
        self.result_text_edit = QTextEdit()
        self.result_text_edit.setReadOnly(True)

        # Add widgets to layout
        self.layout.addWidget(self.get_manager_button)
        self.layout.addWidget(self.view_registry_button)
        self.layout.addWidget(self.manager_input)
        self.layout.addWidget(self.add_manager_button)
        self.layout.addWidget(self.result_text_edit)
        self.layout.addWidget(self.back_button)
        self.setLayout(self.layout)

    def display_managers(self):
        try:
            managers = get_managers()
            formatted_managers = format_list_as_lines(managers)
            self.result_text_edit.setHtml(f"<b>Managers:</b><br>{formatted_managers}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def view_registry(self):
        try:
            registry_address = view_registry()
            self.result_text_edit.setHtml(f"<b>Registry Address:</b><br>{registry_address}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def add_manager(self):
        manager_address = self.manager_input.text()
        if not manager_address:
            self.result_text_edit.setHtml("<b>Error:</b> Input should not be empty.")
            return

        try:
            tx_receipt = add_manager(manager_address)
            self.result_text_edit.setHtml(f"<b>Success:</b> Manager added successfully. Tx Receipt: {tx_receipt}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
