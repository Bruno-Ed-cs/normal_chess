package entities

import rl "vendor:raylib"
import ass "../asset_man"

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
    cemitery_direction: [2]int,
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

make_pawn :: proc(texture: rl.Texture2D, position: BoardPos, team: ^Team) -> (piece: Piece) {

    piece = Piece {
        class = .pawn,
        alive = true,
        has_moved = false,
        team = team,
        position = position,
        movement = paw_movement,
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

make_team :: proc(name: string, color: rl.Color, cemitery: [2]int) -> Team {

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
