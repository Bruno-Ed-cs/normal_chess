package ui

import "core:slice"

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

init_ui_stack :: proc() -> ^UiStack {

    stack := new(UiStack)
    stack.layers = make([dynamic]Ui, 0, 5)
    stack.next_id = 1

    return stack
}


delete_ui_stack :: proc(stack: ^UiStack) {

    for ui in stack.layers {

        if ui.cleanup != nil do ui.cleanup(ui.workspace)

    }

    delete(stack.layers)
    free(stack)
}

push_ui :: proc(stack: ^UiStack, ui: Ui) -> int {

    ui := ui
    id := stack.next_id

    ui.id = id
    stack.next_id += 1

    append(&stack.layers, ui)

    return id

}

clean_stack :: proc(stack: ^UiStack) {

    for ui in stack.layers {

        if ui.cleanup != nil do ui.cleanup(ui.workspace)

    }

    clear(&stack.layers)

}

execute_ui_stack :: proc(stack: ^UiStack) {

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

is_ui_type_active :: proc(stack: ^UiStack, interface: UiFunc) -> bool {

    for ui in stack.layers {

        if ui.callback == interface do return true

    }

    return false

}

is_ui_id_active :: proc(stack: ^UiStack, id: int) -> bool {

    for ui in stack.layers {

        if ui.id == id do return true

    }

    return false
}

is_ui_active :: proc{
    is_ui_id_active,
    is_ui_type_active,
}

remove_ui :: proc(stack: ^UiStack, ui_id: int) {

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
