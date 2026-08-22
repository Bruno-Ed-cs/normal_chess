import sys
from PySide6.QtWidgets import *

import main_menu as mm

class Window(QMainWindow):

    def __init__(self):
        super().__init__()

        # 1. Load the UI
        self.ui = mm.MainMenu()
        self.ui.setupUi(self)

        # 2. Fix all scroll areas
        self.fix_main_scroll_area()
        self.fix_pieces_scroll_area()
        self.fix_teams_scroll_area()

        # 3. Add sample content to make them scroll
        self.populate_pieces()
        self.populate_teams()

    def fix_main_scroll_area(self):
        """Make the main left panel scroll vertically."""
        # Get the content widget of the main scroll area
        content = self.ui.scrollContent  # this is the widget inside scrollArea

        # Clear any existing children (we'll reparent them)
        # Remove the old verticalLayoutWidget_3 which used absolute geometry
        old_widget = self.ui.verticalLayoutWidget_3
        # We'll take its children (the group boxes) and put them directly into content
        group_boxes = []
        for child in old_widget.children():
            if isinstance(child, QGroupBox):
                group_boxes.append(child)

        # Create a new layout for content
        layout = QVBoxLayout(content)
        layout.setContentsMargins(10, 10, 10, 10)
        layout.setSpacing(10)

        # Add the group boxes to the layout
        for gb in group_boxes:
            # Reparent to content (the layout will take ownership)
            layout.addWidget(gb)

        # Remove the old container widget (it's now empty)
        old_widget.deleteLater()

        # Ensure the scroll area resizes the content appropriately
        self.ui.scrollArea.setWidgetResizable(True)

        # Store the layout for future additions
        self.main_layout = layout

    def fix_pieces_scroll_area(self):
        """Make the Pieces scroll area (scrollArea_3) work."""
        # Get the container widget inside scrollArea_3
        container = self.ui.scrollAreaWidgetContents_3

        # It might have an old absolute-positioned widget (verticalLayoutWidget_4)
        old_widget = self.ui.verticalLayoutWidget_4
        # We'll take its layout items? Actually it has a layout but it's empty.
        # We'll just create a new layout on the container and add items directly.
        # Delete the old widget
        old_widget.deleteLater()

        # Create a layout on the container
        layout = QVBoxLayout(container)
        layout.setContentsMargins(10, 10, 10, 10)
        layout.setSpacing(5)

        # Store for later population
        self.pieces_layout = layout

        # Ensure resizable
        self.ui.scrollArea_3.setWidgetResizable(True)

    def fix_teams_scroll_area(self):
        """Make the Teams scroll area (scrollArea_2) work."""
        container = self.ui.scrollAreaWidgetContents_2
        # It has no children yet, just create a layout
        layout = QVBoxLayout(container)
        layout.setContentsMargins(10, 10, 10, 10)
        layout.setSpacing(5)

        self.teams_layout = layout
        self.ui.scrollArea_2.setWidgetResizable(True)

    def populate_pieces(self):
        """Add 30 sample piece entries to the Pieces scroll area."""
        for i in range(30):
            # Create a row: piece name + button
            row = QWidget()
            row_layout = QHBoxLayout(row)
            row_layout.setContentsMargins(0, 0, 0, 0)
            label = QLabel(f"Piece {i+1}")
            btn = QPushButton("Select")
            row_layout.addWidget(label)
            row_layout.addWidget(btn)
            self.pieces_layout.addWidget(row)

    def populate_teams(self):
        """Add 20 sample team entries to the Teams scroll area."""
        for i in range(20):
            row = QWidget()
            row_layout = QHBoxLayout(row)
            row_layout.setContentsMargins(0, 0, 0, 0)
            name_edit = QLineEdit(f"Team {i+1}")
            color_btn = QPushButton("Pick Color")
            row_layout.addWidget(name_edit)
            row_layout.addWidget(color_btn)
            self.teams_layout.addWidget(row)


if __name__ == '__main__':
    # Create the Qt Application
    app = QApplication(sys.argv)
    # Create and show the form
    main_window = Window()
    main_window.show()
    # Run the main Qt loop
    sys.exit(app.exec())
