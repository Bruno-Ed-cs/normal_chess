#+feature using-stmt
package match_engine

import "../ui"
import "core:fmt"
import "core:log"
import "core:mem/virtual"
import g "../globals"
import gm "../game"
import hl "../helpers"
import rf "core:reflect"
import rl "vendor:raylib"
import str "core:strings"

Ui_Type :: enum(i32){

    debug = 1,
    match,
    promotion, 
    main_menu,
    pause,
}

ui_render :: proc(interface: ^ui.Ui, top: bool) -> ui.UiSig {

    implementation : proc(workspace: rawptr, top: bool) -> ui.UiSig 

    switch Ui_Type(interface.type) {

    case .pause: implementation = ui_pause_call
    case .debug: implementation = ui_debug_call
    case .match: implementation = ui_match_call
    case .promotion: implementation = ui_promotion_call
    case .main_menu: implementation = ui_main_menu_call

    }

    return implementation(interface.workspace, top)
}


Debug_Info :: struct {
    game: ^gm.Match,
    camera: ^rl.Camera2D

}

ui_debug_call :: proc(workspace: rawptr, top: bool) -> ui.UiSig {

    info := cast(^Debug_Info)workspace

    mouse_pos := rl.GetMousePosition()
    world_pos := rl.GetScreenToWorld2D(mouse_pos, info.camera^)
    rl.DrawText("Chess", 0, 0, 30, rl.YELLOW);
    rl.DrawText(fmt.caprintf("window size:\nwidth: %d\nheight:%d", g.WINDOW_SIZE.x, g.WINDOW_SIZE.y, allocator = context.temp_allocator),
        0, 30, 30, rl.YELLOW);
    rl.DrawText(
        fmt.caprintf("camera\nx: %.2f y: %.2f\nzoom: %.2f\nrotation: %.2f",
            info.camera.target.x, info.camera.target.y, info.camera.zoom, info.camera.rotation, allocator = context.temp_allocator),
        0, 120, 30, rl.YELLOW);

    board_pos, in_bounds := gm.world_to_board(&info.game.board, world_pos)
    if (in_bounds) {
        rl.DrawText(fmt.caprintf("Board cords: [%d %d]", board_pos.x, board_pos.y, allocator = context.temp_allocator),
            0, 250, 30, rl.YELLOW);
    }

    rl.DrawFPS(10, 300)

    return ui.UiSig.move_down
}

// ui_debug_cleanup :: proc(workspace: rawptr) {
//     log.debug("freeing my debug")
//     free(workspace)
//
// }

ui_debug_init :: proc(game: ^gm.Match, camera: ^rl.Camera2D) -> ui.Ui {

    memory: virtual.Arena
    err := virtual.arena_init_growing(&memory)
    assert(err == nil)
    alloc := virtual.arena_allocator(&memory)

    info := new(Debug_Info, alloc)
    info.camera = camera
    info.game = game

    return ui.Ui {
        workspace = info,
        type = i32(Ui_Type.debug),
        memory = memory
    }

}


ui_match_call :: proc(workspace: rawptr, top: bool) -> ui.UiSig {

    game := cast(^gm.Match)workspace
    // log.debug("teams: ", game.teams)

    center := rl.Vector2{f32(g.WINDOW_SIZE.x /2), f32(g.WINDOW_SIZE.y /2)}

    cur_team: cstring = fmt.ctprintf("Turn: {}", gm.match_get_cur_turn_team(game).name)

    scores := make([dynamic]cstring, context.temp_allocator)
    defer delete(scores)
    reserve(&scores, len(game.teams))

    for team in game.teams {

        append(&scores, fmt.ctprintf("%s: %d", team.name, team.score))
    }


    anchor := ui.scr_pos({
        0.98,
        0.02
    })

            score_hei :f32 = anchor.y + g.FONT_SIZE + 20
            largest_wid: i32
            for score in scores {

                score_wid := rl.MeasureText(score, g.FONT_SIZE)
                largest_wid = score_wid if score_wid > largest_wid else largest_wid
            }

            score_backdrop := rl.Rectangle{
                x = f32(i32(anchor.x) - largest_wid - 10),
                y = f32(score_hei - 5),
                width = f32(largest_wid + 20),
                height = f32(g.FONT_SIZE * len(scores) + (5 * len(scores)))
            }
            col := rl.Color{ 11, 11, 11, 120 }

            rl.DrawRectangleRounded(score_backdrop, g.ROUNDNESS, g.SEGMENTS, col)
            rl.DrawRectangleRoundedLines(score_backdrop, g.ROUNDNESS, g.SEGMENTS, g.TEXT_COLOR)

            for score in scores {
                score_wid := rl.MeasureText(score, g.FONT_SIZE)
                rl.DrawText(score,
                    i32(anchor.x) - score_wid,
                    i32(score_hei),
                    g.FONT_SIZE, rl.WHITE)

                score_hei += g.FONT_SIZE + 5
            }


            team_wid := rl.MeasureText(cur_team, g.FONT_SIZE)
            team_color := gm.match_get_cur_turn_team(game).color

            oposite_color := hl.invert_color(team_color)
            oposite_color.a = 210

            text_pos := [2]f32{
                anchor.x - f32(team_wid),
                anchor.y,
            }

            backdrop := rl.Rectangle {
                width = f32(team_wid + 20),
                height = f32(g.FONT_SIZE + 10),
                x = f32(text_pos.x - 10),
                y = f32(text_pos.y - 5)

            }

            rl.DrawRectangleRounded(backdrop, g.ROUNDNESS, g.SEGMENTS, team_color)
            rl.DrawRectangleRoundedLines(backdrop, g.ROUNDNESS, g.SEGMENTS, oposite_color)
            rl.DrawText(cur_team, 
                i32(text_pos.x),
                i32(text_pos.y),
                g.FONT_SIZE, oposite_color)

            // fmt.println(team_color, oposite_color)


            return ui.UiSig.ok
}

