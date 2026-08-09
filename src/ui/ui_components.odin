package ui
import rl "vendor:raylib"
import g "../globals"
import st "core:strings"

// Screen coordenate system 
// 0 to 1 normalized space

scr_pos :: #force_inline proc(pos: [2]f32) -> [2]f32 {

    pos := pos

    pos.y = clamp(pos.y, 0.0, 1.0)
    pos.x = clamp(pos.x, 0.0, 1.0)   

    return [2]f32 {
        f32(g.window_size.x) * pos.x,
        f32(g.window_size.y) * pos.y
    }
}

norm_pos :: #force_inline proc(pos: [2]f32) -> [2]f32 {

    pos := pos

    pos.y = clamp(pos.y, 1.0, f32(g.window_size.y))
    pos.x = clamp(pos.x, 1.0, f32(g.window_size.y))   

    return [2]f32 {
        f32(g.window_size.x) / pos.x,
        f32(g.window_size.y) / pos.y
    }
}

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

center_button :: proc(title: string , width: f32, pos: [2]f32, padding: f32 = 10) -> bool {

    body := rl.Rectangle{ 
        x = pos.x,
        y = pos.y,
        width = width,
        height = g.font_size + padding
    }

    label := st.clone_to_cstring(title, context.temp_allocator)
    text_wid := rl.MeasureText(label, g.font_size)

    text_pos := [2]i32 {
        i32(body.x) + (i32(body.width) - text_wid) / 2,
        i32(body.y) + i32(padding / 2)
    }

    col1 := rl.Color{0, 0, 0, 200}
    col2 := rl.Color{255, 255, 255, 255}

    if rl.CheckCollisionPointRec(rl.GetMousePosition(), body) {

        col1 = rl.Color{50, 50, 50, 240}
        col2 = rl.BLUE
    }

    rl.DrawRectangleRounded(body, 0.75, 4, col1)
    rl.DrawRectangleRoundedLines(body, 0.75, 4, col2)
    rl.DrawText(label, text_pos.x, text_pos.y, g.font_size, col2)

    if rl.CheckCollisionPointRec(rl.GetMousePosition(), body) && rl.IsMouseButtonPressed(.LEFT) do return true
    else do return false

}
