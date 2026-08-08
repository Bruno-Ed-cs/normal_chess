package ui
import rl "vendor:raylib"

LongTriangle :: struct {
    triangle: [3]rl.Vector2,
    end: rl.Vector2
}

draw_long_triangle :: proc(shape: LongTriangle, color: rl.Color, outline: rl.Color = rl.BLANK, thickness: f32 = 1.0) {

    rect := rl.Rectangle{
       x = shape.triangle[0].x,
       y = shape.triangle[0].y,
       height = rl.Vector2Distance(shape.triangle[0], shape.triangle[1]),
       width = rl.Vector2Distance(shape.triangle[0], shape.end)
    }

    shape := shape
    rl.DrawTriangle(
        shape.triangle[0], 
        shape.triangle[1], 
        shape.triangle[2], 
        color );

    rl.DrawRectangleRec(rect, color)
}
