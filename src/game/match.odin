package game

import rl "vendor:raylib"


Match :: struct {
    selected_piece: ^Piece,
    pieces: []Piece,
    teams: []Team,
    curr_turn: int,
    movements: [dynamic]Move,
    board: Board,
    //returns nil when no one won yet
    win_condition: proc(game: ^Match) -> ^Team,
}

last_king_standing_win :: proc(game: ^Match) -> ^Team {

    king_count := 0
    kinger: ^Piece

    for &piece in game.pieces {
        if piece.class == .king && piece.alive{

            king_count += 1
            kinger = &piece
        }

    }

    if king_count != 1 do return nil
    return kinger.team
}

make_normal_match :: proc() -> (game: ^Match) {

    game = new(Match)

    game.board = make_board()
    game.pieces = make([]Piece, 32)
    game.teams = make([]Team, 2)
    game.movements = make([dynamic]Move)
    game.selected_piece = nil
    game.win_condition = last_king_standing_win

    game.teams[0] = make_team("White", rl.LIGHTGRAY, {0, -1})
    game.teams[1] = make_team("Black", rl.DARKGRAY, {0, 1})

    populate_normal_formation(game.pieces[:], &game.teams[0], &game.teams[1])

    return 
}

populate_normal_formation :: proc(pieces_bank: []Piece, team1, team2: ^Team) {

    assert(len(pieces_bank) >= 32, "insuficient space for this formation")


    for i in 0..<8 {
        pieces_bank[i] = make_piece(.pawn, {i32(i), 6}, team1)
        pieces_bank[i + 8] = make_piece(.pawn, {i32(i), 1}, team2)
    }

    for i in 0..<2{

        pieces_bank[i + 16] = make_piece(.rook, {i32(i * 7), 7}, team1)
        pieces_bank[i + 18] = make_piece(.rook, {i32(i * 7), 0}, team2)
    }

    for i in 0..<2{

        pieces_bank[i + 20] = make_piece(.knight, {i32(1 + i * 5), 7}, team1)
        pieces_bank[i + 22] = make_piece(.knight, {i32(1 + i * 5), 0}, team2)
    }

    for i in 0..<2{

        pieces_bank[i + 24] = make_piece(.bishop, {i32(2 + i * 3), 7}, team1)
        pieces_bank[i + 26] = make_piece(.bishop, {i32(2 + i * 3), 0}, team2)
    }

    pieces_bank[28] = make_piece(.queen, {4, 7}, team1)
    pieces_bank[29] = make_piece(.queen, {4, 0}, team2)

    pieces_bank[30] = make_piece(.king, {3, 7}, team1)
    pieces_bank[31] = make_piece(.king, {3, 0}, team2)

}

reset_normal_match :: proc(self: ^Match) {

    populate_normal_formation(self.pieces[:], &self.teams[0], &self.teams[1])
    clear(&self.movements)
    self.selected_piece = nil
    self.curr_turn = 0
}

delete_match :: proc(match: ^Match) {

    delete(match.pieces)
    delete(match.teams)
    delete(match.movements)
    delete_board(&match.board)
    for &i in match.teams {
        delete_team(&i)
    }
    free(match)


}

update_match :: proc(self: ^Match) {

    winner := self.win_condition(self) 

    if winner != nil {
        winner.score += 1
        reset_normal_match(self)
    }

}

end_turn :: proc(self: ^Match) {

    self.curr_turn += 1 

    if self.curr_turn >= len(self.teams) do self.curr_turn = 0 
    if self.curr_turn < 0 do self.curr_turn = 0

}

get_team_turn :: proc(self: ^Match) -> ^Team {

    assert(self.curr_turn >= 0 && self.curr_turn < len(self.teams), "the team index in the current turn is out of sync with the array")

    return &self.teams[self.curr_turn]

}
