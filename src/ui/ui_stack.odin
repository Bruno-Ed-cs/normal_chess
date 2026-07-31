package ui_stack

UiStack :: struct {
    stack: [dynamic]Ui,
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
    callback: proc(workspace: rawptr, top: bool) -> UiSig,
    cleanup: proc(workspace: rawptr),
}

init_ui_stack :: proc() -> ^UiStack {

    stack := new(UiStack)
    stack.stack = make([dynamic]Ui, 0, 5)

    return stack
}

delete_ui_stack :: proc(stack: ^UiStack) {

    delete(stack.stack)
}

push_ui :: proc(stack: ^UiStack, ui: Ui) {

    append(&stack.stack, ui)

}

clean_stack :: proc(stack: ^UiStack) {

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

        #partial switch sig.signal {

            case:

        }

    }

}
