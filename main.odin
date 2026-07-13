package chess

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"
import e "entities"

window_size := [2]i32{800, 800}
camera_speed :: 700
zoom_speed :: 1.0
textures: map[string]rl.Texture2D

main :: proc() {


    rl.InitWindow(window_size.x, window_size.y, "Normal Chess")
    defer rl.CloseWindow()
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})

    load_textures(&textures)
    defer for key, texture in textures do rl.UnloadTexture(texture)

    camera := rl.Camera2D{
        offset = {f32(window_size.x /2), f32(window_size.y /2)},
        rotation = 0.0,
        target = {0, 0},
        zoom = 2.6
    }
    dt := rl.GetFrameTime()

    white := e.Team {

        color = rl.WHITE,
        name = "White",
    }

    pieces_container := make([dynamic]e.Piece)

    for i in 0..<8 {
        append(&pieces_container, e.make_pawn(&textures, {i32(i), 6}, &white))
    }
        append(&pieces_container, e.make_pawn(&textures, {3, 4}, &white))
        append(&pieces_container, e.make_pawn(&textures, {5, 5}, &white))
    board := e.make_board(col1 = rl.Color{181, 136, 99, 255}, col2 = rl.Color{240, 217, 181 , 255})
    defer e.delete_board(&board)

    board_center := [2]f32{f32(board.sprite.width/2), f32(board.sprite.height/2)}
    camera.target = board_center
    camera.zoom = f32(window_size.y) / f32(board.sprite.height)

    //fmt.println(board.tiles)
    movements: [dynamic]e.Move
    defer delete(movements)

    selected_piece: ^e.Piece

    game_loop: for !rl.WindowShouldClose() {

        dt = rl.GetFrameTime()
        window_size.x = rl.GetScreenWidth()
        window_size.y = rl.GetScreenHeight()
        camera.offset = {f32(window_size.x /2), f32(window_size.y /2)}

        //clear(&movements)

        camera_control(&camera, dt)

        e.update(&board, pieces_container[:])

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode2D(camera)

        rl.DrawTextureV(board.sprite, board.position, rl.WHITE)
        mouse_pos := rl.GetMousePosition()
        world_pos := rl.GetScreenToWorld2D(mouse_pos, camera)

        check_click: if rl.IsMouseButtonPressed(.LEFT) {

            target_tile, in_bounds := e.world_to_board(&board, world_pos)
            if !in_bounds do break check_click

                if selected_piece == nil{

                    fmt.println(target_tile)

                    if tile := e.get_tile(&board, target_tile); tile != nil && tile.piece_ref != nil{
                        selected_piece = tile.piece_ref
                        selected_piece.movement(tile.piece_ref, &board, &movements) 
                        fmt.println("open movement")
                        fmt.println(movements)
                    }
                } else {
                    for move in movements {
                        if move.pos == target_tile {
                            e.move(selected_piece, &board, move.pos)
                            selected_piece = nil
                            clear(&movements)
                            break
                        }


                    }
                    selected_piece = nil
                    clear(&movements)

                }

            }


            for tile in board.tiles {

                if rl.CheckCollisionPointRec(world_pos, tile.hitbox) {
                    rl.DrawRectangleRec(tile.hitbox, rl.BLUE)
                }
            }

            for move in movements {

                draw_pos, in_bounds := e.board_to_world(&board, move.pos)
                if !in_bounds do continue
                    color := rl.RED if move.attack else rl.BLUE

                    rec := rl.Rectangle {
                        x = draw_pos.x,
                        y = draw_pos.y,
                        width = e.tile_size,
                        height = e.tile_size
                    }

                    rl.DrawRectangleLinesEx(rec, 2.0, color)
            }
            for &piece in pieces_container {
                tile_pos , ok := e.board_to_world(&board, piece.position)
                if piece.alive {
                    rl.DrawTextureEx(piece.sprite, tile_pos, 0.0, 1.0, piece.team.color)
                }
            }

            rl.EndMode2D()

            rl.DrawText("Chess", 0, 0, 30, rl.YELLOW);
            rl.DrawText(fmt.caprintf("window size:\nwidth: %d\nheight:%d", window_size.x, window_size.y), 0, 30, 30, rl.YELLOW);
            rl.DrawText(fmt.caprintf("camera\nx: %.2f y: %.2f\nzoom: %.2f\nrotation: %.2f", camera.target.x, camera.target.y, camera.zoom, camera.rotation),
                0, 120, 30, rl.YELLOW);

            board_pos, in_bounds := e.world_to_board(&board, world_pos)
            if (in_bounds) {
                rl.DrawText(fmt.caprintf("Board cords: [%d %d]", board_pos.x, board_pos.y), 0, 250, 30, rl.YELLOW);
            }


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

load_textures :: proc(textures: ^map[string]rl.Texture2D) {

    appdir : [dynamic]u8
    defer delete(appdir)

    append_string(&appdir, string(rl.GetApplicationDirectory()), "/assets/white_pawn.png")
    path := strings.clone_to_cstring(string(appdir[:]))

    textures["pawn"] = rl.LoadTexture(path)

}
