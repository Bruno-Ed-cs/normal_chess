package helpers

import rl "vendor:raylib"

invert_color :: #force_inline proc(color: rl.Color) -> rl.Color {

    return rl.Color{
       255 - color.r,
       255 - color.g,
       255 - color.b,
       color.a,
    }
}
