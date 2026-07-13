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

Movement :: struct {
    r_pos: Vec2,
    raycast: bool
}

Piece :: struct {

    alive: bool,
    has_moved: bool,
    team: ^Team,
    position: BoardPos,
    class: Class,
    movement: []Movement,
    sprite: rl.Texture2D,
}

make_pawn :: proc(textures: ^map[string]rl.Texture2D, position: BoardPos, team: ^Team) -> (piece: Piece) {

    piece = Piece {
        class = .pawn,
        alive = true,
        has_moved = false,
        team = team,
        position = position

    }
    
    texture, ok := textures["pawn"]

    if ok {
        piece.sprite = texture
    }


    return

}
