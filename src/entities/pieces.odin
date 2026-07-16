package entities

import rl "vendor:raylib"
import ass "../asset_man"
import "core:fmt"

Dir :: enum {up, down, left, right}

Directions :: [Dir][2]i32 {
    .up = {0, -1},
    .down = {0, 1},
    .left = {1, 0},
    .right = {-1, 0}

}

Class :: enum {
    pawn,
    rook,
    bishop,
    king,
    queen,
    knight,
}

Team :: struct {
    score: int,
    color: rl.Color,
    name: string,
    cemitery_direction: [2]i32,
    piece_sprites: rl.RenderTexture2D
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
    movement: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic]Move) -> int
}

rook_movement :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic]Move) -> int {

    moves_count :int

    for dir in Directions {

        move := self.position
        walked :int = 1

        for ;;walked += 1{

            move += dir
            tile := get_tile(board, move)

            if tile == nil do break

                moves_count += 1

                if tile.piece_ref == nil {
                    append(moves_buff, Move{ attack = false, pos = move})
                } else {
                    if tile.piece_ref.team != self.team {
                        append(moves_buff, Move{ attack = true, pos = move})
                    }

                    break
                }

            }


        }

        return moves_count
}

make_piece :: proc(class: Class, position: BoardPos, team: ^Team) -> (piece: Piece) {

    piece = Piece {
        class = class,
        alive = true,
        has_moved = false,
        team = team,
        position = position,
    }

    switch class {
    
    case .pawn:
        piece.movement = pawn_movement
    case .rook:
        piece.movement = rook_movement
    case .bishop:
    case .king:
    case .queen:
    case .knight:

    }

    return
}

pawn_movement :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic]Move) -> int {

    moves_count: int

    diagonal_killers : [2]BoardPos

    switch self.team.cemitery_direction {

    case {1, 0}:
        diagonal_killers[0] = {self.position.x +1, self.position.y +1}
        diagonal_killers[1] = {self.position.x +1, self.position.y -1} 
    case {-1, 0}:
        diagonal_killers[0] = {self.position.x -1, self.position.y +1}
        diagonal_killers[1] = {self.position.x -1, self.position.y -1} 
    case {0, -1}:
        diagonal_killers[0] = {self.position.x +1, self.position.y -1}
        diagonal_killers[1] = {self.position.x -1, self.position.y -1} 
    case {0, 1}:
        diagonal_killers[0] = {self.position.x +1, self.position.y +1}
        diagonal_killers[1] = {self.position.x -1, self.position.y +1} 

    }

    for &diag in diagonal_killers {
        fmt.println(diag)
        if tile := get_tile(board, diag); tile != nil{
            if tile.piece_ref != nil && tile.piece_ref.team != self.team{
                append(moves_buff, Move{ attack = true, pos = diag})
                moves_count += 1
            }
        }
    }

    move_len := 1 if self.has_moved else 2
    last_move := self.position
    for index in 1..=move_len {

        move := last_move + self.team.cemitery_direction

        tile := get_tile(board, move)
        if tile == nil do continue
        if tile.piece_ref != nil do continue

        last_move = move
        moves_count += 1
        append(moves_buff, Move{ attack = false, pos = move})

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

make_team :: proc(name: string, color: rl.Color, cemitery: [2]i32) -> Team {

    base_spritesheet := ass.get_asset("sprite_sheet.png").(rl.Texture2D)
    sprite_image := rl.LoadImageFromTexture(base_spritesheet)
    defer rl.UnloadImage(sprite_image)

    team := Team{
        cemitery_direction = cemitery,
        name = name,
        score = 0,
        color = color,
        piece_sprites = rl.LoadRenderTexture(sprite_image.width, sprite_image.height)
    }

    base_pixels := rl.LoadImageColors(sprite_image)
    defer rl.UnloadImageColors(base_pixels)

    size := sprite_image.height * sprite_image.width

    for i in 0..<size {

        primary_col := rl.Color{255, 255, 255, 255} 
        secondary_col := rl.Color{153, 153, 153, 255}

        if base_pixels[i] == primary_col {
            base_pixels[i] = color
        }

        if base_pixels[i] == secondary_col {

            base_pixels[i] = rl.ColorBrightness(base_pixels[i], 1.20)
            base_pixels[i] = rl.ColorAlphaBlend(base_pixels[i], color, rl.Color{70, 60, 108, 255})
        }

    }

    rl.UpdateTexture(team.piece_sprites.texture, base_pixels)

    return team

}

delete_team :: proc(team: ^Team) {

    rl.UnloadRenderTexture(team.piece_sprites)
}

