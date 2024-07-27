from PyQt5.QtWidgets import QWidget, QVBoxLayout, QPushButton, QLabel
from contract_interactions.product_factory import get_managers, register

class ProductPage(QWidget):
    def __init__(self, parent):
        super().__init__(parent)
        self.init_ui()

    def init_ui(self):
        layout = QVBoxLayout()
        self.label = QLabel("Product Operations")
        get_manager_button = QPushButton("Get Manager")
        register_button = QPushButton("Register Product")

        get_manager_button.clicked.connect(self.on_get_manager)
        register_button.clicked.connect(self.on_register)

        layout.addWidget(get_manager_button)
        layout.addWidget(register_button)
        layout.addWidget(self.label)

        self.setLayout(layout)

    def on_get_manager(self):
        try:
            managers = get_managers()
            self.label.setText(f"Managers: {', '.join(managers)}")
        except Exception as e:
            self.label.setText(f"Error: {e}")

    def on_register(self):
        try:
            register_result = register()
            self.label.setText(f"Register result: {register_result}")
        except Exception as e:
            self.label.setText(f"Error: {e}")
