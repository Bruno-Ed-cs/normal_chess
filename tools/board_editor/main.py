import sys
import json
from PySide6.QtWidgets import *
from PySide6.QtCore import Slot
from PySide6.QtGui import QKeySequence

from backend import Board, Roles
from board_editor import Ui_BoardEditor
from new_board import Ui_NewBoard

class PieceButton(QPushButton):

    def __init__(self,piece_role: Roles, parent = None):
        super().__init__(parent)
        self.piece_role = piece_role
        self.setMinimumHeight(50)
        self.setFlat(True)
        self.setCheckable(True)
        self.setAutoExclusive(True)
        self.setAutoFillBackground(True)

        self.setText(piece_role.name.capitalize())


class NewBoardDialog(Ui_NewBoard, QDialog):

    def __init__(self, parent = None):
        super().__init__(parent)

        self.setupUi(self)

    def get_size(self):
        return [
            self.spinBox_width.value(),
            self.spinBox_height.value()
        ]

class Window(QMainWindow):

    def __init__(self):
        super().__init__()

        self.board = Board()
        self.selected_role = Roles.pawn

        # Carregar interface
        self.main_ui = Ui_BoardEditor()
        self.main_ui.setupUi(self)

        self.new_board_ui = NewBoardDialog(self)

        # Conectar as spin boxes principais

        self.main_ui.spinBox_width.valueChanged.connect(self.change_width)
        self.main_ui.spinBox_height.valueChanged.connect(self.change_height)

        # Conectando as ações
        action_new = self.main_ui.actionNew
        action_new.triggered.connect(self.make_board)
        action_new.setShortcut(QKeySequence.StandardKey.New)

        action_load = self.main_ui.actionLoad
        action_load.triggered.connect(self.load_board)
        action_load.setShortcut(QKeySequence.StandardKey.Open)

        action_save = self.main_ui.actionSave
        action_save.triggered.connect(self.save_board)
        action_save.setShortcut(QKeySequence.StandardKey.Save)

        # Botões de pecas
        for role in Roles:
            button = PieceButton(role)
            button.toggled.connect(self.select_role)
            if role == Roles.pawn:
                button.setChecked(True)
            self.main_ui.PiecesContainer.addWidget(button)

    @Slot()
    def save_board(self):
        filepath, _ = QFileDialog.getSaveFileName(
                self,
                "Save Board",
                "",
                "Board files (*.json)"
        )

        if filepath:
            self.board.save_to_file(filepath)
            self.sync_board()

    @Slot()
    def load_board(self):
        filepath, _ = QFileDialog.getOpenFileName(
                self,
                "Select board file",
                "",
                "Board files (*.json)"
        )

        if filepath:
            with open(filepath, "r") as file:
                data = json.load(file)
                self.board.load_from_json(data)
            self.sync_board()


    @Slot(bool)
    def select_role(self, checked):
        button = self.sender()

        if checked and isinstance(button, PieceButton):
            self.selected_role = button.piece_role
            # print(self.selected_role)


    def sync_board(self):
        self.main_ui.spinBox_width.setValue(self.board.size[0])
        self.main_ui.spinBox_height.setValue(self.board.size[1])

    @Slot()
    def make_board(self):

        if main_window.new_board_ui.exec() == QDialog.DialogCode.Accepted:
            main_window.board = Board(main_window.new_board_ui.get_size())
            main_window.sync_board()
            print(main_window.board.get_dict())

    @Slot(int)
    def change_width(self, value: int):
        self.board.size[0] = value
        print(self.board.size)

    @Slot(int)
    def change_height(self, value: int):
        self.board.size[1] = value
        print(self.board.size)



if __name__ == '__main__':
    # Create the Qt Application
    app = QApplication(sys.argv)
    # Create and show the form
    main_window = Window()
    main_window.show()
    main_window.make_board()

    # Run the main Qt loop
    sys.exit(app.exec())
