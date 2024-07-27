from PyQt5.QtWidgets import QApplication, QPushButton, QVBoxLayout, QWidget, QLabel
from backend.product_factory import get_managers
import sys

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Product Factory')

        # Create widgets
        self.layout = QVBoxLayout()
        self.label = QLabel('Click the button to get managers.')
        self.button = QPushButton('Get Managers')

        # Add widgets to layout
        self.layout.addWidget(self.label)
        self.layout.addWidget(self.button)
        self.setLayout(self.layout)

        # Connect button click event
        self.button.clicked.connect(self.on_button_click)

    def on_button_click(self):
        try:
            # Call the get_managers function from the backend
            managers = get_managers()
            # Update the label with the result
            self.label.setText(f"Managers: {', '.join(managers)}")
        except Exception as e:
            self.label.setText(f"Error: {str(e)}")

def run_gui():
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
