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
    QGroupBox, QHBoxLayout, QLabel, QMainWindow,
    QMenu, QMenuBar, QPushButton, QScrollArea,
    QSizePolicy, QSpinBox, QStatusBar, QVBoxLayout,
    QWidget)

class Ui_BoardEditor(object):
    def setupUi(self, BoardEditor):
        if not BoardEditor.objectName():
            BoardEditor.setObjectName(u"BoardEditor")
        BoardEditor.resize(906, 910)
        self.actionSave = QAction(BoardEditor)
        self.actionSave.setObjectName(u"actionSave")
        self.actionLoad = QAction(BoardEditor)
        self.actionLoad.setObjectName(u"actionLoad")
        self.actionNew = QAction(BoardEditor)
        self.actionNew.setObjectName(u"actionNew")
        self.centralwidget = QWidget(BoardEditor)
        self.centralwidget.setObjectName(u"centralwidget")
        self.verticalLayout = QVBoxLayout(self.centralwidget)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.gridLayout = QGridLayout()
        self.gridLayout.setObjectName(u"gridLayout")
        self.BoardCanva = QGraphicsView(self.centralwidget)
        self.BoardCanva.setObjectName(u"BoardCanva")

        self.gridLayout.addWidget(self.BoardCanva, 1, 1, 1, 1)

        self.scrollArea = QScrollArea(self.centralwidget)
        self.scrollArea.setObjectName(u"scrollArea")
        self.scrollArea.setMinimumSize(QSize(400, 0))
        self.scrollArea.setMaximumSize(QSize(400, 16777215))
        self.scrollArea.setVerticalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAlwaysOn)
        self.scrollArea.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAsNeeded)
        self.scrollArea.setSizeAdjustPolicy(QAbstractScrollArea.SizeAdjustPolicy.AdjustToContentsOnFirstShow)
        self.scrollArea.setWidgetResizable(True)
        self.scrollContent = QWidget()
        self.scrollContent.setObjectName(u"scrollContent")
        self.scrollContent.setGeometry(QRect(0, 0, 384, 840))
        self.verticalLayoutWidget_3 = QWidget(self.scrollContent)
        self.verticalLayoutWidget_3.setObjectName(u"verticalLayoutWidget_3")
        self.verticalLayoutWidget_3.setGeometry(QRect(10, 10, 371, 958))
        self.scrollBox = QVBoxLayout(self.verticalLayoutWidget_3)
        self.scrollBox.setObjectName(u"scrollBox")
        self.scrollBox.setContentsMargins(0, 0, 0, 0)
        self.BoardSizeBox = QGroupBox(self.verticalLayoutWidget_3)
        self.BoardSizeBox.setObjectName(u"BoardSizeBox")
        self.BoardSizeBox.setMinimumSize(QSize(0, 150))
        self.BoardSizeBox.setMaximumSize(QSize(16777215, 150))
        self.verticalLayoutWidget = QWidget(self.BoardSizeBox)
        self.verticalLayoutWidget.setObjectName(u"verticalLayoutWidget")
        self.verticalLayoutWidget.setGeometry(QRect(10, 30, 223, 101))
        self.verticalLayout_2 = QVBoxLayout(self.verticalLayoutWidget)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.WidthLayout = QHBoxLayout()
        self.WidthLayout.setObjectName(u"WidthLayout")
        self.label_width = QLabel(self.verticalLayoutWidget)
        self.label_width.setObjectName(u"label_width")

        self.WidthLayout.addWidget(self.label_width)

        self.spinBox_width = QSpinBox(self.verticalLayoutWidget)
        self.spinBox_width.setObjectName(u"spinBox_width")
        self.spinBox_width.setMaximum(500)

        self.WidthLayout.addWidget(self.spinBox_width)


        self.verticalLayout_2.addLayout(self.WidthLayout)

        self.HeightLayout = QHBoxLayout()
        self.HeightLayout.setObjectName(u"HeightLayout")
        self.label_height = QLabel(self.verticalLayoutWidget)
        self.label_height.setObjectName(u"label_height")

        self.HeightLayout.addWidget(self.label_height)

        self.spinBox_height = QSpinBox(self.verticalLayoutWidget)
        self.spinBox_height.setObjectName(u"spinBox_height")
        self.spinBox_height.setMaximum(500)

        self.HeightLayout.addWidget(self.spinBox_height)


        self.verticalLayout_2.addLayout(self.HeightLayout)


        self.scrollBox.addWidget(self.BoardSizeBox)

        self.PiecesBox = QGroupBox(self.verticalLayoutWidget_3)
        self.PiecesBox.setObjectName(u"PiecesBox")
        self.PiecesScroll = QScrollArea(self.PiecesBox)
        self.PiecesScroll.setObjectName(u"PiecesScroll")
        self.PiecesScroll.setGeometry(QRect(10, 30, 351, 361))
        self.PiecesScroll.setWidgetResizable(True)
        self.scrollAreaWidgetContents_2 = QWidget()
        self.scrollAreaWidgetContents_2.setObjectName(u"scrollAreaWidgetContents_2")
        self.scrollAreaWidgetContents_2.setGeometry(QRect(0, 0, 349, 359))
        self.verticalLayoutWidget_4 = QWidget(self.scrollAreaWidgetContents_2)
        self.verticalLayoutWidget_4.setObjectName(u"verticalLayoutWidget_4")
        self.verticalLayoutWidget_4.setGeometry(QRect(0, 0, 341, 351))
        self.PiecesContainer = QVBoxLayout(self.verticalLayoutWidget_4)
        self.PiecesContainer.setObjectName(u"PiecesContainer")
        self.PiecesContainer.setContentsMargins(0, 0, 0, 0)
        self.PiecesScroll.setWidget(self.scrollAreaWidgetContents_2)

        self.scrollBox.addWidget(self.PiecesBox)

        self.TeamsBox = QGroupBox(self.verticalLayoutWidget_3)
        self.TeamsBox.setObjectName(u"TeamsBox")
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.TeamsBox.sizePolicy().hasHeightForWidth())
        self.TeamsBox.setSizePolicy(sizePolicy)
        self.TeamsBox.setMinimumSize(QSize(0, 300))
        self.verticalLayoutWidget_2 = QWidget(self.TeamsBox)
        self.verticalLayoutWidget_2.setObjectName(u"verticalLayoutWidget_2")
        self.verticalLayoutWidget_2.setGeometry(QRect(10, 30, 351, 232))
        self.TeamsLayout = QVBoxLayout(self.verticalLayoutWidget_2)
        self.TeamsLayout.setObjectName(u"TeamsLayout")
        self.TeamsLayout.setContentsMargins(0, 0, 0, 0)
        self.TeamsScrollArea = QScrollArea(self.verticalLayoutWidget_2)
        self.TeamsScrollArea.setObjectName(u"TeamsScrollArea")
        sizePolicy1 = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)
        sizePolicy1.setHorizontalStretch(0)
        sizePolicy1.setVerticalStretch(0)
        sizePolicy1.setHeightForWidth(self.TeamsScrollArea.sizePolicy().hasHeightForWidth())
        self.TeamsScrollArea.setSizePolicy(sizePolicy1)
        self.TeamsScrollArea.setMinimumSize(QSize(0, 150))
        self.TeamsScrollArea.setWidgetResizable(True)
        self.TeamsContainer = QWidget()
        self.TeamsContainer.setObjectName(u"TeamsContainer")
        self.TeamsContainer.setGeometry(QRect(0, 0, 347, 148))
        self.TeamsScrollArea.setWidget(self.TeamsContainer)

        self.TeamsLayout.addWidget(self.TeamsScrollArea)

        self.pushButton = QPushButton(self.verticalLayoutWidget_2)
        self.pushButton.setObjectName(u"pushButton")

        self.TeamsLayout.addWidget(self.pushButton)


        self.scrollBox.addWidget(self.TeamsBox)

        self.scrollArea.setWidget(self.scrollContent)

        self.gridLayout.addWidget(self.scrollArea, 1, 0, 1, 1)


        self.verticalLayout.addLayout(self.gridLayout)

        BoardEditor.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(BoardEditor)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 906, 24))
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
        self.pushButton.setText(QCoreApplication.translate("BoardEditor", u"New team", None))
        self.menuFile.setTitle(QCoreApplication.translate("BoardEditor", u"File", None))
    # retranslateUi

