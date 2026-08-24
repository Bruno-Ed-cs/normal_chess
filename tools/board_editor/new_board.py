# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'new_board.ui'
##
## Created by: Qt User Interface Compiler version 6.11.2
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QAbstractButton, QApplication, QDialog, QDialogButtonBox,
    QGroupBox, QHBoxLayout, QLabel, QSizePolicy,
    QSpinBox, QVBoxLayout, QWidget)

class Ui_NewBoard(object):
    def setupUi(self, NewBoard):
        if not NewBoard.objectName():
            NewBoard.setObjectName(u"NewBoard")
        NewBoard.resize(400, 300)
        NewBoard.setMinimumSize(QSize(400, 300))
        NewBoard.setMaximumSize(QSize(400, 300))
        self.buttonBox = QDialogButtonBox(NewBoard)
        self.buttonBox.setObjectName(u"buttonBox")
        self.buttonBox.setGeometry(QRect(30, 240, 341, 32))
        self.buttonBox.setOrientation(Qt.Orientation.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.StandardButton.Cancel|QDialogButtonBox.StandardButton.Ok)
        self.BoardSizeBox = QGroupBox(NewBoard)
        self.BoardSizeBox.setObjectName(u"BoardSizeBox")
        self.BoardSizeBox.setGeometry(QRect(20, 30, 369, 150))
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


        self.retranslateUi(NewBoard)
        self.buttonBox.accepted.connect(NewBoard.accept)
        self.buttonBox.rejected.connect(NewBoard.reject)

        QMetaObject.connectSlotsByName(NewBoard)
    # setupUi

    def retranslateUi(self, NewBoard):
        NewBoard.setWindowTitle(QCoreApplication.translate("NewBoard", u"Create new board", None))
        self.BoardSizeBox.setTitle(QCoreApplication.translate("NewBoard", u"Board size:", None))
        self.label_width.setText(QCoreApplication.translate("NewBoard", u"Width", None))
        self.label_height.setText(QCoreApplication.translate("NewBoard", u"Height", None))
    # retranslateUi

