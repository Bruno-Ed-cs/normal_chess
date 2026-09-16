package game

import rl "vendor:raylib"
import ass "../asset_man"
import "core:fmt"
import "core:log"
import "core:math/linalg"
import g "../globals"

Dir :: enum {up, down, left, right}
Diag :: enum {up_left, up_right, down_left, down_right}

Directions :: [Dir][2]i32 {
    .up = {0, -1},
    .down = {0, 1},
    .left = {1, 0},
    .right = {-1, 0}

}

Diagonals :: [Diag][2]i32 {
    .up_left = {-1, 1},
    .up_right = {1, 1},
    .down_left = {-1, -1},
    .down_right = {1, -1}

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
    march_direction: [2]i32,
    piece_sprites: rl.RenderTexture2D
}

Team_Record :: struct {
    color: rl.Color,
    name: string,
    march: [2]i32,
}

Move :: struct {
    attack: bool,
    first_move: bool,
    target: Board_Pos,
    origin: Board_Pos,
    side_effect: proc(game: ^Match, caller: i32),
}

Piece :: struct {

    alive: bool,
    has_moved: bool,
    id: i32,
    position: Board_Pos,
    team: ^Team,
    class: Class,
}

Piece_Record :: struct {
    team: string,
    position: Board_Pos,
    class: Class
}


piece_movement :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    move_count: int
    movement: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int

    switch self.class {

    case .pawn :
        movement = movement_pawn
    case .rook :
        movement = movement_rook
    case .bishop :
        movement = movement_bishop
    case .king: 
        movement = movement_king
    case .queen :
        movement = movement_queen
    case .knight :
        movement = movement_knight
    }

    movement(self, board, moves_buff)
    return move_count

}

movement_king :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    move_count: int

    #unroll for dir in Directions {

        pos := self.position + dir
        tile := board_get_tile(board, pos)

        if tile == nil {

        } else if tile.piece_ref == nil {
            append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = false, target = pos, origin = self.position})
            move_count += 1
        } else if tile.piece_ref.team != self.team {
            append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = true, target = pos, origin = self.position})
            move_count += 1
        }

    }

    #unroll for diag in Diagonals {

        pos := self.position + diag
        tile := board_get_tile(board, pos)

        if tile == nil {

        } else if tile.piece_ref == nil {
            append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = false, target = pos, origin = self.position})
            move_count += 1
        } else if tile.piece_ref.team != self.team {
            append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = true, target = pos, origin = self.position})
            move_count += 1
        }
    }

    //Castleling 
    if !self.has_moved {
        left := self.team.march_direction
        left.x *= -1
        left = left.yx

        right := self.team.march_direction
        right.y *= -1
        right = right.yx

        cur_pos_l := self.position + left
        cur_pos_r := self.position + right

        cur_tile_l := board_get_tile(board, cur_pos_l)
        cur_tile_r := board_get_tile(board, cur_pos_r)

        for (cur_tile_l != nil){

            if cur_tile_l.piece_ref != nil && cur_tile_l.piece_ref.class != .rook do break

                if cur_tile_l.piece_ref != nil && cur_tile_l.piece_ref.class == .rook {
                    if !cur_tile_l.piece_ref.has_moved {

                        target := self.position + (left * 2)
                        if board_get_tile(board, target) == nil do break

                            append(moves_buff, Move{
                                first_move = self.has_moved ? false : true, 
                                attack = false, 
                                target = target,
                                origin = self.position,
                                side_effect = side_effect_castleling
                            })
                        move_count += 1

                        break
                    }

                } 

                cur_pos_l += left

                cur_tile_l = board_get_tile(board, cur_pos_l)
        }

        for (cur_tile_r != nil){

            if cur_tile_r.piece_ref != nil && cur_tile_r.piece_ref.class != .rook do break

                if cur_tile_r.piece_ref != nil && cur_tile_r.piece_ref.class == .rook {
                    if !cur_tile_r.piece_ref.has_moved {

                        target := self.position + (right * 2)
                        if board_get_tile(board, target) == nil do break

                            append(moves_buff, Move{
                                first_move = self.has_moved ? false : true, 
                                attack = false, 
                                target = target,
                                origin = self.position,
                                side_effect = side_effect_castleling
                            })
                        move_count += 1

                        break
                    }

                } 

                cur_pos_r += right
                cur_tile_r = board_get_tile(board, cur_pos_r)
        }


        // for x in self.position.x + 1..<board.size.x {
        //     // fmt.println(x)
        //
        //     pos := board_get_tile(board, {x, self.position.y})
        //     if pos != nil && pos.piece_ref != nil {
        //         if pos.piece_ref.class != .rook {
        //             break
        //         } else {
        //             if !pos.piece_ref.has_moved {
        //                 target := Board_Pos{self.position.x + 2, self.position.y}
        //                 if board_get_tile(board, target) == nil do break
        //
        //                 append(moves_buff, Move{
        //                     attack = false, 
        //                     target = target,
        //                     origin = self.position,
        //                     side_effect = side_effect_castleling
        //                 })
        //                 move_count += 1
        //
        //             }
        //
        //         }
        //
        //     }
        // }
        //
        // for x := self.position.x -1; x >= 0; x -= 1 {
        //     // fmt.println(x)
        //     pos := board_get_tile(board, {x, self.position.y})
        //     if pos != nil && pos.piece_ref != nil {
        //         if pos.piece_ref.class != .rook {
        //             break
        //         } else {
        //             if !pos.piece_ref.has_moved {
        //                 target := Board_Pos{self.position.x - 2, self.position.y}
        //                 if board_get_tile(board, target) == nil do break
        //
        //                 append(moves_buff, Move{
        //                     attack = false, 
        //                     target = target,
        //                     origin = self.position,
        //                     side_effect = side_effect_castleling
        //                 })
        //                 move_count += 1
        //
        //             }
        //
        //         }
        //
        //     }
        //
        // }
    }


    return move_count 

}

