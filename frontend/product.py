from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QTextEdit, QLineEdit, QFrame
from PyQt5.QtCore import Qt
from contract_interactions.product_factory import get_managers, view_registry, add_manager
from utils.formatter import format_list_as_lines

class ProductPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.init_ui()

    def init_ui(self):
        self.layout = QVBoxLayout()

        # Add Manager Input
        self.manager_input = QLineEdit(self)
        self.manager_input.setPlaceholderText('Enter manager address')
        self.layout.addWidget(self.manager_input)

        # Button to add manager
        self.add_manager_button = QPushButton('Add Manager', self)
        self.add_manager_button.clicked.connect(self.add_manager)
        self.layout.addWidget(self.add_manager_button)

        # Divider
        self.divider = QFrame()
        self.divider.setFrameShape(QFrame.HLine)
        self.divider.setFrameShadow(QFrame.Sunken)
        self.layout.addWidget(self.divider)

        # Button to get managers
        self.get_managers_button = QPushButton('Get Managers', self)
        self.get_managers_button.clicked.connect(self.display_managers)
        self.layout.addWidget(self.get_managers_button)

        # Button to view registry
        self.view_registry_button = QPushButton('View Registry', self)
        self.view_registry_button.clicked.connect(self.view_registry)
        self.layout.addWidget(self.view_registry_button)

        # Result area
        self.result_text_edit = QTextEdit(self)
        self.result_text_edit.setReadOnly(True)
        self.layout.addWidget(self.result_text_edit)

        # Back button
        self.back_button = QPushButton('Back', self)
        self.back_button.clicked.connect(self.go_back)
        self.layout.addWidget(self.back_button)

        self.setLayout(self.layout)
        self.setWindowTitle('Product Page')

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
            self.result_text_edit.setHtml(f'<b>Managers:</b><br>{formatted_managers}')
        except Exception as e:
            self.result_text_edit.setHtml(f'<b>Error:</b> Error fetching managers: {e}')

    def view_registry(self):
        try:
            registry_address = view_registry()
            self.result_text_edit.setHtml(f'<b>Registry Address:</b><br>{registry_address}')
        except Exception as e:
            self.result_text_edit.setHtml(f'<b>Error:</b> Error fetching registry address: {e}')

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
