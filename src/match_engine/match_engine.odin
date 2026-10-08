package match_engine

import "core:reflect"
import rl "vendor:raylib"
import "core:os"
import eng "../match_engine"
import "core:math/linalg"
import "core:fmt"
import gm "../game"
import ass "../asset_man"
import ui "../ui"
import g "../globals"
import "core:log"

App_State :: enum {
    Gameplay,
    Main_Menu,
}

State :: struct {
    app_state: App_State,
    promotion_ui: int,
    debug_id: int,
    game: ^gm.Match,
    camera: rl.Camera2D,
    team_painter: rl.Shader,
    uniforms: map[string]i32,
    gameplay_ui: ui.UiStack,
    main_menu_ui: ui.UiStack,
}

@(export)
match_engine_make :: proc(path: string) -> ^State {

    state := new(State)

    uis := transmute([]i32)reflect.enum_field_values(Ui_Type)

    state^ = State {

        app_state = .Main_Menu,
        game = gm.match_make_from_file(path),
        gameplay_ui = ui.ui_stack_make(uis[:], ui_render),
        main_menu_ui = ui.ui_stack_make(uis[:], ui_render),

        camera = rl.Camera2D{
            offset = {f32(g.WINDOW_SIZE.x /2), f32(g.WINDOW_SIZE.y /2)},
            rotation = 0.0,
            target = {0, 0},
            zoom = 2.6
        }
    }

    board_center := [2]f32{f32(state.game.board.sprite.width/2), f32(state.game.board.sprite.height/2)}
    state.camera.target = board_center
    state.camera.zoom = f32(g.WINDOW_SIZE.y) / f32(state.game.board.sprite.height)

    ui.ui_stack_push_ui(&state.gameplay_ui, ui_match_init(state.game))
    // ui.push_ui(interfaces, ui.promotion_ui(game, 1))
    state.promotion_ui = 0

    if state.game == nil do os.exit(0)

    ass.asset_man_init()

    state.team_painter = rl.LoadShader(nil, "./assets/shaders/team_painter.vert")
    state.uniforms["team_col"] = rl.GetShaderLocation(state.team_painter, "team_col")
    if state.uniforms["team_col"] < 0 do log.error("Uniform \"team_col\" was not found")

    if !rl.IsShaderValid(state.team_painter) {
        log.error("Invalid Shader")
    }

    rl.SetTraceLogLevel(.ALL)
    return state
}

match_engine_reload_shaders :: proc(st: ^State) {

    if rl.IsShaderValid(st.team_painter) do rl.UnloadShader(st.team_painter)

    st.team_painter = rl.LoadShader(nil, "./assets/shaders/team_painter.vert")
    st.uniforms["team_col"] = rl.GetShaderLocation(st.team_painter, "team_col")
    if st.uniforms["team_col"] < 0 do log.error("Uniform \"team_col\" was not found")

    if !rl.IsShaderValid(st.team_painter) {
        log.error("Invalid Shader")
    }

}

@(export)
match_engine_init_window :: proc() {

    rl.InitWindow(g.WINDOW_SIZE.x, g.WINDOW_SIZE.y, "Normal Chess")
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})
    rl.SetTargetFPS(60)

}

@(export)
match_engine_close_window :: proc() {

    rl.CloseWindow()
}

@export
match_engine_cleanup :: proc(st: ^State) {

    uis := transmute([]i32)reflect.enum_field_values(Ui_Type)


    clear(&st.gameplay_ui.types)
    clear(&st.main_menu_ui.types)

    for type in uis {
        append(&st.gameplay_ui.types, type)
        append(&st.main_menu_ui.types, type)
    }

    st.gameplay_ui.ui_render = ui_render
    st.main_menu_ui.ui_render = ui_render

    ass.asset_man_clear()

}

@(export)
match_engine_delete :: proc(st: ^State) {

    if rl.IsShaderValid(st.team_painter) do rl.UnloadShader(st.team_painter)
    ui.ui_stack_delete(&st.gameplay_ui)
    ui.ui_stack_delete(&st.main_menu_ui)
    gm.match_delete(st.game)

    ui.ui_stack_delete(&st.main_menu_ui)
    ui.ui_stack_delete(&st.gameplay_ui)

    delete(st.uniforms)
    free(st)
}

@(export)
match_engine_run :: proc(st: ^State) {

    //fmt.println(st.game.pieces)
    if (rl.WindowShouldClose()) {
        g.RUNNING = false
        return
    } else {

        g.RUNNING = true

    }
    g.WINDOW_SIZE.x = rl.GetScreenWidth()
    g.WINDOW_SIZE.y = rl.GetScreenHeight()

    dt := rl.GetFrameTime()

    // log.debug(dt)
    free_all(context.temp_allocator)

    rl.SetMouseCursor(.DEFAULT)

    if rl.IsKeyReleased(.F3) {

        if !ui.ui_stack_is_interface_active(&st.gameplay_ui, st.debug_id) {
            st.debug_id = ui.ui_stack_push_ui(&st.gameplay_ui, ui_debug_init(st.game, &st.camera))

        } else {
            ui.ui_stack_remove_ui(&st.gameplay_ui, st.debug_id) 
        }
    }

    if rl.IsKeyReleased(.P) {
        g.PAUSE = !g.PAUSE
    }

    switch st.app_state {

    case .Gameplay: {

        match_engine_gameplay_update(st)
    }

    case .Main_Menu: {

        match_engine_main_menu_update(st)
    }

    } //switch

}

