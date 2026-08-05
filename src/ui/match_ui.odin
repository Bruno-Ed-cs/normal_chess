package ui
import gm "../game"
import fmt "core:fmt"
import g "../globals"
import rl "vendor:raylib"


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

    cur_team: cstring = fmt.caprintf("Turn: %s", gm.get_team_turn(game).name, allocator = context.temp_allocator)
    score: cstring = fmt.caprintf("%s: %d | %s: %d", game.teams[0].name, game.teams[0].score, game.teams[1].name, game.teams[1].score, 
        allocator = context.temp_allocator)

    team_wid := rl.MeasureText(cur_team, font_size)
    score_wid := rl.MeasureText(score, font_size)

    rl.DrawText(score, i32(center.x) - score_wid /2, 0, font_size, rl.GRAY)
    rl.DrawText(cur_team, i32(center.x) - team_wid /2, g.window_size.y - 32, font_size, rl.GRAY)

    return UiSig.ok
}
