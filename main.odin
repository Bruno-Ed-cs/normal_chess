package chess

import rl "vendor:raylib"
import "core:fmt"
import e "entities"

window_size := [2]i32{800, 800}
camera_speed :: 700
zoom_speed :: 1.0

main :: proc() {

    rl.InitWindow(window_size.x, window_size.y, "Normal Chess")
    defer rl.CloseWindow()
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})

    camera := rl.Camera2D{
        offset = {f32(window_size.x /2), f32(window_size.y /2)},
        rotation = 0.0,
        target = {0, 0},
        zoom = 2.6
    }
    dt := rl.GetFrameTime()

    board := e.make_board(col1 = rl.Color{181, 136, 99, 255}, col2 = rl.Color{240, 217, 181 , 255})
    defer e.delete_board(&board)

    board_center := [2]f32{f32(board.sprite.width/2), f32(board.sprite.height/2)}
    camera.target = board_center
    camera.zoom = f32(window_size.y) / f32(board.sprite.height)

    for !rl.WindowShouldClose() {

        dt = rl.GetFrameTime()
        window_size.x = rl.GetScreenWidth()
        window_size.y = rl.GetScreenHeight()
        camera.offset = {f32(window_size.x /2), f32(window_size.y /2)}

        camera_control(&camera, dt)

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode2D(camera)

        rl.DrawTextureV(board.sprite, board.position, rl.WHITE)

        rl.EndMode2D()

        rl.DrawText("Chess", 0, 0, 30, rl.YELLOW);
        rl.DrawText(fmt.caprintf("window size:\nwidth: %d\nheight:%d", window_size.x, window_size.y), 0, 30, 30, rl.YELLOW);
        rl.DrawText(fmt.caprintf("camera\nx: %.2f y: %.2f\nzoom: %.2f\nrotation: %.2f", camera.target.x, camera.target.y, camera.zoom, camera.rotation),
            0, 120, 30, rl.YELLOW);

        rl.EndDrawing()

    }

}

camera_control :: proc(camera: ^rl.Camera2D, dt: f32) {

        if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyDown(.EQUAL) {
            camera.zoom += zoom_speed * dt
        }

        if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyDown(.MINUS) {
            camera.zoom -= zoom_speed * dt

        }

        if rl.IsKeyDown(.DOWN) {
            camera.target.y += camera_speed * dt
        }

        if rl.IsKeyDown(.UP) {
            camera.target.y -= camera_speed * dt
        }

        if rl.IsKeyDown(.LEFT) {
            camera.target.x -= camera_speed * dt
        }

        if rl.IsKeyDown(.RIGHT) {
            camera.target.x += camera_speed * dt
        }

}