ui_match_init :: proc(match: ^gm.Match) -> ui.Ui {

    return ui.Ui {
        workspace = match,
        type = i32(Ui_Type.match)
    }

}

Promotion_Work :: struct {
    game: ^gm.Match,
    piece_id: i32

}

ui_promotion_call ::proc(workspace: rawptr, top: bool) -> ui.UiSig{

    work := cast(^Promotion_Work)workspace
    g.PAUSE = true

    width :f32 = 240.0
    margin :f32 = 10.0
    padding :f32 = 10.0

    anchor := ui.scr_pos({0.5, 0.5})
    anchor.x -= 240 / 2
    anchor.y -= ((len(gm.Class) - 2) * f32(g.FONT_SIZE + padding + margin)) / 2

    box_title := g.FONT_SIZE * 2 + margin * 2 + padding 
    box := rl.Rectangle{
        width = width + padding + margin,
        height = (g.FONT_SIZE + padding + margin) * (len(gm.Class) - 2) + box_title,
        x = anchor.x - margin - padding/2,
        y = anchor.y - box_title

    }

    box_text: cstring = "Promotion!"
    box_text_wid := rl.MeasureText(box_text, g.FONT_SIZE)
    box_text_pos := [2]f32{
        box.x + (box.width - f32(box_text_wid)) / 2,
        box.y + margin + padding + g.FONT_SIZE/4
    }

    promotion: gm.Class
    pressed := false
    piece := gm.match_get_piece(work.game, work.piece_id) 
    if piece == nil do return .pop

        rl.DrawRectangleRounded(box, g.ROUNDNESS, g.SEGMENTS, g.BACKGROUND_COLOR)
        rl.DrawRectangleRoundedLines(box, g.ROUNDNESS, g.SEGMENTS, g.TEXT_COLOR)
        rl.DrawText(box_text, i32(box_text_pos.x), i32(box_text_pos.y), g.FONT_SIZE, g.TEXT_COLOR)

        ui.grid_begin(anchor, {width, g.FONT_SIZE + padding + margin}, 2, 1, .By_Col)
        for opt in gm.Class {

            if piece.class == opt do continue
                if opt == .king do continue

                    source := rf.enum_string(opt)
                    first := str.to_upper(source[:1], context.temp_allocator)
                    label := str.join({first, source[1:]}, "", context.temp_allocator) 

                    if ui.component_simple_button(label, f32(width - margin), ui.grid_get_next(), f32(padding)) {
                        pressed = true if top else false
                        promotion = opt
                    }


        }
        ui.grid_end()

        if pressed {

            gm.piece_promote(piece, promotion)
            log.debug("pressed", work.piece_id, piece)
            g.PAUSE = false
            return .pop

        }

        return .move_top

}

// ui_promotion_cleanup :: proc(workspace: rawptr) {
//     free(workspace)
// }


ui_promotion_init :: proc(game: ^gm.Match, piece_id: i32) -> ui.Ui {

    memory: virtual.Arena
    err := virtual.arena_init_growing(&memory)
    assert(err == nil)
    alloc := virtual.arena_allocator(&memory)

    assert(piece_id >= 0)

    work := new(Promotion_Work, alloc)
    work.piece_id = piece_id
    work.game = game

    return ui.Ui {
        workspace = work,
        type = i32(Ui_Type.promotion),
        memory = memory
    }

}

ui_main_menu_call :: proc(workspace: rawptr, top: bool) -> ui.UiSig{

    state := cast(^State)workspace

    anchor := ui.scr_pos({0.5, 0.5})

    title_font_size: i32 = g.FONT_SIZE * 3;
    title: cstring = "Normal Chess"
    title_wid := rl.MeasureText(title, title_font_size)
    title_pos := [2]i32{
        i32(anchor.x) - title_wid/2,
        i32(anchor.y) - title_font_size - 250
    }

    rl.DrawRing(anchor, 25.0, 30.0, 0.0, 360.0, 1, rl.WHITE)
    rl.DrawText(title, title_pos.x, title_pos.y, g.FONT_SIZE * 3, rl.WHITE)

    button_width: f32 = 250

    play_button_pos := [2]f32{
        anchor.x - button_width/2,
        anchor.y + g.FONT_SIZE + 10

    }

    quit_button_pos := [2]f32{

        anchor.x - button_width/2,
        anchor.y + g.FONT_SIZE * 2 + 30
    }

    row_pos := [2]f32{
        anchor.x - button_width/2,
        anchor.y + g.FONT_SIZE + 10
    }

    row_gap: f32 = 10 + g.FONT_SIZE + 20

    ui.rows_begin(row_pos, row_gap)

    if ui.component_simple_button("Play", button_width, ui.rows_get_next()) {

        state.app_state = .Gameplay

    }

    if ui.component_simple_button("Quit", button_width, ui.rows_get_next()) {

        g.RUNNING = false

    }

    ui.rows_end()

    return .ok

}

ui_main_menu_init :: proc(st: ^State) -> ui.Ui {

    return ui.Ui {
        workspace = st,
        type = i32(Ui_Type.main_menu)
    }
}

ui_pause_init :: proc(st: ^State) -> ui.Ui {

    return ui.Ui {

    }

}

ui_pause_call :: proc(workspace: rawptr, top: bool) -> ui.UiSig{

     return .ok
}

