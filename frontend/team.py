from PyQt5.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton, QSizePolicy
from PyQt5.QtGui import QPixmap

class TeamPage(QWidget):
    def __init__(self, parent=None, main_window=None):
        super().__init__(parent)
        self.main_window = main_window
        self.init_ui()

    def init_ui(self):
        self.layout = QVBoxLayout()

        # Adding team member information
        team_members = [
            {"name": "Tung Quan Hoang", "description": "Contracts, unit testing, script", "image": "image/team_member/male.png"},
            {"name": "Van Nam Duong", "description": "Shipment, UI, testing", "image": "image/team_member/male.png"},
            {"name": "Chaw Su Thwe", "description": "Oracle, integration into other contracts, testing", "image": "image/team_member/female.png"},
            {"name": "Kaung Pyae Sone", "description": "Oracle, integration into other contracts, testing", "image": "image/team_member/male.png"}
        ]

        for member in team_members:
            member_layout = QVBoxLayout()

            pixmap = QPixmap(member["image"])
            pixmap = pixmap.scaled(100, 100, aspectRatioMode=True)  # Resize the image

            image_label = QLabel(self)
            image_label.setPixmap(pixmap)
            image_label.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)

            name_label = QLabel(f"<b>{member['name']}</b>")
            description_label = QLabel(member["description"])

            member_layout.addWidget(image_label)
            member_layout.addWidget(name_label)
            member_layout.addWidget(description_label)

            self.layout.addLayout(member_layout)

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)

        self.layout.addWidget(self.back_button)
        self.setLayout(self.layout)

    def go_back(self):
        if self.main_window:
            self.main_window.show_main_page()
