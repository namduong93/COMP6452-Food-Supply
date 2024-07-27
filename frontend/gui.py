from PyQt5.QtWidgets import QApplication, QPushButton, QVBoxLayout, QWidget, QLabel, QStackedWidget
from frontend.product import ProductPage
from frontend.shipment import ShipmentPage
from frontend.oracle import OraclePage

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()

        self.stack = QStackedWidget()
        self.main_layout = QVBoxLayout()
        self.main_page = QWidget()
        self.product_page = ProductPage(self)
        self.shipment_page = ShipmentPage(self)
        self.oracle_page = OraclePage(self)

        self.init_main_page()

        self.stack.addWidget(self.main_page)
        self.stack.addWidget(self.product_page)
        self.stack.addWidget(self.shipment_page)
        self.stack.addWidget(self.oracle_page)

        self.main_layout.addWidget(self.stack)
        self.setLayout(self.main_layout)
        self.show()

    def init_main_page(self):
        layout = QVBoxLayout()
        product_button = QPushButton("Product")
        shipment_button = QPushButton("Shipment")
        oracle_button = QPushButton("Oracle")

        product_button.clicked.connect(self.show_product_page)
        shipment_button.clicked.connect(self.show_shipment_page)
        oracle_button.clicked.connect(self.show_oracle_page)

        layout.addWidget(product_button)
        layout.addWidget(shipment_button)
        layout.addWidget(oracle_button)
        self.main_page.setLayout(layout)

    def show_product_page(self):
        self.stack.setCurrentWidget(self.product_page)

    def show_shipment_page(self):
        self.stack.setCurrentWidget(self.shipment_page)

    def show_oracle_page(self):
        self.stack.setCurrentWidget(self.oracle_page)

def run_gui():
    app = QApplication([])
    window = MainWindow()
    window.show()
    app.exec_()

if __name__ == "__main__":
    run_gui()
