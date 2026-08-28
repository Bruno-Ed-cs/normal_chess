# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'board_editor.ui'
##
## Created by: Qt User Interface Compiler version 6.11.2
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QAction, QBrush, QColor, QConicalGradient,
    QCursor, QFont, QFontDatabase, QGradient,
    QIcon, QImage, QKeySequence, QLinearGradient,
    QPainter, QPalette, QPixmap, QRadialGradient,
    QTransform)
from PySide6.QtWidgets import (QAbstractScrollArea, QApplication, QGraphicsView, QGridLayout,
    QGroupBox, QHBoxLayout, QLabel, QLayout,
    QListWidget, QListWidgetItem, QMainWindow, QMenu,
    QMenuBar, QPushButton, QScrollArea, QSizePolicy,
    QSlider, QSpacerItem, QSpinBox, QStatusBar,
    QToolButton, QVBoxLayout, QWidget)
import sprites_rc

class Ui_BoardEditor(object):
    def setupUi(self, BoardEditor):
        if not BoardEditor.objectName():
            BoardEditor.setObjectName(u"BoardEditor")
        BoardEditor.resize(1034, 942)
        self.action_save = QAction(BoardEditor)
        self.action_save.setObjectName(u"action_save")
        self.action_load = QAction(BoardEditor)
        self.action_load.setObjectName(u"action_load")
        self.action_new = QAction(BoardEditor)
        self.action_new.setObjectName(u"action_new")
        self.centralwidget = QWidget(BoardEditor)
        self.centralwidget.setObjectName(u"centralwidget")
        self.horizontalLayout_2 = QHBoxLayout(self.centralwidget)
        self.horizontalLayout_2.setObjectName(u"horizontalLayout_2")
        self.gridLayout = QGridLayout()
        self.gridLayout.setObjectName(u"gridLayout")
        self.ControlsScroll = QScrollArea(self.centralwidget)
        self.ControlsScroll.setObjectName(u"ControlsScroll")
        self.ControlsScroll.setMinimumSize(QSize(400, 0))
        self.ControlsScroll.setMaximumSize(QSize(400, 16777215))
        self.ControlsScroll.setVerticalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAsNeeded)
        self.ControlsScroll.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAsNeeded)
        self.ControlsScroll.setSizeAdjustPolicy(QAbstractScrollArea.SizeAdjustPolicy.AdjustToContentsOnFirstShow)
        self.ControlsScroll.setWidgetResizable(True)
        self.scrollContent = QWidget()
        self.scrollContent.setObjectName(u"scrollContent")
        self.scrollContent.setGeometry(QRect(0, 0, 398, 872))
        self.verticalLayout_4 = QVBoxLayout(self.scrollContent)
        self.verticalLayout_4.setObjectName(u"verticalLayout_4")
        self.scrollBox = QVBoxLayout()
        self.scrollBox.setObjectName(u"scrollBox")
        self.BoardSizeBox = QGroupBox(self.scrollContent)
        self.BoardSizeBox.setObjectName(u"BoardSizeBox")
        self.BoardSizeBox.setMinimumSize(QSize(0, 150))
        self.BoardSizeBox.setMaximumSize(QSize(16777215, 150))
        self.verticalLayout_7 = QVBoxLayout(self.BoardSizeBox)
        self.verticalLayout_7.setObjectName(u"verticalLayout_7")
        self.verticalLayout_2 = QVBoxLayout()
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.WidthLayout = QHBoxLayout()
        self.WidthLayout.setObjectName(u"WidthLayout")
        self.label_width = QLabel(self.BoardSizeBox)
        self.label_width.setObjectName(u"label_width")

        self.WidthLayout.addWidget(self.label_width)

        self.spinbox_width = QSpinBox(self.BoardSizeBox)
        self.spinbox_width.setObjectName(u"spinbox_width")
        self.spinbox_width.setMinimum(1)
        self.spinbox_width.setMaximum(500)
        self.spinbox_width.setValue(8)

        self.WidthLayout.addWidget(self.spinbox_width)


        self.verticalLayout_2.addLayout(self.WidthLayout)

        self.HeightLayout = QHBoxLayout()
        self.HeightLayout.setObjectName(u"HeightLayout")
        self.label_height = QLabel(self.BoardSizeBox)
        self.label_height.setObjectName(u"label_height")

        self.HeightLayout.addWidget(self.label_height)

        self.spinbox_height = QSpinBox(self.BoardSizeBox)
        self.spinbox_height.setObjectName(u"spinbox_height")
        self.spinbox_height.setMinimum(1)
        self.spinbox_height.setMaximum(500)
        self.spinbox_height.setValue(8)

        self.HeightLayout.addWidget(self.spinbox_height)


        self.verticalLayout_2.addLayout(self.HeightLayout)


        self.verticalLayout_7.addLayout(self.verticalLayout_2)


        self.scrollBox.addWidget(self.BoardSizeBox)

        self.PiecesBox = QGroupBox(self.scrollContent)
        self.PiecesBox.setObjectName(u"PiecesBox")
        self.PiecesBox.setMinimumSize(QSize(0, 250))
        self.verticalLayout_5 = QVBoxLayout(self.PiecesBox)
        self.verticalLayout_5.setObjectName(u"verticalLayout_5")
        self.pieces_scroll = QScrollArea(self.PiecesBox)
        self.pieces_scroll.setObjectName(u"pieces_scroll")
        self.pieces_scroll.setSizeAdjustPolicy(QAbstractScrollArea.SizeAdjustPolicy.AdjustToContents)
        self.pieces_scroll.setWidgetResizable(True)
        self.scrollAreaWidgetContents_2 = QWidget()
        self.scrollAreaWidgetContents_2.setObjectName(u"scrollAreaWidgetContents_2")
        self.scrollAreaWidgetContents_2.setEnabled(True)
        self.scrollAreaWidgetContents_2.setGeometry(QRect(0, 0, 352, 297))
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.scrollAreaWidgetContents_2.sizePolicy().hasHeightForWidth())
        self.scrollAreaWidgetContents_2.setSizePolicy(sizePolicy)
        self.verticalLayout_3 = QVBoxLayout(self.scrollAreaWidgetContents_2)
        self.verticalLayout_3.setObjectName(u"verticalLayout_3")
        self.pieces_container = QVBoxLayout()
        self.pieces_container.setObjectName(u"pieces_container")
        self.pieces_container.setSizeConstraint(QLayout.SizeConstraint.SetNoConstraint)
        self.pieces_container.setContentsMargins(5, 5, 5, 10)

        self.verticalLayout_3.addLayout(self.pieces_container)

        self.pieces_scroll.setWidget(self.scrollAreaWidgetContents_2)

        self.verticalLayout_5.addWidget(self.pieces_scroll)


        self.scrollBox.addWidget(self.PiecesBox)

        self.TeamsBox = QGroupBox(self.scrollContent)
        self.TeamsBox.setObjectName(u"TeamsBox")
        sizePolicy1 = QSizePolicy(QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Preferred)
        sizePolicy1.setHorizontalStretch(0)
        sizePolicy1.setVerticalStretch(0)
        sizePolicy1.setHeightForWidth(self.TeamsBox.sizePolicy().hasHeightForWidth())
        self.TeamsBox.setSizePolicy(sizePolicy1)
        self.TeamsBox.setMinimumSize(QSize(0, 0))
        self.TeamsBox.setFlat(False)
        self.TeamsBox.setCheckable(False)
        self.verticalLayout_6 = QVBoxLayout(self.TeamsBox)
        self.verticalLayout_6.setObjectName(u"verticalLayout_6")
        self.teams_list = QListWidget(self.TeamsBox)
        self.teams_list.setObjectName(u"teams_list")
        self.teams_list.setSpacing(10)
        self.teams_list.setWordWrap(True)

        self.verticalLayout_6.addWidget(self.teams_list)

        self.TeamsLayout = QVBoxLayout()
        self.TeamsLayout.setObjectName(u"TeamsLayout")
        self.new_team_button = QPushButton(self.TeamsBox)
        self.new_team_button.setObjectName(u"new_team_button")

        self.TeamsLayout.addWidget(self.new_team_button)

        self.remove_team_button = QPushButton(self.TeamsBox)
        self.remove_team_button.setObjectName(u"remove_team_button")

        self.TeamsLayout.addWidget(self.remove_team_button)


        self.verticalLayout_6.addLayout(self.TeamsLayout)


        self.scrollBox.addWidget(self.TeamsBox)


        self.verticalLayout_4.addLayout(self.scrollBox)

        self.ControlsScroll.setWidget(self.scrollContent)

        self.gridLayout.addWidget(self.ControlsScroll, 1, 0, 1, 1)

        self.verticalLayout_8 = QVBoxLayout()
        self.verticalLayout_8.setObjectName(u"verticalLayout_8")
        self.board_canva = QGraphicsView(self.centralwidget)
        self.board_canva.setObjectName(u"board_canva")
        self.board_canva.setDragMode(QGraphicsView.DragMode.NoDrag)
        self.board_canva.setTransformationAnchor(QGraphicsView.ViewportAnchor.NoAnchor)
        self.board_canva.setResizeAnchor(QGraphicsView.ViewportAnchor.AnchorViewCenter)

        self.verticalLayout_8.addWidget(self.board_canva)

        self.groupBox = QGroupBox(self.centralwidget)
        self.groupBox.setObjectName(u"groupBox")
        self.groupBox.setMinimumSize(QSize(0, 80))
        self.groupBox.setFlat(True)
        self.horizontalLayout_4 = QHBoxLayout(self.groupBox)
        self.horizontalLayout_4.setObjectName(u"horizontalLayout_4")
        self.horizontalSpacer = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout_4.addItem(self.horizontalSpacer)

        self.horizontalLayout_3 = QHBoxLayout()
        self.horizontalLayout_3.setObjectName(u"horizontalLayout_3")
        self.zoom_out = QToolButton(self.groupBox)
        self.zoom_out.setObjectName(u"zoom_out")
        self.zoom_out.setText(u"")
        icon = QIcon(QIcon.fromTheme(QIcon.ThemeIcon.ZoomOut))
        self.zoom_out.setIcon(icon)
        self.zoom_out.setAutoRepeat(True)

        self.horizontalLayout_3.addWidget(self.zoom_out)

        self.zoom_in = QToolButton(self.groupBox)
        self.zoom_in.setObjectName(u"zoom_in")
        icon1 = QIcon(QIcon.fromTheme(QIcon.ThemeIcon.ZoomIn))
        self.zoom_in.setIcon(icon1)
        self.zoom_in.setAutoRepeat(True)

        self.horizontalLayout_3.addWidget(self.zoom_in)

        self.zoom_slider = QSlider(self.groupBox)
        self.zoom_slider.setObjectName(u"zoom_slider")
        self.zoom_slider.setMinimum(1)
        self.zoom_slider.setMaximum(100)
        self.zoom_slider.setValue(1)
        self.zoom_slider.setOrientation(Qt.Orientation.Horizontal)

        self.horizontalLayout_3.addWidget(self.zoom_slider)

        self.zoom_percent = QLabel(self.groupBox)
        self.zoom_percent.setObjectName(u"zoom_percent")

        self.horizontalLayout_3.addWidget(self.zoom_percent)


        self.horizontalLayout_4.addLayout(self.horizontalLayout_3)


        self.verticalLayout_8.addWidget(self.groupBox)


        self.gridLayout.addLayout(self.verticalLayout_8, 1, 1, 1, 1)


        self.horizontalLayout_2.addLayout(self.gridLayout)

        BoardEditor.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(BoardEditor)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 1034, 24))
        self.menuFile = QMenu(self.menubar)
        self.menuFile.setObjectName(u"menuFile")
        BoardEditor.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(BoardEditor)
        self.statusbar.setObjectName(u"statusbar")
        BoardEditor.setStatusBar(self.statusbar)

        self.menubar.addAction(self.menuFile.menuAction())
        self.menuFile.addAction(self.action_save)
        self.menuFile.addAction(self.action_load)
        self.menuFile.addAction(self.action_new)

        self.retranslateUi(BoardEditor)

        QMetaObject.connectSlotsByName(BoardEditor)
    # setupUi

    def retranslateUi(self, BoardEditor):
        BoardEditor.setWindowTitle(QCoreApplication.translate("BoardEditor", u"Board Editor", None))
        self.action_save.setText(QCoreApplication.translate("BoardEditor", u"Save", None))
        self.action_load.setText(QCoreApplication.translate("BoardEditor", u"Load", None))
        self.action_new.setText(QCoreApplication.translate("BoardEditor", u"New", None))
        self.BoardSizeBox.setTitle(QCoreApplication.translate("BoardEditor", u"Board size:", None))
        self.label_width.setText(QCoreApplication.translate("BoardEditor", u"Width", None))
        self.label_height.setText(QCoreApplication.translate("BoardEditor", u"Height", None))
        self.PiecesBox.setTitle(QCoreApplication.translate("BoardEditor", u"Pieces", None))
        self.TeamsBox.setTitle(QCoreApplication.translate("BoardEditor", u"Teams", None))
        self.new_team_button.setText(QCoreApplication.translate("BoardEditor", u"New team", None))
        self.remove_team_button.setText(QCoreApplication.translate("BoardEditor", u"Remove team", None))
        self.zoom_in.setText("")
        self.zoom_percent.setText(QCoreApplication.translate("BoardEditor", u"0%", None))
        self.menuFile.setTitle(QCoreApplication.translate("BoardEditor", u"File", None))
    # retranslateUi

