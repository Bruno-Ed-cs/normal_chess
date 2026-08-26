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

class Ui_BoardEditor(object):
    def setupUi(self, BoardEditor):
        if not BoardEditor.objectName():
            BoardEditor.setObjectName(u"BoardEditor")
        BoardEditor.resize(1034, 942)
        self.actionSave = QAction(BoardEditor)
        self.actionSave.setObjectName(u"actionSave")
        self.actionLoad = QAction(BoardEditor)
        self.actionLoad.setObjectName(u"actionLoad")
        self.actionNew = QAction(BoardEditor)
        self.actionNew.setObjectName(u"actionNew")
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

        self.spinBox_width = QSpinBox(self.BoardSizeBox)
        self.spinBox_width.setObjectName(u"spinBox_width")
        self.spinBox_width.setMinimum(1)
        self.spinBox_width.setMaximum(500)

        self.WidthLayout.addWidget(self.spinBox_width)


        self.verticalLayout_2.addLayout(self.WidthLayout)

        self.HeightLayout = QHBoxLayout()
        self.HeightLayout.setObjectName(u"HeightLayout")
        self.label_height = QLabel(self.BoardSizeBox)
        self.label_height.setObjectName(u"label_height")

        self.HeightLayout.addWidget(self.label_height)

        self.spinBox_height = QSpinBox(self.BoardSizeBox)
        self.spinBox_height.setObjectName(u"spinBox_height")
        self.spinBox_height.setMinimum(1)
        self.spinBox_height.setMaximum(500)

        self.HeightLayout.addWidget(self.spinBox_height)


        self.verticalLayout_2.addLayout(self.HeightLayout)


        self.verticalLayout_7.addLayout(self.verticalLayout_2)


        self.scrollBox.addWidget(self.BoardSizeBox)

        self.PiecesBox = QGroupBox(self.scrollContent)
        self.PiecesBox.setObjectName(u"PiecesBox")
        self.PiecesBox.setMinimumSize(QSize(0, 250))
        self.verticalLayout_5 = QVBoxLayout(self.PiecesBox)
        self.verticalLayout_5.setObjectName(u"verticalLayout_5")
        self.PiecesScroll = QScrollArea(self.PiecesBox)
        self.PiecesScroll.setObjectName(u"PiecesScroll")
        self.PiecesScroll.setSizeAdjustPolicy(QAbstractScrollArea.SizeAdjustPolicy.AdjustToContents)
        self.PiecesScroll.setWidgetResizable(True)
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
        self.PiecesContainer = QVBoxLayout()
        self.PiecesContainer.setObjectName(u"PiecesContainer")
        self.PiecesContainer.setSizeConstraint(QLayout.SizeConstraint.SetNoConstraint)
        self.PiecesContainer.setContentsMargins(5, 5, 5, 10)

        self.verticalLayout_3.addLayout(self.PiecesContainer)

        self.PiecesScroll.setWidget(self.scrollAreaWidgetContents_2)

        self.verticalLayout_5.addWidget(self.PiecesScroll)


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
        self.TeamsList = QListWidget(self.TeamsBox)
        self.TeamsList.setObjectName(u"TeamsList")
        self.TeamsList.setSpacing(10)
        self.TeamsList.setWordWrap(True)

        self.verticalLayout_6.addWidget(self.TeamsList)

        self.TeamsLayout = QVBoxLayout()
        self.TeamsLayout.setObjectName(u"TeamsLayout")
        self.newTeamButton = QPushButton(self.TeamsBox)
        self.newTeamButton.setObjectName(u"newTeamButton")

        self.TeamsLayout.addWidget(self.newTeamButton)

        self.removeTeamButton = QPushButton(self.TeamsBox)
        self.removeTeamButton.setObjectName(u"removeTeamButton")

        self.TeamsLayout.addWidget(self.removeTeamButton)


        self.verticalLayout_6.addLayout(self.TeamsLayout)


        self.scrollBox.addWidget(self.TeamsBox)


        self.verticalLayout_4.addLayout(self.scrollBox)

        self.ControlsScroll.setWidget(self.scrollContent)

        self.gridLayout.addWidget(self.ControlsScroll, 1, 0, 1, 1)

        self.verticalLayout_8 = QVBoxLayout()
        self.verticalLayout_8.setObjectName(u"verticalLayout_8")
        self.boardCanva = QGraphicsView(self.centralwidget)
        self.boardCanva.setObjectName(u"boardCanva")
        self.boardCanva.setDragMode(QGraphicsView.DragMode.ScrollHandDrag)
        self.boardCanva.setTransformationAnchor(QGraphicsView.ViewportAnchor.NoAnchor)
        self.boardCanva.setResizeAnchor(QGraphicsView.ViewportAnchor.AnchorViewCenter)

        self.verticalLayout_8.addWidget(self.boardCanva)

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
        self.zoomOut = QToolButton(self.groupBox)
        self.zoomOut.setObjectName(u"zoomOut")
        self.zoomOut.setText(u"")
        icon = QIcon(QIcon.fromTheme(QIcon.ThemeIcon.ZoomOut))
        self.zoomOut.setIcon(icon)
        self.zoomOut.setAutoRepeat(True)

        self.horizontalLayout_3.addWidget(self.zoomOut)

        self.zoomIn = QToolButton(self.groupBox)
        self.zoomIn.setObjectName(u"zoomIn")
        icon1 = QIcon(QIcon.fromTheme(QIcon.ThemeIcon.ZoomIn))
        self.zoomIn.setIcon(icon1)
        self.zoomIn.setAutoRepeat(True)

        self.horizontalLayout_3.addWidget(self.zoomIn)

        self.zoomSlider = QSlider(self.groupBox)
        self.zoomSlider.setObjectName(u"zoomSlider")
        self.zoomSlider.setMinimum(1)
        self.zoomSlider.setMaximum(100)
        self.zoomSlider.setValue(1)
        self.zoomSlider.setOrientation(Qt.Orientation.Horizontal)

        self.horizontalLayout_3.addWidget(self.zoomSlider)

        self.zoomPercent = QLabel(self.groupBox)
        self.zoomPercent.setObjectName(u"zoomPercent")

        self.horizontalLayout_3.addWidget(self.zoomPercent)


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
        self.menuFile.addAction(self.actionSave)
        self.menuFile.addAction(self.actionLoad)
        self.menuFile.addAction(self.actionNew)

        self.retranslateUi(BoardEditor)

        QMetaObject.connectSlotsByName(BoardEditor)
    # setupUi

    def retranslateUi(self, BoardEditor):
        BoardEditor.setWindowTitle(QCoreApplication.translate("BoardEditor", u"Board Editor", None))
        self.actionSave.setText(QCoreApplication.translate("BoardEditor", u"Save", None))
        self.actionLoad.setText(QCoreApplication.translate("BoardEditor", u"Load", None))
        self.actionNew.setText(QCoreApplication.translate("BoardEditor", u"New", None))
        self.BoardSizeBox.setTitle(QCoreApplication.translate("BoardEditor", u"Board size:", None))
        self.label_width.setText(QCoreApplication.translate("BoardEditor", u"Width", None))
        self.label_height.setText(QCoreApplication.translate("BoardEditor", u"Height", None))
        self.PiecesBox.setTitle(QCoreApplication.translate("BoardEditor", u"Pieces", None))
        self.TeamsBox.setTitle(QCoreApplication.translate("BoardEditor", u"Teams", None))
        self.newTeamButton.setText(QCoreApplication.translate("BoardEditor", u"New team", None))
        self.removeTeamButton.setText(QCoreApplication.translate("BoardEditor", u"Remove team", None))
        self.zoomIn.setText("")
        self.zoomPercent.setText(QCoreApplication.translate("BoardEditor", u"0%", None))
        self.menuFile.setTitle(QCoreApplication.translate("BoardEditor", u"File", None))
    # retranslateUi

