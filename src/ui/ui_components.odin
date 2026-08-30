package ui
import rl "vendor:raylib"
import g "../globals"
import str "core:strings"

// Screen coordenate system 
// 0 to 1 normalized space

Justification :: enum {
    center,
    left,
    right
}

scr_pos :: #force_inline proc(pos: [2]f32) -> [2]f32 {

    pos := pos

    pos.y = clamp(pos.y, 0.0, 1.0)
    pos.x = clamp(pos.x, 0.0, 1.0)   

    return [2]f32 {
        f32(g.WINDOW_SIZE.x) * pos.x,
        f32(g.WINDOW_SIZE.y) * pos.y
    }
}

norm_pos :: #force_inline proc(pos: [2]f32) -> [2]f32 {

    pos := pos

    pos.y = clamp(pos.y, 1.0, f32(g.WINDOW_SIZE.y))
    pos.x = clamp(pos.x, 1.0, f32(g.WINDOW_SIZE.y))   

    return [2]f32 {
        f32(g.WINDOW_SIZE.x) / pos.x,
        f32(g.WINDOW_SIZE.y) / pos.y
    }
}

Long_Triangle :: struct {
    triangle: [3]rl.Vector2,
    end: rl.Vector2
}

long_triangle_draw :: proc(shape: Long_Triangle, color: rl.Color, outline: rl.Color = rl.BLANK, thickness: f32 = 1.0) {

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



component_simple_button :: proc(title: string , width: f32, pos: [2]f32, padding: f32 = 10, justify: Justification = .center) -> bool {

    body := rl.Rectangle{ 
        x = pos.x,
        y = pos.y,
        width = width,
        height = g.FONT_SIZE + padding
    }

    label := str.clone_to_cstring(title, context.temp_allocator)
    text_wid := rl.MeasureText(label, g.FONT_SIZE)

    text_pos :[2]i32 

    switch justify {
        case .center:
            text_pos = [2]i32 {
                i32(body.x) + (i32(body.width) - text_wid) / 2,
                i32(body.y) + i32(padding / 2)
            }
        case .left:

            text_pos = [2]i32 {
                i32(body.x + padding),
                i32(body.y) + i32(padding / 2)
            }
        case .right:

            text_pos = [2]i32 {
                i32(body.x) + (i32(body.width) - text_wid) - i32(padding),
                i32(body.y) + i32(padding / 2)
            }
    }

    col1 := g.BACKGROUND_COLOR
    col2 := g.TEXT_COLOR

    if rl.CheckCollisionPointRec(rl.GetMousePosition(), body) {

        col1 = g.BACKGROUND_HOVER
        col2 = g.TEXT_HOVER
        rl.SetMouseCursor(.POINTING_HAND)
    }

    rl.DrawRectangleRounded(body, g.ROUNDNESS, g.SEGMENTS, col1)
    rl.DrawRectangleRoundedLines(body, g.ROUNDNESS, g.SEGMENTS, col2)
    rl.DrawText(label, text_pos.x, text_pos.y, g.FONT_SIZE, col2)

    if rl.CheckCollisionPointRec(rl.GetMousePosition(), body) && rl.IsMouseButtonPressed(.LEFT) do return true
    else do return false

}
