package main

import rl "vendor:raylib"
import "core:fmt"
import e "entities"
import mat "match"
import ass "asset_man"

window_size := [2]i32{800, 800}
camera_speed :: 700
zoom_speed :: 1.0

main :: proc() {


    rl.InitWindow(window_size.x, window_size.y, "Normal Chess")
    defer rl.CloseWindow()
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})

    game := mat.make_normal_match()
    defer mat.delete_match(game)

    camera := rl.Camera2D{
        offset = {f32(window_size.x /2), f32(window_size.y /2)},
        rotation = 0.0,
        target = {0, 0},
        zoom = 2.6
    }

    dt := rl.GetFrameTime()

    board_center := [2]f32{f32(game.board.sprite.width/2), f32(game.board.sprite.height/2)}
    camera.target = board_center
    camera.zoom = f32(window_size.y) / f32(game.board.sprite.height)

    //fmt.println(board.tiles)

    game_loop: for !rl.WindowShouldClose() {

    update: {

        dt = rl.GetFrameTime()
        window_size.x = rl.GetScreenWidth()
        window_size.y = rl.GetScreenHeight()
        camera.offset = {f32(window_size.x /2), f32(window_size.y /2)}


        camera_control(&camera, dt)
        e.update(&game.board, game.pieces)
        game_control(game, camera)
        mat.update_match(game)

    }

    drawing: {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode2D(camera)

        rl.DrawTextureV(game.board.sprite, game.board.position, rl.WHITE)
        mouse_pos := rl.GetMousePosition()
        world_pos := rl.GetScreenToWorld2D(mouse_pos, camera)

        for tile in game.board.tiles {

            if rl.CheckCollisionPointRec(world_pos, tile.hitbox) {
                rl.DrawRectangleRec(tile.hitbox, rl.BLUE)
            }
        }

        if game.selected_piece != nil {
            
            pos, valid := e.board_to_world(&game.board, game.selected_piece.position)
            rl.DrawRectangleRec(rl.Rectangle{ pos.x, pos.y, e.tile_size, e.tile_size}, rl.BLUE)
        }


        for move in game.movements {

            draw_pos, in_bounds := e.board_to_world(&game.board, move.pos)
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

        for &piece in game.pieces {
            tile_pos , ok := e.board_to_world(&game.board, piece.position)
            if piece.alive {
                source := rl.Rectangle {0, 0, 32, 32}

                switch piece.class {

                case .pawn:
                case .rook:
                    source.x = 32
                    source.y = 0
                case .bishop:
                    source.x = 0
                    source.y = 32
                case .king:
                    source.x = 32 * 2
                    source.y = 32
                case .queen:
                    source.x = 32 * 2
                    source.y = 0
                case .knight:
                    source.x = 32
                    source.y = 32

                }

                rl.DrawTextureRec(piece.team.piece_sprites.texture, source , tile_pos, rl.WHITE)
            }
        }

        rl.EndMode2D()

        gui(game)
        debug_ui(game, camera)

        rl.EndDrawing()

        }

    }

    ass.clear_assets()

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

game_control :: proc(game: ^mat.Match, camera: rl.Camera2D) {

    mouse_pos := rl.GetMousePosition()
    world_pos := rl.GetScreenToWorld2D(mouse_pos, camera)

    check_click: if rl.IsMouseButtonPressed(.LEFT) {

        target_tile, in_bounds := e.world_to_board(&game.board, world_pos)
        if !in_bounds do break check_click

            if game.selected_piece == nil{

                fmt.println(target_tile)

                cur_team := mat.get_team_turn(game)

                if tile := e.get_tile(&game.board, target_tile); tile != nil && tile.piece_ref != nil {
                    game.selected_piece = tile.piece_ref
                    if cur_team == game.selected_piece.team do game.selected_piece.movement(tile.piece_ref, &game.board, &game.movements) 
                    fmt.println("open movement")
                    fmt.println(game.movements)
                }

            } else {

                for move in game.movements {
                    if move.pos == target_tile {
                        e.move(game.selected_piece, &game.board, move.pos)
                        mat.end_turn(game)
                        game.selected_piece = nil
                        clear(&game.movements)
                        break
                    }


                }
                game.selected_piece = nil
                clear(&game.movements)

            }

        }
    }

debug_ui :: proc(game: ^mat.Match, camera: rl.Camera2D) {


    mouse_pos := rl.GetMousePosition()
    world_pos := rl.GetScreenToWorld2D(mouse_pos, camera)
    rl.DrawText("Chess", 0, 0, 30, rl.YELLOW);
    rl.DrawText(fmt.caprintf("window size:\nwidth: %d\nheight:%d", window_size.x, window_size.y), 0, 30, 30, rl.YELLOW);
    rl.DrawText(fmt.caprintf("camera\nx: %.2f y: %.2f\nzoom: %.2f\nrotation: %.2f", camera.target.x, camera.target.y, camera.zoom, camera.rotation),
        0, 120, 30, rl.YELLOW);

    board_pos, in_bounds := e.world_to_board(&game.board, world_pos)
    if (in_bounds) {
        rl.DrawText(fmt.caprintf("Board cords: [%d %d]", board_pos.x, board_pos.y), 0, 250, 30, rl.YELLOW);
    }

    rl.DrawFPS(10, 300)
}

gui :: proc(game: ^mat.Match) {

    center := rl.Vector2{f32(window_size.x /2), f32(window_size.y /2)}
    font_size :: 32

    cur_team: cstring = fmt.caprintf("Turn: %s", mat.get_team_turn(game).name)
    score: cstring = fmt.caprintf("%s: %d | %s: %d", game.teams[0].name, game.teams[0].score, game.teams[1].name, game.teams[1].score)

    team_wid := rl.MeasureText(cur_team, font_size)
    score_wid := rl.MeasureText(score, font_size)

    rl.DrawText(score, i32(center.x) - score_wid /2, 0, font_size, rl.GRAY)
    rl.DrawText(cur_team, i32(center.x) - team_wid /2, window_size.y - 32, font_size, rl.GRAY)
}

