package ui

import "core:slice"
import "core:mem"
import g "../globals"

ui_memory: [g.UI_MEM_SIZE]byte

UiFunc :: proc(workspace: rawptr, top: bool) -> UiSig
UiCleanup :: proc(workspace: rawptr)

UiStack :: struct {
    layers: [dynamic]Ui,
    next_id: int,
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
    callback: UiFunc,
    cleanup: UiCleanup,
    id: int,
}

ui_stack_make :: proc() -> ^UiStack {

    stack := new(UiStack)
    stack.layers = make([dynamic]Ui, 0, 5)
    stack.next_id = 1

    return stack
}


ui_stack_delete :: proc(stack: ^UiStack) {

    for ui in stack.layers {

        if ui.cleanup != nil do ui.cleanup(ui.workspace)

    }

    delete(stack.layers)
    free(stack)
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

    for ui in stack.layers {

        if ui.cleanup != nil do ui.cleanup(ui.workspace)

    }

    clear(&stack.layers)

}


ui_stack_execute :: proc(stack: ^UiStack) {

    ui_arena: mem.Arena
    mem.arena_init(&ui_arena, ui_memory[:])
    context.temp_allocator = mem.arena_allocator(&ui_arena)
    defer(free_all(context.temp_allocator))

    sig_buff := make([dynamic]SigIndex, context.temp_allocator)
    reserve(&sig_buff, len(stack.layers))
    defer delete(sig_buff)


    for index := 0; index < len(stack.layers); index += 1{

        if stack.layers[index].callback == nil do continue

        top := true if index == len(stack.layers) - 1 else false
        result := stack.layers[index].callback(stack.layers[index].workspace, top)

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
                    if ui := &stack.layers[sig.target]; ui.cleanup != nil {
                        ui.cleanup(ui.workspace)
                    }
                    ordered_remove(&stack.layers, sig.target)
                }

        }

    }

}

ui_stack_is_type_active :: proc(stack: ^UiStack, interface: UiFunc) -> bool {

    for ui in stack.layers {

        if ui.callback == interface do return true

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
        if ui.cleanup != nil do ui.cleanup(ui.workspace)
        ordered_remove(&stack.layers, target)
    }

}