side_effect_castleling :: proc(game: ^Match, caller: i32) {

    king := match_get_piece(game, caller)
    distance :f32 = f32(game.board.size.x) * 10
    closest_tower: ^Piece

    for tile in game.board.tiles {

        if tile.piece_ref != nil {
            if target := tile.piece_ref; target.class == .rook && target.team^ == king.team^ {

                if dist := rl.Vector2Distance(Vec2(king.position), Vec2(target.position)); distance > dist {
                    log.debug(dist, target.position)

                    distance = dist
                    closest_tower = target
                }
            }
        }
    }

    if closest_tower != nil {
        king_dir := linalg.vector_normalize(cast([2]f32)king.position - cast([2]f32)closest_tower.position)
        side := cast([2]i32)king_dir

        dest := king.position + side

        piece_move(closest_tower, game, Move{
            first_move = true, 
            attack = false,
            origin = closest_tower.position,
            target = dest,

        })

    }

}

movement_queen :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    return movement_bishop(self, board, moves_buff) + movement_rook(self, board, moves_buff)

}

movement_bishop :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    moves_count: int

    for diag in Diagonals {

        for multipliyer: i32 = 1;; multipliyer += 1 {

            log.debug(self.position + multipliyer * diag)
            tile := board_get_tile(board, self.position + multipliyer * diag)

            if tile == nil do break 

                if tile.piece_ref == nil {
                    append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = false, target = self.position + multipliyer * diag, origin = self.position})
                    moves_count += 1
                } else if tile.piece_ref.team != self.team {
                    append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = true, target = self.position + multipliyer * diag, origin = self.position})
                    moves_count += 1
                    break
                } else {
                    break
                }

            }

        }

        return moves_count

}

movement_knight :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    moves_count :int

    for dir in Directions {

        middle := self.position + dir * 2

        move1 := middle + swizzle(dir, 1, 0)
        move2 := middle - swizzle(dir, 1, 0)

        if tile := board_get_tile(board, move1); tile != nil {

            if tile.piece_ref == nil {
                append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = false, target = move1, origin = self.position})
                moves_count += 1
            } else if tile.piece_ref.team != self.team {
                append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = true, target = move1, origin = self.position})
                moves_count += 1
            }

        }

        if tile := board_get_tile(board, move2); tile != nil {

            if tile.piece_ref == nil {
                append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = false, target = move2, origin = self.position})
                moves_count += 1
            } else if tile.piece_ref.team != self.team {
                append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = true, target = move2, origin = self.position})
                moves_count += 1
            }
        }

    }

    return moves_count
}