match_engine_main_menu_update :: proc(st:^State) {

    if !ui.ui_stack_is_type_active(&st.main_menu_ui, i32(Ui_Type.main_menu)) {

        ui.ui_stack_push_ui(&st.main_menu_ui, ui_main_menu_init(st))

    }

    rl.BeginDrawing()

    rl.ClearBackground(rl.BLACK)

    ui.ui_stack_execute(&st.main_menu_ui)

    rl.EndDrawing()

}

match_engine_gameplay_update :: proc(st: ^State) {

        dt := rl.GetFrameTime()
        st.camera.offset = {f32(g.WINDOW_SIZE.x /2), f32(g.WINDOW_SIZE.y /2)}
        zoom_factor := (f32(g.WINDOW_SIZE.y) / f32(st.game.board.size.y * gm.TILE_SIZE))
        st.camera.zoom = zoom_factor - zoom_factor * 0.02

        // log.debug(st.game.teams)
        //its already fucked here

        match_engine_camera_control(&st.camera, dt)
        if !g.PAUSE do match_engine_gameplay_control(st)
            gm.board_update(&st.game.board, st.game.pieces[:])
            gm.match_update(st.game)


            for &piece in st.game.pieces {

                if ui.ui_stack_is_interface_active(&st.gameplay_ui, st.promotion_ui) do break

                    if piece.class == .pawn {

                        promotion_fronteir := piece.team.march_direction * (st.game.board.size - 1)

                        // log.info("Fronteir: ", promotion_fronteir)

                        if promotion_fronteir.x != 0 {

                            col := promotion_fronteir.y if promotion_fronteir.y > 0 else 0
                            // log.info("Col: ", col)

                            if piece.position.x == col{
                                st.promotion_ui = ui.ui_stack_push_ui(&st.gameplay_ui, ui_promotion_init(st.game, piece.id))
                            }

                        }

                        if promotion_fronteir.y != 0 {

                            row := promotion_fronteir.y if promotion_fronteir.y > 0 else 0
                            // log.info("Row: ", row)
                            if piece.position.y == row{
                                st.promotion_ui = ui.ui_stack_push_ui(&st.gameplay_ui, ui_promotion_init(st.game, piece.id))
                            }

                        }

                    }

                }

                match_engine_draw(st)


}

match_engine_draw :: proc(st: ^State) {

    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)
    rl.BeginMode2D(st.camera)

    rl.DrawTextureV(st.game.board.sprite, st.game.board.position, rl.WHITE)
    mouse_pos := rl.GetMousePosition()
    world_pos := rl.GetScreenToWorld2D(mouse_pos, st.camera)

    // for tile in st.game.board.tiles {
    //
    //     if rl.CheckCollisionPointRec(world_pos, tile.hitbox) {
    //         rl.DrawRectangleRec(tile.hitbox, rl.BLUE)
    //     }
    // }

    if st.game.selected_piece != nil {

        pos, valid := gm.board_to_world(&st.game.board, st.game.selected_piece.position)
        rl.DrawRectangleRec(rl.Rectangle{ pos.x, pos.y, gm.TILE_SIZE, gm.TILE_SIZE}, rl.BLUE)
    }


    for move in st.game.movements {

        draw_pos, in_bounds := gm.board_to_world(&st.game.board, move.target)
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

    pieces_sprite := ass.asset_man_get_asset("sprite_sheet.png").(rl.Texture2D)
    // if st.team_painter.id == 0 do log.error("The shader was not loaded")

    for &piece in st.game.pieces {
        tile_pos , ok := gm.board_to_world(&st.game.board, piece.position)
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

            norm_col := rl.ColorNormalize(piece.team.color)

            rl.SetShaderValue(st.team_painter, st.uniforms["team_col"], &norm_col, .VEC4)

            rl.BeginShaderMode(st.team_painter)
                rl.DrawTextureRec(pieces_sprite, source, tile_pos, rl.WHITE)
            rl.EndShaderMode()
        }
    }

    rl.EndMode2D()

    ui.ui_stack_execute(&st.gameplay_ui)

    rl.EndDrawing()


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

match_engine_gameplay_control :: proc(st: ^State) {

    mouse_pos := rl.GetMousePosition()
    world_pos := rl.GetScreenToWorld2D(mouse_pos, st.camera)

    // fmt.println(in_bounds)

    if rl.IsKeyReleased(.F2) {
        match_engine_reload_shaders(st)

    }

    if rl.IsKeyReleased(.U) {
        gm.match_undo_move(st.game)

    }

    if rl.IsKeyReleased(.H) {
        for move in st.game.history do log.info(move)
    }

    if rl.IsKeyReleased(.R) {
        gm.match_reset(st.game)

    }

    check_click: if rl.IsMouseButtonPressed(.LEFT) {

        target_tile, in_bounds := gm.world_to_board(&st.game.board, world_pos)
        if !in_bounds do break check_click 

            if st.game.selected_piece == nil{

                // fmt.println(target_tile)

                cur_team := gm.match_get_cur_turn_team(st.game)

                if tile := gm.board_get_tile(&st.game.board, target_tile); tile != nil && tile.piece_ref != nil {
                    if cur_team == tile.piece_ref.team { 
                        st.game.selected_piece = tile.piece_ref
                        gm.piece_movement(tile.piece_ref, st.game) 
                        // fmt.println("open movement")
                        // fmt.println(st.game.movements)
                    }
                }

            } else {

                for move in st.game.movements {
                    if move.target == target_tile {
                        gm.piece_move(st.game.selected_piece, st.game, move)
                        gm.match_end_turn(st.game)
                        st.game.selected_piece = nil
                        clear(&st.game.movements)
                        break
                    }


                }
                st.game.selected_piece = nil
                clear(&st.game.movements)

            }

        }
    }
