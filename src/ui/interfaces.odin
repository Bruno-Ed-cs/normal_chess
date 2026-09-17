#+feature using-stmt
package ui
import gm "../game"
import "core:fmt"
import g "../globals"
import rl "vendor:raylib"
import hl "../helpers"
import rf "core:reflect"
import str "core:strings"
import "core:log"
import "core:mem/virtual"

Ui_Type :: enum {

    debug,
    match,
    promotion, 
    main_menu,
}

ui_render :: proc(interface: ^Ui, top: bool) -> UiSig {

    implementation : proc(workspace: rawptr, top: bool) -> UiSig 

    switch interface.type {

    case .debug:
        implementation = ui_debug_call

    case .match:
        implementation = ui_match_call

    case .promotion:
        implementation = ui_promotion_call

    case .main_menu:
        implementation = ui_main_menu_call

    }

    return implementation(interface.workspace, top)
}

ui_cleanup :: proc(interface: ^Ui) {

    if interface.memory != nil {
        virtual.arena_destroy(&interface.memory.?) 
    }

    // #partial switch interface.type {
    // case .debug:
    //     ui_debug_cleanup(interface.workspace)
    //
    // case .promotion:
    //     ui_promotion_cleanup(interface.workspace)
    // }

    return
}

Debug_Info :: struct {
    game: ^gm.Match,
    camera: ^rl.Camera2D

}

ui_debug_call :: proc(workspace: rawptr, top: bool) -> UiSig {

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

    return UiSig.move_down
}

// ui_debug_cleanup :: proc(workspace: rawptr) {
//     log.debug("freeing my debug")
//     free(workspace)
//
// }

ui_debug_init :: proc(game: ^gm.Match, camera: ^rl.Camera2D) -> Ui {

    memory: virtual.Arena
    err := virtual.arena_init_growing(&memory)
    assert(err == nil)
    alloc := virtual.arena_allocator(&memory)

    info := new(Debug_Info, alloc)
    info.camera = camera
    info.game = game

    return Ui {
        workspace = info,
        type = .debug,
        memory = memory
    }

}


ui_match_call :: proc(workspace: rawptr, top: bool) -> UiSig {

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


    anchor := scr_pos({
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


            return UiSig.ok
}

ui_match_init :: proc(match: ^gm.Match) -> Ui {

    return Ui {
        workspace = match,
        type = .match
    }

}

Promotion_Work :: struct {
    game: ^gm.Match,
    piece_id: i32

}

ui_promotion_call ::proc(workspace: rawptr, top: bool) -> UiSig{

    work := cast(^Promotion_Work)workspace

    g.PAUSE = true

    width :f32 = 240.0
    margin :f32 = 10.0
    padding :f32 = 10.0

    anchor := scr_pos({0.5, 0.5})
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

        for opt in gm.Class {

            if piece.class == opt do continue
                if opt == .king do continue

                    source := rf.enum_string(opt)
                    first := str.to_upper(source[:1], context.temp_allocator)
                    label := str.join({first, source[1:]}, "", context.temp_allocator) 

                    if component_simple_button(label, f32(width - margin), anchor, f32(padding)) {
                        pressed = true if top else false
                        promotion = opt
                    }

                    anchor.y += f32(margin + g.FONT_SIZE + padding)

        }

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


ui_promotion_init :: proc(game: ^gm.Match, piece_id: i32) -> Ui {

    memory: virtual.Arena
    err := virtual.arena_init_growing(&memory)
    assert(err == nil)
    alloc := virtual.arena_allocator(&memory)

    assert(piece_id >= 0)

    work := new(Promotion_Work, alloc)
    work.piece_id = piece_id
    work.game = game

    return Ui {
        workspace = work,
        type = .promotion,
        memory = memory
    }

}

ui_main_menu_call :: proc(workspace: rawptr, top: bool) -> UiSig{



    return .ok

}

ui_main_menu_init :: proc(game: ^gm.Match) -> Ui {

    return Ui {
        workspace = game,
        type = .main_menu
    }
}