movement_rook :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    moves_count :int

    for dir in Directions {

        move := self.position
        walked :int = 1

        for ;;walked += 1{

            move += dir
            tile := board_get_tile(board, move)

            if tile == nil do break

                moves_count += 1

                if tile.piece_ref == nil {
                    append(moves_buff, Move{first_move = self.has_moved ? false : true, attack = false, target = move, origin = self.position})
                } else {
                    if tile.piece_ref.team != self.team {
                        append(moves_buff, Move{ first_move = self.has_moved ? false : true, attack = true, target = move, origin = self.position})
                    }

                    break
                }

            }


        }

        return moves_count
}


movement_pawn :: proc(self: ^Piece, board: ^Board, moves_buff: ^[dynamic; g.MAX_MOVES]Move) -> int {

    moves_count: int

    diagonal_killers : [2]Board_Pos

    switch self.team.march_direction {

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
        log.debug(diag)
        if tile := board_get_tile(board, diag); tile != nil{
            if tile.piece_ref != nil && tile.piece_ref.team != self.team{
                append(moves_buff, Move{first_move = self.has_moved ? false : true,  attack = true, target = diag, origin = self.position})
                moves_count += 1
            }
        }
    }

    move_len := 1 if self.has_moved else 2
    cur_pos := self.position
    for index in 1..=move_len {

        // left := self.team.march_direction
        // left.x *= -1
        // left = swizzle(left, 1, 0)
        //
        // right := self.team.march_direction
        // right.y *= -1
        // right = swizzle(right, 1, 0)

        move := cur_pos + self.team.march_direction
        // move1 := cur_pos + left
        // move2 := cur_pos + right

        tile := board_get_tile(board, move)
        if tile == nil do continue
            if tile.piece_ref != nil do continue

                cur_pos = move
                moves_count += 1
                append(moves_buff, Move{first_move = self.has_moved ? false : true,  attack = false, target = move, origin = self.position})
                // append(moves_buff, Move{ attack = false, target = move1, origin = self.position})
                // append(moves_buff, Move{ attack = false, target = move2, origin = self.position})

    }

    return moves_count

}

make_piece :: proc(class: Class, position: Board_Pos, team: ^Team) -> (piece: Piece) {

    @(static) next_id: i32 = 1

    piece = Piece {
        class = class,
        alive = true,
        has_moved = false,
        team = team,
        position = position,
        id = next_id
    }
    next_id += 1

    return
}

piece_move :: proc(piece: ^Piece, game: ^Match, movement: Move) {

    tile := board_get_tile(&game.board, movement.target)

    if tile == nil do return

        piece.has_moved = true
        piece.position = movement.target

        if tile.piece_ref != nil {
            piece_kill(tile.piece_ref)
            tile.piece_ref = piece
        }

        if movement.side_effect != nil {
            movement.side_effect(game, game.selected_piece.id)
        }

        append(&game.history, movement)
}

piece_kill :: proc(piece: ^Piece) {

    piece.alive = false

}

team_make :: proc(name: string, color: rl.Color, march: [2]i32) -> Team {

    base_spritesheet := ass.asset_man_get_asset("sprite_sheet.png").(rl.Texture2D)
    sprite_image := rl.LoadImageFromTexture(base_spritesheet)
    defer rl.UnloadImage(sprite_image)

    team := Team{
        march_direction = march,
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

team_delete :: proc(team: ^Team) {

    rl.UnloadRenderTexture(team.piece_sprites)
    delete(team.name)
}

piece_promote :: proc(target: ^Piece, new_role: Class) {


    target.class = new_role

}

match_get_piece :: proc(game: ^Match, id: i32) -> ^Piece {

    for &piece in game.pieces {
        if piece.id == id do return &piece
    }

    return nil

}
