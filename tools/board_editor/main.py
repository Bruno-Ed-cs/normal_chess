import sys
import math
import json
from PySide6.QtWidgets import *
from PySide6.QtCore import QObject, Slot, Qt, Signal
from PySide6.QtGui import QKeySequence, QColor, QPixmap, QPen, QBrush, QMouseEvent

from backend import Board, Roles, Team, BoardPos, Piece
from board_editor import Ui_BoardEditor
from new_board import Ui_NewBoard
from make_team import Ui_MakeTeam
import sprites

class Tile(QGraphicsRectItem, QObject):

    coordenate: BoardPos
    piece: Piece
    team: Team
    default_color: QColor
    sprite: QPixmap

    left_click = Signal()

    def __init__(self, coordenate: BoardPos, default_color: QColor, parent = None):
        QGraphicsRectItem.__init__(self, coordenate.x * 32, coordenate.y * 32, 32, 32, parent)
        QObject.__init__(self)
        self.coordenate = coordenate
        self.team = None
        self.piece = None
        self.default_color = default_color
        self.sprite = None

    def get_piece(self):
        return self.piece

    def set_team(self, team):
        self.team = team

    def set_piece(self, piece):
        self.piece = piece
        
        match self.piece.role:
            case Roles.pawn:
                self.sprite = QPixmap(":/sprites/white_pawn.png")

            case Roles.rook:
                self.sprite = QPixmap(":/sprites/white_rook.png")

            case Roles.bishop:
                self.sprite = QPixmap(":/sprites/white_bishop.png")

            case Roles.king:
                self.sprite = QPixmap(":/sprites/white_king.png")

            case Roles.queen:
                self.sprite = QPixmap(":/sprites/white_queen.png")

            case Roles.knight:
                self.sprite = QPixmap(":/sprites/white_knight.png")

            case _:
                self.sprite = None

        self.update()

    def clean(self):
        self.team = None
        self.piece = None
        self.sprite = None
        self.update()

    def mousePressEvent(self, event: QMouseEvent):

        if event.button() == Qt.MouseButton.LeftButton:
            self.left_click.emit()

        if event.button() == Qt.MouseButton.RightButton:
            print(self.coordenate.x, self.coordenate.y)
            self.clean()

    def paint(self, painter, option, widget=None):

        brush = QBrush(self.default_color)

        print(self.team)
        if self.team:
            # print(QColor(*self.team.color))
            brush = QBrush(QColor(*self.team.color))

        pen = QPen(brush.color())

        # if option.state == QStyle.State_Selected:
        #     pen = QPen(Qt.GlobalColor.green)

        painter.setBrush(brush)
        painter.setPen(pen)
        painter.drawRect(self.rect())

        if self.sprite:
            print("i have a sprite")
            painter.drawPixmap(self.rect().topLeft(), self.sprite)
        else:
            print("i dont have a sprite")



class MakeTeamDialog(QDialog, Ui_MakeTeam):

    def __init__(self, parent = None):
        super().__init__(parent)
        self.setupUi(self)
        self.team = Team([0, 0, 0, 0], "White", [0, 0])
        self.color = QColor("white")
        self.colorButton.clicked.connect(self.get_color)

        col_square = QPixmap(80, 80)
        col_square.fill(self.color)
        self.colorDisplay.setPixmap(col_square)

    @Slot()
    def get_color(self):
        self.color = QColorDialog.getColor()
        col_square = QPixmap(80, 80)
        col_square.fill(self.color)
        self.colorDisplay.setPixmap(col_square)

    @staticmethod
    def make_team(parent = None) -> Team | None:
        dialog = MakeTeamDialog(parent)
        
        if dialog.exec() == QDialog.DialogCode.Accepted:
            march = [
                dialog.marchSpinX.value(),
                dialog.marchSpinY.value()
            ]
            color = dialog.color.getRgb()
            name = dialog.nameEdit.text()
            team = Team(color, name, march)
            print(team.__dict__)
            return team

        return None


