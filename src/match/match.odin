package match

import ent "../entities"
import rl "vendor:raylib"


Match :: struct {
    selected_piece: ^ent.Piece,
    pieces: []ent.Piece,
    teams: []ent.Team,
    movements: [dynamic]ent.Move,
    board: ent.Board,
    //returns nil when no one won yet
    win_condition: proc(game: ^Match) -> ^ent.Team,
}

last_king_standing_win :: proc(game: ^Match) -> ^ent.Team {

    king_count := 0
    kinger: ^ent.Piece

    for &piece in game.pieces {
        if piece.class == .king {

            king_count += 1
            kinger = &piece
        }

    }

    if king_count != 1 do return nil
    return kinger.team
}

make_normal_match :: proc() -> (game: ^Match) {

    game = new(Match)

    game.board = ent.make_board()
    game.pieces = make([]ent.Piece, game.board.size.x * game.board.size.y)
    game.teams = make([]ent.Team, 2)
    game.movements = make([dynamic]ent.Move)
    game.selected_piece = nil
    game.win_condition = last_king_standing_win

    game.teams[0] = ent.make_team("White", rl.LIGHTGRAY, {0, -1})
    game.teams[1] = ent.make_team("Black", rl.DARKGRAY, {0, 1})

    for i in 0..<8 {
        game.pieces[i] = ent.make_piece(.pawn, {i32(i), 6}, &game.teams[0])
        game.pieces[i + 8] = ent.make_piece(.pawn, {i32(i), 1}, &game.teams[1])
    }

    for i in 0..<2{

        game.pieces[i + 16] = ent.make_piece(.rook, {i32(i * 7), 7}, &game.teams[0])
        game.pieces[i + 18] = ent.make_piece(.rook, {i32(i * 7), 0}, &game.teams[1])
    }

    for i in 0..<2{

        game.pieces[i + 20] = ent.make_piece(.knight, {i32(1 + i * 5), 7}, &game.teams[0])
        game.pieces[i + 22] = ent.make_piece(.knight, {i32(1 + i * 5), 0}, &game.teams[1])
    }

    for i in 0..<2{

        game.pieces[i + 24] = ent.make_piece(.bishop, {i32(2 + i * 3), 7}, &game.teams[0])
        game.pieces[i + 26] = ent.make_piece(.bishop, {i32(2 + i * 3), 0}, &game.teams[1])
    }

    game.pieces[29] = ent.make_piece(.queen, {4, 7}, &game.teams[0])
    game.pieces[30] = ent.make_piece(.queen, {4, 0}, &game.teams[1])

    game.pieces[31] = ent.make_piece(.king, {3, 7}, &game.teams[0])
    game.pieces[32] = ent.make_piece(.king, {3, 0}, &game.teams[1])

    return 
}

delete_match :: proc(match: ^Match) {

    delete(match.pieces)
    delete(match.teams)
    delete(match.movements)
    ent.delete_board(&match.board)
    for &i in match.teams {
        ent.delete_team(&i)
    }
    free(match)


}

update_match :: proc(self: ^Match) {

    winner := self.win_condition(self) 

    if winner != nil {
        winner.score += 1

    }

}
