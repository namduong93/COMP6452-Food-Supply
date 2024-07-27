from PyQt5.QtWidgets import QApplication, QMainWindow, QPushButton, QVBoxLayout, QWidget
from frontend.product import ProductPage

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Blockchain Manager")
        self.show_main_page()

    def show_main_page(self):
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.main_layout = QVBoxLayout()

        self.product_button = QPushButton("Product")
        self.product_button.clicked.connect(self.show_product_page)

        self.shipment_button = QPushButton("Shipment")
        self.shipment_button.clicked.connect(self.show_shipment_page)

        self.oracle_button = QPushButton("Oracle")
        self.oracle_button.clicked.connect(self.show_oracle_page)

        self.main_layout.addWidget(self.product_button)
        self.main_layout.addWidget(self.shipment_button)
        self.main_layout.addWidget(self.oracle_button)

        self.central_widget.setLayout(self.main_layout)

    def show_product_page(self):
        self.product_page = ProductPage(main_window=self)
        self.setCentralWidget(self.product_page)

    def show_shipment_page(self):
        # Implement shipment page
        pass

    def show_oracle_page(self):
        # Implement oracle page
        pass

def run_gui():
    app = QApplication([])
    window = MainWindow()
    window.show()
    app.exec()
