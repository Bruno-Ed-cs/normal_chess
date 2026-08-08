package main

import rl "vendor:raylib"
import "core:fmt"
import "core:mem"
import g "globals"
import gm "game"


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
    }

    rl.InitWindow(g.window_size.x, g.window_size.y, "Normal Chess")
    defer rl.CloseWindow()
    rl.SetWindowMonitor(0)
    rl.SetWindowState({.WINDOW_RESIZABLE})

    game := gm.make_normal_match()

    match_engine(game)

    gm.delete_match(game)
}
