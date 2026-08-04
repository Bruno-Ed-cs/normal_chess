package ui_stack

import "core:slice"

UiFunc :: proc(workspace: rawptr, top: bool) -> UiSig
UiCleanup :: proc(workspace: rawptr)

UiStack :: struct {
    stack: [dynamic]Ui,
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
    stack.stack = make([dynamic]Ui, 0, 5)
    stack.next_id = 1

    return stack
}


delete_ui_stack :: proc(stack: ^UiStack) {

    for ui in stack.stack {

        ui.cleanup(ui.workspace)

    }

    delete(stack.stack)
}

push_ui :: proc(stack: ^UiStack, ui: Ui) -> int {

    ui := ui
    id := stack.next_id

    ui.id = id
    stack.next_id += 1

    append(&stack.stack, ui)

    return id

}

clean_stack :: proc(stack: ^UiStack) {

    for ui in stack.stack {

        ui.cleanup(ui.workspace)

    }

    clear(&stack.stack)

}

execute_ui_stack :: proc(stack: ^UiStack) {

    sig_buff: [dynamic]SigIndex
    reserve(&sig_buff, len(stack.stack))

    for index := 0; index < len(stack.stack); index += 1{

        top := true if index == len(stack.stack) else false
        result := stack.stack[index].callback(stack.stack[index].workspace, top)

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

                if len(stack.stack) >= 2 {
                    next := sig.target + 1 if sig.target + 1 < len(stack.stack) else sig.target
                    slice.swap(stack.stack[:], sig.target, next)
                }

            case .move_down:

                if len(stack.stack) >= 2 {
                    prev := sig.target - 1 if sig.target - 1 >= 0 else sig.target
                    slice.swap(stack.stack[:], sig.target, prev)
                }

            case .move_top:

                last := len(stack.stack) -1
                if len(stack.stack) >= 2 {
                    slice.swap(stack.stack[:], sig.target, last)
                }

            case .pop:

                if len(stack.stack) != 0 {
                    ordered_remove(&stack.stack, sig.target)
                }

        }

    }

}

is_ui_type_active :: proc(stack: ^UiStack, interface: UiFunc) -> bool {

    for ui in stack.stack {

        if ui.callback == interface do return true

    }

    return false

}

is_ui_id_active :: proc(stack: ^UiStack, id: int) -> bool {

    for ui in stack.stack {

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

    for ui, index in stack.stack {
        
        if ui.id == ui_id do target = index

    }

    if target >= 0 {
        ordered_remove(&stack.stack, target)
    }

}
