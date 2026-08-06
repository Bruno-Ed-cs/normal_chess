package ui
import gm "../game"
import fmt "core:fmt"
import g "../globals"
import rl "vendor:raylib"
import hl "../helpers"

LongTriangle :: struct {
    triangle: [3]rl.Vector2,
    end: rl.Vector2
}

new_match_ui :: proc(match: ^gm.Match) -> Ui {

    hud := Ui {
        callback = match_ui,
        workspace = match

    }

    return hud
}

match_ui :: proc(workspace: rawptr, top: bool) -> UiSig {

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
