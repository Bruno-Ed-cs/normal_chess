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
    piece: Piece | None
    team: Team | None
    default_color: QColor
    sprite: QPixmap | None

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

    def get_team(self):
        return self.team

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
            # print(self.coordenate.x, self.coordenate.y)
            self.clean()

    def paint(self, painter, option, widget=None):

        brush = QBrush(self.default_color)

        # print(self.team)
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
            # print("i have a sprite")
            painter.drawPixmap(self.rect().topLeft(), self.sprite)



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
            # print(team.__dict__)
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
        self.change_zoom(10)


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
            self.main_ui.TeamsList.addItem(TeamListItem(team))

    @Slot()
    def remove_team(self):
        item = self.main_ui.TeamsList.currentRow()
        if item > -1:
            team = self.main_ui.TeamsList.takeItem(item)
            if isinstance(team, TeamListItem):
                self.cleanup_team(team.get_team())

    @Slot()
    def save_board(self):
        filepath, _ = QFileDialog.getSaveFileName(
                self,
                "Save Board",
                "",
                "Board files (*.json)"
        )

        if filepath:
            width = self.main_ui.spinBox_width.value()
            height = self.main_ui.spinBox_height.value()

            board = Board([width, height])
            board.pieces = [tile.get_piece() for tile in self.scene.items() if isinstance(tile, Tile) and tile.get_piece()]
            board.teams = [self.main_ui.TeamsList.item(i).get_team() for i in range(self.main_ui.TeamsList.count()) if isinstance(self.main_ui.TeamsList.item(i), TeamListItem)]
            print(board.get_dict())
            board.save_to_file(filepath)

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
                board = Board()
                board.load_from_json(data)

                spinBox_width = self.main_ui.spinBox_width
                spinBox_height = self.main_ui.spinBox_height

                TeamsList = self.main_ui.TeamsList

                board_scene = self.scene

                spinBox_width.setValue(board.size[0])
                spinBox_height.setValue(board.size[1])

                TeamsList.clear()
                for team in board.teams:
                    TeamsList.addItem(TeamListItem(team))

                black = True
                board_scene.clear()

                for y in range(board.size[1]):

                    if board.size[0] % 2 == 0:
                        black = not black

                    for x in range(board.size[0]):

                        color = Qt.GlobalColor.white
                        if black:
                            color = Qt.GlobalColor.black

                        tile = Tile(BoardPos(x, y), color)
                        tile.left_click.connect(self.put_piece)

                        piece = next((p for p in board.pieces if p.position == [x, y]), None)
                        if piece:
                            team = next((t for t in board.teams if piece.team == t.name), None)
                            if team:
                                tile.set_team(team)
                                tile.set_piece(piece)

                        board_scene.addItem(tile)

                        black = not black

                self.main_ui.boardCanva.centerOn(0, 0)
                self.main_ui.boardCanva.resetTransform()

    def cleanup_team(self, team: Team):

        for tile in self.scene.items():
            if isinstance(tile, Tile):
                if tile.get_team() == team:
                    tile.clean()

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

    def create_board_interface(self, size: BoardPos, keep_pieces: bool = True):

        pieces = []

        if keep_pieces:
            for tile in self.scene.items():
                if isinstance(tile, Tile):
                    if tile.get_piece():
                        pieces.append(tile.get_piece())


        black = True
        self.scene.clear()

        for y in range(size.y):

            if size.x % 2 == 0:
                black = not black

            for x in range(size.x):

                color = Qt.GlobalColor.white
                if black:
                    color = Qt.GlobalColor.black

                tile = Tile(BoardPos(x, y), color)
                tile.left_click.connect(self.put_piece)

                if keep_pieces:
                    last_piece = next((p for p in pieces if p.position == [x, y]), None)

                    if last_piece:
                        team_list = self.main_ui.TeamsList
                        team = next((team_list.item(i).get_team() 
                                     for i in range(team_list.count()) 
                                     if isinstance(team_list.item(i), TeamListItem) and team_list.item(i).get_team().name == last_piece.team),
                                    None)
                        if team:
                            tile.set_piece(last_piece)
                            tile.set_team(team)

                self.scene.addItem(tile)

                black = not black

        board_wid = size.x * 50
        board_hei = size.y * 50

        self.main_ui.boardCanva.centerOn(0, 0)
        self.main_ui.boardCanva.resetTransform()


    @Slot()
    def make_board(self):

        if self.new_board_ui.exec() == QDialog.DialogCode.Accepted:
            self.create_board_interface(BoardPos(*self.new_board_ui.get_size()), False)
            self.main_ui.TeamsList.clear()

    @Slot(int)
    def change_width(self, value: int):
        self.create_board_interface(BoardPos(
            value,
            self.main_ui.spinBox_height.value()
            ))
        # print(self.board.size)

    @Slot(int)
    def change_height(self, value: int):
        self.create_board_interface(BoardPos(
            self.main_ui.spinBox_width.value(),
            value
            ))
        # print(self.board.size)



if __name__ == '__main__':
    # Create the Qt Application
    app = QApplication(sys.argv)
    # Create and show the form
    main_window = Window()
    main_window.show()
    main_window.make_board()

    # Run the main Qt loop
    sys.exit(app.exec())
