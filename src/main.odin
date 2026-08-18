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

        g.log_level = .Debug
        rl.SetTraceLogLevel(.ALL)
    }

    context.logger = log.create_console_logger(g.log_level)
    defer log.destroy_console_logger(context.logger)

    // log_allocator: log.Log_Allocator
    // log.log_allocator_init(&log_allocator, .Debug)
    // context.allocator = log.log_allocator(&log_allocator)

    rl.InitWindow(g.window_size.x, g.window_size.y, "Normal Chess")
    defer rl.CloseWindow()
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})
    ass.init_asset_man()

    game := gm.make_match_from_file("assets/boards/standard.json")
    if game == nil do os.exit(0)

    // log.debug(game.teams)

    match_engine(game)

    gm.delete_match(game)

}
