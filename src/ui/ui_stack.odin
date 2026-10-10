package ui

import "core:slice"
import "core:mem"
import "core:mem/virtual"
import g "../globals"

MAX_LAYERS :: 25
MAX_TYPES :: 100

UiStack :: struct {
    next_id: int,
    ui_render: proc(interface: ^Ui, top: bool) -> UiSig,
    temp_mem: virtual.Arena,
    types: [dynamic; MAX_TYPES]i32,
    layers: [dynamic; MAX_LAYERS]Ui,
}

UiSig :: enum {

    ok,
    move_up,
    move_down,
    move_top,
    pop,
}

SigIndex :: struct {
    target: int,
    signal: UiSig
}

Ui :: struct {

    workspace: rawptr,
    id: int,
    type: i32,
    memory: Maybe(virtual.Arena),
}

ui_stack_make :: proc(types: []i32, render_callback: proc(interface: ^Ui, top: bool) -> UiSig) -> UiStack {

    stack: UiStack
    stack.next_id = 1
    stack.ui_render = render_callback
    err := virtual.arena_init_growing(&stack.temp_mem)
    assert(err == nil)


    return stack
}


ui_stack_delete :: proc(stack: ^UiStack) {

    for &ui in stack.layers {
        if ui.memory != nil {
            virtual.arena_destroy(&ui.memory.?) 
        }
    }
    virtual.arena_destroy(&stack.temp_mem)

}

ui_stack_push_ui :: proc(stack: ^UiStack, ui: Ui) -> int {

    ui := ui
    id := stack.next_id

    ui.id = id
    stack.next_id += 1

    append(&stack.layers, ui)

    return id

}

ui_stack_clean :: proc(stack: ^UiStack) {

    for &ui in stack.layers {
        if ui.memory != nil {
            virtual.arena_destroy(&ui.memory.?) 
        }
    }

    clear(&stack.layers)
}


ui_stack_execute :: proc(stack: ^UiStack) {

    context.temp_allocator = virtual.arena_allocator(&stack.temp_mem)
    defer(free_all(context.temp_allocator))

    sig_buff := make([dynamic]SigIndex, context.temp_allocator)
    reserve(&sig_buff, len(stack.layers))
    defer delete(sig_buff)


    for index := 0; index < len(stack.layers); index += 1{

        top := true if index == len(stack.layers) - 1 else false
        result := stack.ui_render(&stack.layers[index], top)

        signal := SigIndex{
            index,
            result
        }

        append(&sig_buff, signal)
    }

    for sig in sig_buff {

        switch sig.signal {

        case .ok:

        case .move_up:

            if len(stack.layers) >= 2 {
                next := sig.target + 1 if sig.target + 1 < len(stack.layers) else sig.target
                slice.swap(stack.layers[:], sig.target, next)
            }

        case .move_down:

            if len(stack.layers) >= 2 {
                prev := sig.target - 1 if sig.target - 1 >= 0 else sig.target
                slice.swap(stack.layers[:], sig.target, prev)
            }

        case .move_top:

            last := len(stack.layers) -1
            if len(stack.layers) >= 2 {
                slice.swap(stack.layers[:], sig.target, last)
            }

        case .pop:

            if len(stack.layers) != 0 {
                for &ui in stack.layers {
                    if ui.memory != nil {
                        virtual.arena_destroy(&ui.memory.?) 
                    }
                }

                ordered_remove(&stack.layers, sig.target)
            }

        }

    }

}

ui_stack_is_type_active :: proc(stack: ^UiStack, ui_type: i32) -> bool {

    for ui in stack.layers {

        if ui.type == ui_type do return true

    }

    return false

}

ui_stack_is_id_active :: proc(stack: ^UiStack, id: int) -> bool {

    for ui in stack.layers {

        if ui.id == id do return true

    }

    return false
}

ui_stack_is_interface_active :: proc{
    ui_stack_is_id_active,
    ui_stack_is_type_active,
}

ui_stack_remove_ui :: proc(stack: ^UiStack, ui_id: int) {

    target: int = -1

    for ui, index in stack.layers {

        if ui.id == ui_id do target = index

    }

    if target >= 0 {
        ui := stack.layers[target]
        for &ui in stack.layers {
            if ui.memory != nil {
                virtual.arena_destroy(&ui.memory.?) 
            }
        }
        ordered_remove(&stack.layers, target)
    }

}
