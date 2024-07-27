from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QTextEdit
from contract_interactions.product_factory import get_managers, register
from utils.formatter import format_list_as_lines

class ProductPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.layout = QVBoxLayout()
        
        self.get_manager_button = QPushButton("Get Manager")
        self.get_manager_button.clicked.connect(self.display_managers)
        
        self.register_button = QPushButton("Register")
        self.register_button.clicked.connect(self.register_product)

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)

        self.result_text_edit = QTextEdit()
        self.result_text_edit.setReadOnly(True)

        self.layout.addWidget(self.get_manager_button)
        self.layout.addWidget(self.register_button)
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

    def register_product(self):
        try:
            result = register()
            self.result_text_edit.setHtml(f"<b>Registered:</b> {result}")
        except Exception as e:
            self.result_text_edit.setHtml(f"<b>Error:</b> {str(e)}")
            
    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