class TeamListItem(QListWidgetItem):

    def __init__(self, team: Team, parent = None):
        super().__init__(parent)
        self.team = team
        font = self.font()
        font.setPointSize(16)

        self.setFont(font)

        self.setText(f" {team.name} {team.color} {team.march} ")

    def get_team(self):
        return self.team

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
        self.board.teams.append(Team([23, 44, 55, 1], "White", [0, 1]))

        print(self.board.teams)

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

        self.main_ui.removeTeamButton.clicked.connect(self.remove_team)
        self.main_ui.newTeamButton.clicked.connect(self.new_team)

        #setando a cena de renderização
        self.scene = QGraphicsScene()
        self.scene.setBackgroundBrush((QBrush(Qt.GlobalColor.gray)))

        self.main_ui.boardCanva.setScene(self.scene)

        #controles do canva
        self.max_zoom = 3.5
        self.main_ui.zoomIn.clicked.connect(self.zoom_in)
        self.main_ui.zoomOut.clicked.connect(self.zoom_out)
        self.main_ui.zoomSlider.valueChanged.connect(self.change_zoom)
        self.main_ui.zoomSlider.valueChanged.connect(self.update_percent)
        self.main_ui.zoomSlider.setValue(10)

        self.sync_board()

    @Slot(int)
    def update_percent(self, val: int):
        self.main_ui.zoomPercent.setText(f"{val}%")

    @Slot()
    def zoom_in(self):
        value = self.main_ui.zoomSlider.value()
        self.main_ui.zoomSlider.setValue(value + 5)

    @Slot()
    def zoom_out(self):
        value = self.main_ui.zoomSlider.value()
        self.main_ui.zoomSlider.setValue(value - 5)

    @Slot(int)
    def change_zoom(self, val):
        self.main_ui.boardCanva.resetTransform()
        zoom = (val / 100) * self.max_zoom
        self.main_ui.boardCanva.scale(zoom, zoom)

    @Slot()
    def new_team(self):
        team = MakeTeamDialog.make_team(self)
        if team:
            self.board.teams.append(team)
            self.sync_board()

    @Slot()
    def remove_team(self):
        item = self.main_ui.TeamsList.currentItem()
        if item:
            team = item.get_team()
            self.board.teams.remove(team)
            self.sync_board()
        print(self.board.get_dict())

    @Slot()
    def save_board(self):
        filepath, _ = QFileDialog.getSaveFileName(
                self,
                "Save Board",
                "",
                "Board files (*.json)"
        )

        if filepath:
            self.board.pieces = [tile.get_piece() for tile in self.scene.items() if isinstance(tile, Tile) and tile.get_piece()]
            print(self.board.get_dict())
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

    @Slot()
    def put_piece(self):
        tile = self.sender()
        if isinstance(tile, Tile):
            team = self.main_ui.TeamsList.currentItem()
            if isinstance(team, TeamListItem) and team:
                team = team.get_team()
                tile.set_piece(Piece([tile.coordenate.x, tile.coordenate.y], team.name, self.selected_role))
                tile.set_team(team)

    def create_board_interface(self):
        black = True
        self.scene.clear()

        for y in range(self.board.size[1]):

            if self.board.size[0] % 2 == 0:
                black = not black

            for x in range(self.board.size[0]):

                color = Qt.GlobalColor.white
                if black:
                    color = Qt.GlobalColor.black

                tile = Tile(BoardPos(x, y), color)
                tile.left_click.connect(self.put_piece)
                self.scene.addItem(tile)

                black = not black

        board_wid = self.board.size[0] * 50
        board_hei = self.board.size[1] * 50

        self.main_ui.boardCanva.centerOn(0, 0)
        self.main_ui.boardCanva.resetTransform()


    def sync_board(self):
        self.main_ui.spinBox_width.setValue(self.board.size[0])
        self.main_ui.spinBox_height.setValue(self.board.size[1])

        team_list = self.main_ui.TeamsList
        team_list.clear()
        for team in self.board.teams:
            item = TeamListItem(team, team_list)
            exists = False

            for i in range(team_list.count()):
                if team_list.item(i).text() == item.text():
                    exists = True
                    break

            if not exists:
                team_list.addItem(item)


    @Slot()
    def make_board(self):

        if main_window.new_board_ui.exec() == QDialog.DialogCode.Accepted:
            main_window.board = Board(main_window.new_board_ui.get_size())
            main_window.sync_board()
            main_window.create_board_interface()
            print(main_window.board.get_dict())

    @Slot(int)
    def change_width(self, value: int):
        self.board.size[0] = value
        # print(self.board.size)
        self.sync_board()
        self.create_board_interface()

    @Slot(int)
    def change_height(self, value: int):
        self.board.size[1] = value
        # print(self.board.size)
        self.sync_board()
        self.create_board_interface()



if __name__ == '__main__':
    # Create the Qt Application
    app = QApplication(sys.argv)
    # Create and show the form
    main_window = Window()
    main_window.show()
    main_window.make_board()

    # Run the main Qt loop
    sys.exit(app.exec())
