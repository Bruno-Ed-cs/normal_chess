package entities

import rl "vendor:raylib"

Class :: enum {
    pawn,
    rook,
    bishop,
    king,
    queen,
    knight,
    tower
}

Team :: struct {
    score: i32,
    color: rl.Color,
    name: string,
}

Move :: struct {
    attack: bool,
    pos: BoardPos,
}

Piece :: struct {

    alive: bool,
    has_moved: bool,
    team: ^Team,
    position: BoardPos,
    class: Class,
    sprite: rl.Texture2D,
    movement: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic]Move) -> int
}

make_pawn :: proc(textures: ^map[string]rl.Texture2D, position: BoardPos, team: ^Team) -> (piece: Piece) {

    piece = Piece {
        class = .pawn,
        alive = true,
        has_moved = false,
        team = team,
        position = position,
        movement = paw_movement
    }
    
    texture, ok := textures["pawn"]

    if ok {
        piece.sprite = texture
    }

    return
}

paw_movement :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic]Move) -> int {

    moves_count: int

    diagonal_killers := [2]BoardPos{{self.position.x -1, self.position.y -1}, {self.position.x +1, self.position.y -1}}

    for diag in diagonal_killers {

        if tile := get_tile(board, diag); tile != nil{
            if tile.piece_ref != nil && tile.piece_ref.team != self.team{
                append(moves_buff, Move{ attack = true, pos = diag})
                moves_count += 1
            }
        }
    }

    move_len := 1 if self.has_moved else 2
    for index in 1..=move_len {

        position := BoardPos{self.position.x, self.position.y - i32(index)}
        if tile := get_tile(board, position );
        tile != nil {

            if tile.piece_ref == nil {
                append(moves_buff, Move{attack = false, pos = position})
                moves_count += 1
            } else {

                break
            }
        }

    }

    return moves_count

}

move :: proc(piece: ^Piece, board: ^Board, target: BoardPos) {

    tile := get_tile(board, target)

    if tile == nil do return

    piece.has_moved = true
    piece.position = target

    if tile.piece_ref != nil {
        kill(tile.piece_ref)
        tile.piece_ref = piece
    }

}

kill :: proc(piece: ^Piece) {

    piece.alive = false

}
