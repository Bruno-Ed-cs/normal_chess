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

class Ui_MakeTeam(object):
    def setupUi(self, MakeTeam):
        if not MakeTeam.objectName():
            MakeTeam.setObjectName(u"MakeTeam")
        MakeTeam.resize(400, 300)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MakeTeam.sizePolicy().hasHeightForWidth())
        MakeTeam.setSizePolicy(sizePolicy)
        MakeTeam.setMinimumSize(QSize(400, 300))
        MakeTeam.setMaximumSize(QSize(400, 300))
        self.buttonBox = QDialogButtonBox(MakeTeam)
        self.buttonBox.setObjectName(u"buttonBox")
        self.buttonBox.setGeometry(QRect(50, 250, 341, 32))
        self.buttonBox.setOrientation(Qt.Orientation.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.StandardButton.Cancel|QDialogButtonBox.StandardButton.Ok)
        self.layoutWidget = QWidget(MakeTeam)
        self.layoutWidget.setObjectName(u"layoutWidget")
        self.layoutWidget.setGeometry(QRect(30, 20, 341, 54))
        self.verticalLayout = QVBoxLayout(self.layoutWidget)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.label_2 = QLabel(self.layoutWidget)
        self.label_2.setObjectName(u"label_2")

        self.verticalLayout.addWidget(self.label_2)

        self.nameEdit = QLineEdit(self.layoutWidget)
        self.nameEdit.setObjectName(u"nameEdit")

        self.verticalLayout.addWidget(self.nameEdit)

        self.layoutWidget1 = QWidget(MakeTeam)
        self.layoutWidget1.setObjectName(u"layoutWidget1")
        self.layoutWidget1.setGeometry(QRect(30, 80, 151, 91))
        self.gridLayout = QGridLayout(self.layoutWidget1)
        self.gridLayout.setObjectName(u"gridLayout")
        self.gridLayout.setContentsMargins(0, 0, 0, 0)
        self.marchSpinX = QSpinBox(self.layoutWidget1)
        self.marchSpinX.setObjectName(u"marchSpinX")
        self.marchSpinX.setMinimum(-1)
        self.marchSpinX.setMaximum(1)

        self.gridLayout.addWidget(self.marchSpinX, 3, 1, 1, 1)

        self.marchSpinY = QSpinBox(self.layoutWidget1)
        self.marchSpinY.setObjectName(u"marchSpinY")
        self.marchSpinY.setMinimum(-1)
        self.marchSpinY.setMaximum(1)

        self.gridLayout.addWidget(self.marchSpinY, 5, 1, 1, 1)

        self.label_5 = QLabel(self.layoutWidget1)
        self.label_5.setObjectName(u"label_5")

        self.gridLayout.addWidget(self.label_5, 3, 0, 1, 1)

        self.label_3 = QLabel(self.layoutWidget1)
        self.label_3.setObjectName(u"label_3")

        self.gridLayout.addWidget(self.label_3, 2, 0, 1, 1)

        self.label_4 = QLabel(self.layoutWidget1)
        self.label_4.setObjectName(u"label_4")

        self.gridLayout.addWidget(self.label_4, 5, 0, 1, 1)

        self.layoutWidget2 = QWidget(MakeTeam)
        self.layoutWidget2.setObjectName(u"layoutWidget2")
        self.layoutWidget2.setGeometry(QRect(250, 80, 102, 160))
        self.verticalLayout_2 = QVBoxLayout(self.layoutWidget2)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.label = QLabel(self.layoutWidget2)
        self.label.setObjectName(u"label")

        self.verticalLayout_2.addWidget(self.label)

        self.colorDisplay = QLabel(self.layoutWidget2)
        self.colorDisplay.setObjectName(u"colorDisplay")
        sizePolicy.setHeightForWidth(self.colorDisplay.sizePolicy().hasHeightForWidth())
        self.colorDisplay.setSizePolicy(sizePolicy)
        self.colorDisplay.setMinimumSize(QSize(80, 80))
        self.colorDisplay.setAutoFillBackground(True)
        self.colorDisplay.setFrameShape(QFrame.Shape.Box)
        self.colorDisplay.setFrameShadow(QFrame.Shadow.Raised)

        self.verticalLayout_2.addWidget(self.colorDisplay)

        self.colorButton = QPushButton(self.layoutWidget2)
        self.colorButton.setObjectName(u"colorButton")

        self.verticalLayout_2.addWidget(self.colorButton)


        self.retranslateUi(MakeTeam)
        self.buttonBox.accepted.connect(MakeTeam.accept)
        self.buttonBox.rejected.connect(MakeTeam.reject)

        QMetaObject.connectSlotsByName(MakeTeam)
    # setupUi

    def retranslateUi(self, MakeTeam):
        MakeTeam.setWindowTitle(QCoreApplication.translate("MakeTeam", u"Make team", None))
        self.label_2.setText(QCoreApplication.translate("MakeTeam", u"Name:", None))
        self.label_5.setText(QCoreApplication.translate("MakeTeam", u"X:", None))
        self.label_3.setText(QCoreApplication.translate("MakeTeam", u"March", None))
        self.label_4.setText(QCoreApplication.translate("MakeTeam", u"Y:", None))
        self.label.setText(QCoreApplication.translate("MakeTeam", u"Color:", None))
        self.colorDisplay.setText("")
        self.colorButton.setText(QCoreApplication.translate("MakeTeam", u"Pick Color", None))
    # retranslateUi

