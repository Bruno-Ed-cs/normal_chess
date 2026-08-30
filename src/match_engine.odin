package main

import rl "vendor:raylib"
import gm "game"
import ass "asset_man"
import ui "ui"
import g "globals"
import "core:log"


match_engine_run :: proc(game: ^gm.Match) {

    //fmt.println(game.pieces)
    interfaces := ui.ui_stack_make()
    defer ui.ui_stack_delete(interfaces)

    camera := rl.Camera2D{
        offset = {f32(g.WINDOW_SIZE.x /2), f32(g.WINDOW_SIZE.y /2)},
        rotation = 0.0,
        target = {0, 0},
        zoom = 2.6
    }

    dt := rl.GetFrameTime()

    board_center := [2]f32{f32(game.board.sprite.width/2), f32(game.board.sprite.height/2)}
    camera.target = board_center
    camera.zoom = f32(g.WINDOW_SIZE.y) / f32(game.board.sprite.height)

    debug_id: int
    ui.ui_stack_push_ui(interfaces, ui.match_ui(game))
    // ui.push_ui(interfaces, ui.promotion_ui(game, 1))
    promotion_ui := 0

    game_loop: for !rl.WindowShouldClose() {

        free_all(context.temp_allocator)

        rl.SetMouseCursor(.DEFAULT)

        if rl.IsKeyReleased(.F3) {

            if !ui.ui_stack_is_interface_active(interfaces, debug_id) {
                debug_id = ui.ui_stack_push_ui(interfaces, ui.ui_debug(game, &camera))
            } else {
                ui.ui_stack_remove_ui(interfaces, debug_id) 
            }
        }

        if rl.IsKeyReleased(.P) {
            g.PAUSE = !g.PAUSE
        }

        update: {

            dt = rl.GetFrameTime()
            g.WINDOW_SIZE.x = rl.GetScreenWidth()
            g.WINDOW_SIZE.y = rl.GetScreenHeight()
            camera.offset = {f32(g.WINDOW_SIZE.x /2), f32(g.WINDOW_SIZE.y /2)}
            zoom_factor := (f32(g.WINDOW_SIZE.y) / f32(game.board.size.y * gm.TILE_SIZE))
            camera.zoom = zoom_factor - zoom_factor * 0.02

            // log.debug(game.teams)
            //its already fucked here

            match_engine_camera_control(&camera, dt)
            if !g.PAUSE do match_engine_gameplay_control(game, camera)
            gm.board_update(&game.board, game.pieces[:])
            gm.match_update(game)


            for &piece in game.pieces {

                if ui.ui_stack_is_interface_active(interfaces, promotion_ui) do break

                if piece.class == .pawn {

                    if piece.team.march_direction.x != 0 {
                        if piece.team.march_direction.x == 1 {
                            if piece.position.x == game.board.size.x -1 do promotion_ui = ui.ui_stack_push_ui(interfaces, ui.ui_promotion(game, piece.id))
                        }

                        if piece.team.march_direction.x == -1 {
                            if piece.position.x == 0 do promotion_ui = ui.ui_stack_push_ui(interfaces, ui.ui_promotion(game, piece.id))
                        }
                    }

                    if piece.team.march_direction.y != 0 {

                        if piece.team.march_direction.y == 1 {
                            if piece.position.y == game.board.size.y -1 do promotion_ui = ui.ui_stack_push_ui(interfaces, ui.ui_promotion(game, piece.id))
                        }

                        if piece.team.march_direction.y == -1 {
                            if piece.position.y == 0 do promotion_ui = ui.ui_stack_push_ui(interfaces, ui.ui_promotion(game, piece.id))
                        }
                    }
                }

            }

            // if rl.IsKeyReleased(.SPACE) {
            //     for &piece in game.pieces {
            //         if piece.class == gm.Class.pawn do gm.promote(&piece, .queen)
            //     }
            //
            // }

        }

        drawing: {
            rl.BeginDrawing()
            rl.ClearBackground(rl.BLACK)
            rl.BeginMode2D(camera)

            rl.DrawTextureV(game.board.sprite, game.board.position, rl.WHITE)
            mouse_pos := rl.GetMousePosition()
            world_pos := rl.GetScreenToWorld2D(mouse_pos, camera)

            // for tile in game.board.tiles {
            //
            //     if rl.CheckCollisionPointRec(world_pos, tile.hitbox) {
            //         rl.DrawRectangleRec(tile.hitbox, rl.BLUE)
            //     }
            // }

            if game.selected_piece != nil {

                pos, valid := gm.board_to_world(&game.board, game.selected_piece.position)
                rl.DrawRectangleRec(rl.Rectangle{ pos.x, pos.y, gm.TILE_SIZE, gm.TILE_SIZE}, rl.BLUE)
            }


            for move in game.movements {

                draw_pos, in_bounds := gm.board_to_world(&game.board, move.target)
                if !in_bounds do continue
                    color: rl.Color = rl.BLUE

                    if move.attack do color = rl.RED
                    if move.side_effect != nil do color = rl.GREEN

                    rec := rl.Rectangle {
                        x = draw_pos.x,
                        y = draw_pos.y,
                        width = gm.TILE_SIZE,
                        height = gm.TILE_SIZE
                    }

                    rl.DrawRectangleLinesEx(rec, 2.0, color)
            }

            for &piece in game.pieces {
                tile_pos , ok := gm.board_to_world(&game.board, piece.position)
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

            ui.ui_stack_execute(interfaces)

            rl.EndDrawing()

        }

    }

    ass.asset_man_clear()
}

match_engine_camera_control :: proc(camera: ^rl.Camera2D, dt: f32) {

    if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyDown(.EQUAL) {
        camera.zoom += g.ZOOM_SPEED * dt
    }

    if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyDown(.MINUS) {
        camera.zoom -= g.ZOOM_SPEED * dt

    }

    if rl.IsKeyDown(.DOWN) {
        camera.target.y += g.CAMERA_SPEED * dt
    }

    if rl.IsKeyDown(.UP) {
        camera.target.y -= g.CAMERA_SPEED * dt
    }

    if rl.IsKeyDown(.LEFT) {
        camera.target.x -= g.CAMERA_SPEED * dt
    }

    if rl.IsKeyDown(.RIGHT) {
        camera.target.x += g.CAMERA_SPEED * dt
    }

}

match_engine_gameplay_control :: proc(game: ^gm.Match, camera: rl.Camera2D) {

    mouse_pos := rl.GetMousePosition()
    world_pos := rl.GetScreenToWorld2D(mouse_pos, camera)

    hovering, in_bounds := gm.world_to_board(&game.board, world_pos)

    if in_bounds{
        tile := gm.board_get_tile(&game.board, hovering)
        if tile != nil && tile.piece_ref != nil {

            if tile.piece_ref.team == gm.match_get_cur_turn_team(game) do rl.SetMouseCursor(.POINTING_HAND)
        }

        for move in game.movements {
            if move.target == tile.coordenate do rl.SetMouseCursor(.POINTING_HAND)
        }

    } 
    // fmt.println(in_bounds)

    check_click: if rl.IsMouseButtonPressed(.LEFT) {

        target_tile, in_bounds := gm.world_to_board(&game.board, world_pos)
        if !in_bounds do break check_click

            if game.selected_piece == nil{

                // fmt.println(target_tile)

                cur_team := gm.match_get_cur_turn_team(game)

                if tile := gm.board_get_tile(&game.board, target_tile); tile != nil && tile.piece_ref != nil {
                    if cur_team == tile.piece_ref.team { 
                        game.selected_piece = tile.piece_ref
                        game.selected_piece.movement(tile.piece_ref, &game.board, &game.movements) 
                        // fmt.println("open movement")
                        // fmt.println(game.movements)
                    }
                }

            } else {

                for move in game.movements {
                    if move.target == target_tile {
                        gm.piece_move(game.selected_piece, &game.board, move.target)
                        
                        if move.side_effect != nil {
                            move.side_effect(game, game.selected_piece.id)
                        }
                        gm.match_end_turn(game)
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



