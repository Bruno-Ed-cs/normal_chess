# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'make_team.ui'
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
    QFrame, QGridLayout, QLabel, QLineEdit,
    QPushButton, QSizePolicy, QSpinBox, QVBoxLayout,
    QWidget)

class Ui_MakeTeamDialog(object):
    def setupUi(self, MakeTeamDialog):
        if not MakeTeamDialog.objectName():
            MakeTeamDialog.setObjectName(u"MakeTeamDialog")
        MakeTeamDialog.resize(400, 300)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MakeTeamDialog.sizePolicy().hasHeightForWidth())
        MakeTeamDialog.setSizePolicy(sizePolicy)
        MakeTeamDialog.setMinimumSize(QSize(400, 300))
        MakeTeamDialog.setMaximumSize(QSize(400, 300))
        self.buttonBox = QDialogButtonBox(MakeTeamDialog)
        self.buttonBox.setObjectName(u"buttonBox")
        self.buttonBox.setGeometry(QRect(50, 250, 341, 32))
        self.buttonBox.setOrientation(Qt.Orientation.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.StandardButton.Cancel|QDialogButtonBox.StandardButton.Ok)
        self.widget = QWidget(MakeTeamDialog)
        self.widget.setObjectName(u"widget")
        self.widget.setGeometry(QRect(30, 20, 341, 54))
        self.verticalLayout = QVBoxLayout(self.widget)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.label_2 = QLabel(self.widget)
        self.label_2.setObjectName(u"label_2")

        self.verticalLayout.addWidget(self.label_2)

        self.lineEdit = QLineEdit(self.widget)
        self.lineEdit.setObjectName(u"lineEdit")

        self.verticalLayout.addWidget(self.lineEdit)

        self.widget1 = QWidget(MakeTeamDialog)
        self.widget1.setObjectName(u"widget1")
        self.widget1.setGeometry(QRect(30, 80, 151, 91))
        self.gridLayout = QGridLayout(self.widget1)
        self.gridLayout.setObjectName(u"gridLayout")
        self.gridLayout.setContentsMargins(0, 0, 0, 0)
        self.spinBox = QSpinBox(self.widget1)
        self.spinBox.setObjectName(u"spinBox")

        self.gridLayout.addWidget(self.spinBox, 3, 1, 1, 1)

        self.spinBox_2 = QSpinBox(self.widget1)
        self.spinBox_2.setObjectName(u"spinBox_2")

        self.gridLayout.addWidget(self.spinBox_2, 5, 1, 1, 1)

        self.label_5 = QLabel(self.widget1)
        self.label_5.setObjectName(u"label_5")

        self.gridLayout.addWidget(self.label_5, 3, 0, 1, 1)

        self.label_3 = QLabel(self.widget1)
        self.label_3.setObjectName(u"label_3")

        self.gridLayout.addWidget(self.label_3, 2, 0, 1, 1)

        self.label_4 = QLabel(self.widget1)
        self.label_4.setObjectName(u"label_4")

        self.gridLayout.addWidget(self.label_4, 5, 0, 1, 1)

        self.widget2 = QWidget(MakeTeamDialog)
        self.widget2.setObjectName(u"widget2")
        self.widget2.setGeometry(QRect(250, 80, 102, 160))
        self.verticalLayout_2 = QVBoxLayout(self.widget2)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.label = QLabel(self.widget2)
        self.label.setObjectName(u"label")

        self.verticalLayout_2.addWidget(self.label)

        self.label_6 = QLabel(self.widget2)
        self.label_6.setObjectName(u"label_6")
        sizePolicy.setHeightForWidth(self.label_6.sizePolicy().hasHeightForWidth())
        self.label_6.setSizePolicy(sizePolicy)
        self.label_6.setMinimumSize(QSize(80, 80))
        self.label_6.setAutoFillBackground(True)
        self.label_6.setFrameShape(QFrame.Shape.Box)
        self.label_6.setFrameShadow(QFrame.Shadow.Raised)

        self.verticalLayout_2.addWidget(self.label_6)

        self.pushButton = QPushButton(self.widget2)
        self.pushButton.setObjectName(u"pushButton")

        self.verticalLayout_2.addWidget(self.pushButton)


        self.retranslateUi(MakeTeamDialog)
        self.buttonBox.accepted.connect(MakeTeamDialog.accept)
        self.buttonBox.rejected.connect(MakeTeamDialog.reject)

        QMetaObject.connectSlotsByName(MakeTeamDialog)
    # setupUi

    def retranslateUi(self, MakeTeamDialog):
        MakeTeamDialog.setWindowTitle(QCoreApplication.translate("MakeTeamDialog", u"Make team", None))
        self.label_2.setText(QCoreApplication.translate("MakeTeamDialog", u"Name:", None))
        self.label_5.setText(QCoreApplication.translate("MakeTeamDialog", u"X:", None))
        self.label_3.setText(QCoreApplication.translate("MakeTeamDialog", u"March", None))
        self.label_4.setText(QCoreApplication.translate("MakeTeamDialog", u"Y:", None))
        self.label.setText(QCoreApplication.translate("MakeTeamDialog", u"Color:", None))
        self.label_6.setText("")
        self.pushButton.setText(QCoreApplication.translate("MakeTeamDialog", u"Pick Color", None))
    # retranslateUi

