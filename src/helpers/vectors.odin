package helpers

import "base:intrinsics"

direction_rotate_90_clock :: #force_inline proc(direction: [2]$T) -> [2]T 
where intrinsics.type_is_numeric(T) {

    rotated := direction
    rotated.y *= -1
    rotated = rotated.yx

    return rotated
}

direction_rotate_90_counter :: #force_inline proc(direction: [2]$T) -> [2]T 
where intrinsics.type_is_numeric(T) {

    rotated := direction
    rotated.x *= -1
    rotated = rotated.yx

    return rotated
}


direction_rotate_180 :: #force_inline proc(direction: [2]$T) -> [2]T 
where intrinsics.type_is_numeric(T) {

    return direction * -1

}

