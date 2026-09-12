package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:log"
import "core:dynlib"
import gm "game"
import g "globals"

Engine_Symbols :: struct{
    RUNNING: ^bool,
    match_engine_run: proc(game: ^gm.Match),
    match_engine_init: proc(game: ^gm.Match),
    match_engine_load_match:proc(path: string) -> ^gm.Match,
    match_engine_delete: proc(game: ^gm.Match),
    match_engine_init_window: proc(),
    match_engine_close_window: proc()
}

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
    }

    context.logger = log.create_console_logger(g.LOG_LEVEL)
    defer log.destroy_console_logger(context.logger)

    // log_allocator: log.Log_Allocator
    // log.log_allocator_init(&log_allocator, .Debug)
    // context.allocator = log.log_allocator(&log_allocator)


    //gm.record_normal_match(game)

    // log.debug(game.teams)

    LIB_PATH :: "engine." + dynlib.LIBRARY_FILE_EXTENSION
    eng: Engine_Symbols
    count, ok := dynlib.initialize_symbols(&eng, LIB_PATH)

    if count <= 0 || !ok {
        log.info("Error loading the libray symbols")
        os.exit(1)
    }

    eng.match_engine_init_window()

    board_path: string = "assets/boards/standard.json" if len(os.args) < 2 else os.args[1]
    game := eng.match_engine_load_match(board_path)

    eng.match_engine_init(game)

    for eng.RUNNING^ {

        eng.match_engine_run(game)

    }

    eng.match_engine_delete(game)
    eng.match_engine_close_window()
}
