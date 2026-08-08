package ui
import gm "../game"
import fmt "core:fmt"
import g "../globals"
import rl "vendor:raylib"
import hl "../helpers"

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
            font_size :: 32

            cur_team: cstring = fmt.ctprintf("Turn: %s", gm.get_team_turn(game).name)

            scores: [dynamic]cstring
            defer delete(scores)
            reserve(&scores, len(game.teams))

            for team in game.teams {

                append(&scores, fmt.ctprintf("%s: %d", team.name, team.score))
            }


            score_hei :i32 = 120
            largest_wid: i32
            for score in scores {

                score_wid := rl.MeasureText(score, font_size)
                largest_wid = score_wid if score_wid > largest_wid else largest_wid
            }

            score_backdrop := rl.Rectangle{
                x = f32(g.window_size.x - largest_wid - 30),
                y = f32(score_hei - 5),
                width = f32(largest_wid + 20),
                height = f32(font_size * len(scores) + 10)
            }
            col := rl.Color{ 11, 11, 11, 120 }

            rl.DrawRectangleRec(score_backdrop, col)

            for score in scores {
                score_wid := rl.MeasureText(score, font_size)
                rl.DrawText(score,
                    g.window_size.x - score_wid - 20,
                    score_hei,
                    font_size, rl.WHITE)

                score_hei += font_size + 5
            }


            team_wid := rl.MeasureText(cur_team, font_size)
            team_color := gm.get_team_turn(game).color

            oposite_color := hl.invert_color(team_color)
            oposite_color.a = 210

            text_pos := [2]i32{
                g.window_size.x - team_wid -20,
                20
            }

            backdrop := rl.Rectangle {
                width = f32(team_wid + 20),
                height = f32(font_size + 10),
                x = f32(text_pos.x - 10),
                y = f32(text_pos.y - 5)

            }

            rl.DrawRectangleRec(backdrop, oposite_color)

            rl.DrawText(cur_team, 
                text_pos.x,
                text_pos.y,
                font_size, team_color)

            // fmt.println(team_color, oposite_color)


            return UiSig.ok
        }

    }

}


