package globals
import rl "vendor:raylib"

window_size := [2]i32{1200, 800}
camera_speed :: 700
zoom_speed :: 1.0
pause: bool = false

font_size :: 32
roundness :: 0.16
segments :: 2
background_color :: rl.Color{10, 10, 10, 200}
text_color:: rl.WHITE
background_hover:: rl.Color{100, 100, 100, 255}
text_hover:: rl.YELLOW

