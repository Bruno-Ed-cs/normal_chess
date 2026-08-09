#+feature using-stmt
package ui
import gm "../game"
import fmt "core:fmt"
import g "../globals"
import rl "vendor:raylib"
import hl "../helpers"
import rf "core:reflect"

DebugInfo :: struct {
    game: ^gm.Match,
    camera: ^rl.Camera2D

}

debug_ui :: proc(game: ^gm.Match, camera: ^rl.Camera2D) -> Ui {

    info := new(DebugInfo)
    info.camera = camera
    info.game = game

    return Ui {
        workspace = info,
        callback = proc(workspace: rawptr, top: bool) -> UiSig {

            info := cast(^DebugInfo)workspace

            mouse_pos := rl.GetMousePosition()
            world_pos := rl.GetScreenToWorld2D(mouse_pos, info.camera^)
            rl.DrawText("Chess", 0, 0, 30, rl.YELLOW);
            rl.DrawText(fmt.caprintf("window size:\nwidth: %d\nheight:%d", g.window_size.x, g.window_size.y, allocator = context.temp_allocator),
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
        },

        cleanup = proc(workspace: rawptr) {
            fmt.println("freeing my debug")
            free(workspace)

        }

    }

}


match_ui :: proc(match: ^gm.Match) -> Ui {

    return Ui {
        workspace = match,

        callback = proc(workspace: rawptr, top: bool) -> UiSig {

            game := cast(^gm.Match)workspace

            center := rl.Vector2{f32(g.window_size.x /2), f32(g.window_size.y /2)}

            cur_team: cstring = fmt.ctprintf("Turn: %s", gm.get_team_turn(game).name)

            scores: [dynamic]cstring
            defer delete(scores)
            reserve(&scores, len(game.teams))

            for team in game.teams {

                append(&scores, fmt.ctprintf("%s: %d", team.name, team.score))
            }


            anchor := scr_pos({
                0.98,
                0.02
            })

            score_hei :f32 = anchor.y + g.font_size + 20
            largest_wid: i32
            for score in scores {

                score_wid := rl.MeasureText(score, g.font_size)
                largest_wid = score_wid if score_wid > largest_wid else largest_wid
            }

            score_backdrop := rl.Rectangle{
                x = f32(i32(anchor.x) - largest_wid - 10),
                y = f32(score_hei - 5),
                width = f32(largest_wid + 20),
                height = f32(g.font_size * len(scores) + 10)
            }
            col := rl.Color{ 11, 11, 11, 120 }

            rl.DrawRectangleRounded(score_backdrop, g.roundness, g.segments, col)
            rl.DrawRectangleRoundedLines(score_backdrop, g.roundness, g.segments, g.text_color)

            for score in scores {
                score_wid := rl.MeasureText(score, g.font_size)
                rl.DrawText(score,
                    i32(anchor.x) - score_wid,
                    i32(score_hei),
                    g.font_size, rl.WHITE)

                score_hei += g.font_size + 5
            }


            team_wid := rl.MeasureText(cur_team, g.font_size)
            team_color := gm.get_team_turn(game).color

            oposite_color := hl.invert_color(team_color)
            oposite_color.a = 210

            text_pos := [2]f32{
                anchor.x - f32(team_wid),
                anchor.y,
            }

            backdrop := rl.Rectangle {
                width = f32(team_wid + 20),
                height = f32(g.font_size + 10),
                x = f32(text_pos.x - 10),
                y = f32(text_pos.y - 5)

            }

            rl.DrawRectangleRounded(backdrop, g.roundness, g.segments, team_color)
            rl.DrawRectangleRoundedLines(backdrop, g.roundness, g.segments, oposite_color)
            rl.DrawText(cur_team, 
                i32(text_pos.x),
                i32(text_pos.y),
                g.font_size, oposite_color)

            // fmt.println(team_color, oposite_color)


            return UiSig.ok
        }

    }

}

PromotionWork :: struct {
    game: ^gm.Match,
    piece_id: i32

}

promotion_ui :: proc(game: ^gm.Match, piece_id: i32) -> Ui {

    assert(piece_id >= 0)

    work := new(PromotionWork)
    work.piece_id = piece_id
    work.game = game

    return Ui {
        workspace = work,
        callback = proc(workspace: rawptr, top: bool) -> UiSig{

            work := cast(^PromotionWork)workspace

            g.pause = true
            
            width :f32 = 240.0
            margin :f32 = 10.0
            padding :f32 = 10.0

            anchor := scr_pos({0.5, 0.5})
            anchor.x -= 240 / 2
            anchor.y -= ((len(gm.Class) - 2) * f32(g.font_size + padding + margin)) / 2

            box_title := g.font_size * 2 + margin * 2 + padding 
            box := rl.Rectangle{
                width = width + padding + margin,
                height = (g.font_size + padding + margin) * (len(gm.Class) - 2) + box_title,
                x = anchor.x - margin - padding/2,
                y = anchor.y - box_title

            }

            box_text: cstring = "Promotion!"
            box_text_wid := rl.MeasureText(box_text, g.font_size)
            box_text_pos := [2]f32{
                box.x + (box.width - f32(box_text_wid)) / 2,
                box.y + margin + padding + g.font_size/4
            }

            promotion: gm.Class
            pressed := false
            piece := gm.get_piece(work.game, work.piece_id) 
            if piece == nil do return .pop

            rl.DrawRectangleRounded(box, g.roundness, g.segments, g.background_color)
            rl.DrawRectangleRoundedLines(box, g.roundness, g.segments, g.text_color)
            rl.DrawText(box_text, i32(box_text_pos.x), i32(box_text_pos.y), g.font_size, g.text_color)

            for opt in gm.Class {

                if piece.class == opt do continue
                if opt == .king do continue

                if center_button(rf.enum_string(opt), f32(width - margin), anchor, f32(padding)) {
                    pressed = true if top else false
                    promotion = opt
                }

                anchor.y += f32(margin + g.font_size + padding)

            }

            if pressed {

                gm.promote(piece, promotion)
                fmt.println("pressed", work.piece_id, piece)
                g.pause = false
                return .pop

            }

            return .move_top

        },

        cleanup = proc(workspace: rawptr) {
            free(workspace)
        }
    }

}
