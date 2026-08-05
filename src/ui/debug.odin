package ui
import gm "../game"
import fmt "core:fmt"
import g "../globals"
import rl "vendor:raylib"

DebugInfo :: struct {
    game: ^gm.Match,
    camera: ^rl.Camera2D

}

free_debug_ui :: proc(workspace: rawptr) {

    work := cast(^DebugInfo)workspace
    free(work)

}

new_debug_ui :: proc(game: ^gm.Match, camera: ^rl.Camera2D) -> Ui {

    info := new(DebugInfo)
    info.camera = camera
    info.game = game

    return Ui {
        callback = debug_ui,
        workspace = info,
        cleanup = free_debug_ui
    }

}

debug_ui :: proc(workspace: rawptr, top: bool) -> UiSig {

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
}
