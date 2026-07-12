package entities

import rl "vendor:raylib"

Class :: enum {
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
    movement: Movement,
    sprite: rl.Texture2D,
}
