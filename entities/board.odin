package entities

import rl "vendor:raylib"
import "core:fmt"

Tile :: struct {

    coordenate: [2]i32

}

Vec2 :: [2]f32

Board :: struct {

    position: Vec2,
    size: [2]i32,
    tiles: []Tile,
    sprite: rl.Texture2D,
    render: rl.RenderTexture2D
}

make_board :: proc(size: [2]i32 = {8, 8}, col1 := rl.WHITE, col2 := rl.BLACK) -> Board {

    board := Board{
        position = {0, 0},
        size = size,
        tiles = make([]Tile, size.x * size.y),
        render = rl.LoadRenderTexture(size.x * 48, size.y * 48),
    }
    board.sprite = board.render.texture

    rl.BeginTextureMode(board.render)

    set_color := true
    for col in 0..<size.y {
    set_color = !set_color

        for row in 0..<size.x {
            rec := rl.Rectangle{
                x = f32(row * 48),
                y = f32(col * 48),
                width = 48,
                height = 48
            }

            color := col2 if set_color else col1
            set_color = !set_color

            rl.DrawRectangleRec(rec, color)
        }
    }

    rl.EndTextureMode()

    return board

}

delete_board :: proc(board: ^Board) {

    delete(board.tiles)
    rl.UnloadRenderTexture(board.render)
    fmt.println("board deleted")

}
