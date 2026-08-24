import sys
from PySide6.QtWidgets import *
from PySide6.QtCore import Slot

from backend import Board
from board_editor import Ui_BoardEditor
from new_board import Ui_NewBoard

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

        # Carregar interface
        self.main_ui = Ui_BoardEditor()
        self.main_ui.setupUi(self)

        self.new_board_ui = NewBoardDialog(self)



        # Conectar as spin boxes principais 
        self.main_ui.spinBox_width.valueChanged.connect(self.change_width)
        self.main_ui.spinBox_height.valueChanged.connect(self.change_height)

        # Conectar as spin boxes da interface de fazer o tabuleiro

    def sync_board(self):
        self.main_ui.spinBox_width.setValue(self.board.size[0])
        self.main_ui.spinBox_height.setValue(self.board.size[1])

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
