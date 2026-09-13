package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:log"
import "core:dynlib"
import g "globals"
import str "core:strings"
import "core:time"
import rl "vendor:raylib"

Engine_Symbols :: struct{
    lib: dynlib.Library,
    version: int,
    RUNNING: ^bool,
    GetFrameTime: proc() -> f32,
    IsKeyReleased: proc(key: int) -> bool,
    match_engine_run: proc(state: rawptr),
    match_engine_make: proc(path:string) -> rawptr,
    match_engine_delete: proc(state: rawptr),
    match_engine_cleanup: proc(),
    match_engine_init_window: proc(),
    match_engine_close_window: proc()
}

WATCH_INTERVAL :: 0.5

dll_reload :: proc (symbols: ^Engine_Symbols, source_lib: string, bin_dir: string) -> bool {

    log.info("Reloading library")

    // delete(new_path)
    symbols.version += 1
    new_path := fmt.tprintf("{}/engine_{}.so", bin_dir, symbols.version)

    if !copy_dll(new_path, source_lib) do return false

    lib_old := symbols.lib
    symbols.lib, _ = dynlib.load_library(new_path)
    count, ok := dynlib.initialize_symbols(symbols, new_path)

    if count <= 0 || !ok {
        log.info("Error loading the library symbols" ,count)
        os.exit(1)
    }

    dynlib.unload_library(lib_old)

    return true
}

get_dll_info :: proc(filepath: string) -> (mod_time: time.Time, size: i64) {

    lib_info_old, err := os.lstat(filepath, context.allocator)
    defer os.file_info_delete(lib_info_old, context.allocator)
    if err != nil {
        log.errorf("Could not get the info for the library file \"{}\"\n{}", filepath, err);
    }

    mod_time = lib_info_old.modification_time
    size = lib_info_old.size

    return 

}

copy_dll :: proc(target: string, source: string) -> bool {
	copy_err := os.copy_file(target, source)

	if copy_err != nil {
		fmt.printfln("Failed to copy dll to {}: %v", target, copy_err)
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

    LIB_NAME :: "engine." + dynlib.LIBRARY_FILE_EXTENSION
    bin_dir, _ := os.get_executable_directory(context.allocator)
    defer delete(bin_dir)
    lib_source_path := str.concatenate({bin_dir, "/", LIB_NAME})
    defer delete(lib_source_path)

    log.info(lib_source_path)
    eng: Engine_Symbols
    eng.version = 1

    new_path := fmt.tprintf("{}/engine_{}.so", bin_dir, eng.version)
    copy_dll(new_path, lib_source_path)

    eng.lib, _= dynlib.load_library(new_path)
    count, ok := dynlib.initialize_symbols(&eng, new_path)
    if count <= 0 || !ok {
        log.info("Error loading the libray symbols")
        os.exit(1)
    }

    board_path: string = "assets/boards/standard.json" if len(os.args) < 2 else os.args[1]

    eng.match_engine_init_window()
    state := eng.match_engine_make(board_path)

    timestamp_old, size_old := get_dll_info(lib_source_path)
    
    mod_delay: f32

    for eng.RUNNING^ {

        lib_info, err := os.lstat(lib_source_path, context.allocator)
        if err != nil {
            log.info("File is in lockdown", err);
            continue
        }

        timestamp, size := get_dll_info(lib_source_path)

        if size != size_old {
            mod_delay = 0
            size_old = size

        }
        mod_delay += eng.GetFrameTime()
        // log.info(timestamp, timestamp_old)

        if timestamp != timestamp_old && mod_delay >= WATCH_INTERVAL {
            log.info("Reloading library")

            // delete(new_path)
            timestamp_old = timestamp

            eng.match_engine_cleanup()

            if !dll_reload(&eng, lib_source_path, bin_dir) do continue

        }

        if eng.IsKeyReleased(int(rl.KeyboardKey.F5)) {

            eng.match_engine_cleanup()
            eng.match_engine_delete(state)

            log.info("Full reset")
            if !dll_reload(&eng, lib_source_path, bin_dir) do os.exit(1)

            state = eng.match_engine_make(board_path)
        }

        // fmt.println("aaaa")
        eng.match_engine_run(state)

        size_old = size
        os.file_info_delete(lib_info, context.allocator)
    }

    eng.match_engine_cleanup()
    eng.match_engine_delete(state)
    eng.match_engine_close_window()
}
