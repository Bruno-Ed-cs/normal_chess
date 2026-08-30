package main

import rl "vendor:raylib"
import "core:fmt"
import "core:mem"
import "core:os"
import "core:log"
import g "globals"
import gm "game"
import ass "asset_man"

main :: proc() {

    when ODIN_DEBUG {
        track: mem.Tracking_Allocator
        mem.tracking_allocator_init(&track, context.allocator)
        context.allocator = mem.tracking_allocator(&track)

        defer {
            if len(track.allocation_map) > 0 {
                fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
                for _, entry in track.allocation_map {
                    fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
                }
            }
            mem.tracking_allocator_destroy(&track)
        }

        g.LOG_LEVEL = .Debug
        rl.SetTraceLogLevel(.ALL)
    }

    context.logger = log.create_console_logger(g.LOG_LEVEL)
    defer log.destroy_console_logger(context.logger)

    // log_allocator: log.Log_Allocator
    // log.log_allocator_init(&log_allocator, .Debug)
    // context.allocator = log.log_allocator(&log_allocator)

    rl.InitWindow(g.WINDOW_SIZE.x, g.WINDOW_SIZE.y, "Normal Chess")
    defer rl.CloseWindow()
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})
    ass.asset_man_init()

    board_path: string = "assets/boards/standard.json" if len(os.args) < 2 else os.args[1]

    game := gm.match_make_from_file(board_path)
    if game == nil do os.exit(0)
    //gm.record_normal_match(game)

    // log.debug(game.teams)

    match_engine_run(game)

    gm.match_delete(game)

}
