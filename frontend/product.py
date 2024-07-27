from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QTextEdit, QLineEdit, QLabel, QFormLayout, QFrame
from PyQt5.QtCore import Qt
from contract_interactions.product_factory import get_managers, view_registry, add_manager, create_product
from utils.formatter import format_list_as_lines

class ProductPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.init_ui()

    def init_ui(self):
        self.layout = QVBoxLayout()

        # Create Product Form
        self.form_layout = QFormLayout()

        self.name_input = QLineEdit()
        self.form_layout.addRow(QLabel("Product Name:"), self.name_input)

        self.description_input = QLineEdit()
        self.form_layout.addRow(QLabel("Description:"), self.description_input)

        self.min_temp_input = QLineEdit()
        self.form_layout.addRow(QLabel("Min Temperature:"), self.min_temp_input)

        self.max_temp_input = QLineEdit()
        self.form_layout.addRow(QLabel("Max Temperature:"), self.max_temp_input)

        self.create_product_button = QPushButton("Create Product")
        self.create_product_button.clicked.connect(self.create_product)

        # Add Manager Input
        self.manager_input = QLineEdit(self)
        self.manager_input.setPlaceholderText('Enter manager address')
        self.layout.addWidget(self.manager_input)

        # Button to add manager
        self.add_manager_button = QPushButton('Add Manager', self)
        self.add_manager_button.clicked.connect(self.add_manager)
        self.layout.addWidget(self.add_manager_button)

        # Buttons for other actions
        self.get_manager_button = QPushButton("Get Manager")
        self.get_manager_button.clicked.connect(self.display_managers)

        self.divider = QFrame()
        self.divider.setFrameShape(QFrame.HLine)
        self.divider.setFrameShadow(QFrame.Sunken)
        self.layout.addWidget(self.divider)

        self.view_registry_button = QPushButton("View Registry")
        self.view_registry_button.clicked.connect(self.view_registry)
        

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)
        

        # Result display
        self.result_text_edit = QTextEdit(self)
        self.result_text_edit.setReadOnly(True)

        self.layout.addLayout(self.form_layout)
        self.layout.addWidget(self.create_product_button)
        self.layout.addWidget(self.get_manager_button)
        self.layout.addWidget(self.view_registry_button)
        self.layout.addWidget(self.result_text_edit)
        self.layout.addWidget(self.back_button)
        self.setLayout(self.layout)

    def create_product(self):
        name = self.name_input.text()
        description = self.description_input.text()
        try:
            min_temp = int(self.min_temp_input.text())
            max_temp = int(self.max_temp_input.text())
        except ValueError:
            self.result_text_edit.setHtml("<b>Error:</b> Min and Max Temperature must be integers.")
            return

        if not name or not description:
            self.result_text_edit.setHtml("<b>Error:</b> Name and Description should not be empty.")
            return

        try:
            tx_receipt = create_product(name, description, min_temp, max_temp)
            self.result_text_edit.setHtml(f"<b>Product Created:</b><br>{tx_receipt}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")

    def add_manager(self):
        manager_address = self.manager_input.text()
        if not manager_address:
            self.result_text_edit.setHtml('<b>Input Error:</b> Input should not be empty.')
            return

        try:
            tx_receipt = add_manager(manager_address)
            self.result_text_edit.setHtml(f'<b>Success:</b> Manager added successfully. Tx Receipt: {tx_receipt}')
        except Exception as e:
            self.result_text_edit.setHtml(f'<b>Error:</b> Error adding manager: {e}')

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

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
