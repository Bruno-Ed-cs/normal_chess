package game

import rl "vendor:raylib"
import g "../globals"
import "core:log"
import "core:fmt"

Board_Pos :: [2]i32
TILE_SIZE :: 32

Tile :: struct {

    coordenate: Board_Pos,
    hitbox: rl.Rectangle,
    piece_ref: ^Piece
}

Vec2 :: [2]f32

Board :: struct {

    position: Vec2,
    size: [2]i32,
    tiles: []Tile,
    sprite: rl.Texture2D,
    render: rl.RenderTexture2D
}

// the coordenate given is the top left corner of the tile
board_to_world :: proc(board: ^Board, position: Board_Pos) -> (world_pos: Vec2, valid: bool) {

    if position.y >= board.size.y || position.x >= board.size.x ||
       position.y < 0 || position.x < 0 {

           return Vec2{0, 0}, false
    }

    world_pos.x = f32(i32(board.position.x) + position.x * TILE_SIZE)
    world_pos.y = f32(i32(board.position.y) + position.y * TILE_SIZE)
    valid = true

    return
}

// returns nil when the position is invalid
board_get_tile :: proc(board: ^Board, position: Board_Pos) -> ^Tile {

    if position.y >= board.size.y || position.x >= board.size.x ||
       position.y < 0 || position.x < 0 {

           return nil
    }

    return &board.tiles[position.x + position.y * board.size.y]
}

world_to_board :: proc(board: ^Board, position: Vec2) -> (board_pos: Board_Pos, in_bounds: bool) {

    board_bounds := rl.Rectangle {
        x = board.position.x,
        y = board.position.y,
        width = f32(board.size.x * TILE_SIZE),
        height = f32(board.size.y * TILE_SIZE)
    }

    if !rl.CheckCollisionPointRec(position, board_bounds) {
        in_bounds = false
        board_pos = {-1, -1}
        return
    }


    for tile in board.tiles {

        if rl.CheckCollisionPointRec(position, tile.hitbox) {

            board_pos = tile.coordenate
            in_bounds = true
            break

        }

    }

    return

}

board_make :: proc(size: [2]i32 = {8, 8}, col1 := rl.WHITE, col2 := rl.BLACK) -> Board {

    board := Board{
        position = {0, 0},
        size = size,
        tiles = make([]Tile, size.x * size.y),
        render = rl.LoadRenderTexture(size.x * TILE_SIZE, size.y * TILE_SIZE),
    }
    board.sprite = board.render.texture

    for &tile, index in board.tiles {
        tile = {
            coordenate = { i32(index) % size.x, i32(index) / size.y },
            piece_ref = nil
        }

        tile_pos, valid := board_to_world(&board, tile.coordenate)
        if valid {
            tile.hitbox = {
                x = tile_pos.x,
                y = tile_pos.y,
                width = TILE_SIZE,
                height = TILE_SIZE
            }


        } else {
            log.error("the coordenate is invalid", tile.coordenate)
        }
    }

    rl.BeginTextureMode(board.render)

    set_color := true
    for col in 0..<size.y {
    set_color = !set_color

        for row in 0..<size.x {
            rec := rl.Rectangle{
                x = f32(row * TILE_SIZE),
                y = f32(col * TILE_SIZE),
                width = TILE_SIZE,
                height = TILE_SIZE
            }

            color := col2 if set_color else col1
            set_color = !set_color

            rl.DrawRectangleRec(rec, color)
        }
    }

    rl.EndTextureMode()

    return board

}

board_update :: proc(board: ^Board, pieces: []Piece) {

    for &tile in board.tiles {
        for &piece in pieces {

            if piece.position == tile.coordenate && piece.alive{
                tile.piece_ref = &piece
            }

        }

        if tile.piece_ref != nil && tile.coordenate != tile.piece_ref.position {

            tile.piece_ref = nil
        }

    }

}

board_delete :: proc(board: ^Board) {

    delete(board.tiles)
    rl.UnloadRenderTexture(board.render)
    log.debug("board deleted")

}


