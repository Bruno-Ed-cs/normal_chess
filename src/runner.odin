package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:log"
import "core:dynlib"
import g "globals"
import str "core:strings"

Engine_Symbols :: struct{
    lib: dynlib.Library,
    version: int,
    RUNNING: ^bool,
    GetFrameTime: proc() -> f32,
    match_engine_run: proc(game: rawptr),
    match_engine_init: proc(game: rawptr),
    match_engine_load_match:proc(path: string) -> ^rawptr,
    match_engine_delete: proc(game: ^rawptr),
    match_engine_init_window: proc(),
    match_engine_close_window: proc()
}

copy_dll :: proc(to: string, dll_path: string) -> bool {
	copy_err := os.copy_file(to, dll_path)

	if copy_err != nil {
		fmt.printfln("Failed to copy dll to {}: %v", to, copy_err)
		return false
	}

	return true
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

    bin_dir, _ := os.get_executable_directory(context.allocator)
    lib_path := str.concatenate({bin_dir, "/", LIB_PATH})
    defer delete(bin_dir)
    defer delete(lib_path)

    log.info(lib_path)
    eng: Engine_Symbols
    eng.version = 1
    new_path := fmt.tprintf("{}/engine_{}.so", bin_dir, eng.version)
    copy_dll(new_path, lib_path)
    eng.lib , _= dynlib.load_library(new_path)
    count, ok := dynlib.initialize_symbols(&eng, new_path)

    if count <= 0 || !ok {
        log.info("Error loading the libray symbols")
        os.exit(1)
    }

    eng.match_engine_init_window()

    board_path: string = "assets/boards/standard.json" if len(os.args) < 2 else os.args[1]
    game := eng.match_engine_load_match(board_path)

    eng.match_engine_init(game)



    lib_info_old, err := os.lstat(lib_path, context.allocator)
    if err != nil {
        log.error("Could not get the info for the library file", err);
    }
    timestamp_old := lib_info_old.modification_time
    size_old := lib_info_old.size
    defer os.file_info_delete(lib_info_old, context.allocator)
    
    mod_delay: f32

    for eng.RUNNING^ {

        lib_info, err := os.lstat(lib_path, context.allocator)
        if err != nil {
            log.error("Could not get the info for the library file", err);
            continue
        }
        timestamp := lib_info.modification_time
        size := lib_info.size
        if size != size_old {
            mod_delay = 0
            size_old = size

        }
        mod_delay += eng.GetFrameTime()
        // log.info(timestamp, timestamp_old)

        if timestamp != timestamp_old && mod_delay >= 2.0{
            log.info("Reloading library")

            // delete(new_path)
            eng.version += 1
            new_path = fmt.tprintf("{}/engine_{}.so", bin_dir, eng.version)
            if !copy_dll(new_path, lib_path) do continue
            timestamp_old = timestamp
            eng.lib, _ = dynlib.load_library(new_path)
            count, ok := dynlib.initialize_symbols(&eng, new_path)

            if count <= 0 || !ok {
                log.info("Error loading the library symbols" ,count)
                os.exit(1)
            }


            dynlib.unload_library(eng.lib)

            eng.match_engine_init(game)
        }


        // fmt.println("aaaa")
        eng.match_engine_run(game)

        size_old = lib_info.size
        os.file_info_delete(lib_info, context.allocator)
    }

    eng.match_engine_delete(game)
    eng.match_engine_close_window()
}
