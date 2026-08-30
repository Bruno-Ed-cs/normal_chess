package globals
import rl "vendor:raylib"
import "core:log"

LOG_LEVEL := log.Level.Fatal

WINDOW_SIZE := [2]i32{1200, 800}
CAMERA_SPEED :: 700
ZOOM_SPEED :: 1.0
PAUSE: bool = false

UI_MEM_SIZE :: 50000

MAX_PIECES :: 1000
MAX_MOVES :: 10000

FONT_SIZE :: 32
ROUNDNESS :: 0.16
SEGMENTS :: 2
BACKGROUND_COLOR :: rl.Color{10, 10, 10, 200}
TEXT_COLOR:: rl.WHITE
BACKGROUND_HOVER:: rl.Color{100, 100, 100, 255}
TEXT_HOVER:: rl.YELLOW

