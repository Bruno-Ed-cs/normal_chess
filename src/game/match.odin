package game

import rl "vendor:raylib"
import g "../globals"
import "core:encoding/json"
import "core:mem"
import "core:log"
import "core:os"
import str "core:strings"

Match :: struct {
    selected_piece: ^Piece,
    pieces: [dynamic; g.MAX_PIECES]Piece,
    original_formation: []Piece_Record,
    teams: []Team,
    curr_turn: int,
    movements: [dynamic; g.MAX_MOVES]Move,
    board: Board,
    //returns nil when no one won yet
    win_condition: proc(game: ^Match) -> ^Team,
}

Match_Record :: struct {
    pieces: []Piece_Record,
    board_size: [2]i32,
    teams: []Team_Record
}


record_normal_match :: proc(game: ^Match) {

    record: Match_Record
    record.board_size = game.board.size
    pieces: [32]Piece_Record
    teams: [2]Team_Record

    for team, i in game.teams {

        teams[i] = Team_Record {
            march = team.march_direction,
            name = team.name,
            color = team.color

        }


    }

    record.teams = teams[:]

    for piece, i in game.pieces {

        pieces[i] = Piece_Record {
            class = piece.class,
            position = piece.position,
            team = piece.team.name

        }

    }

    record.pieces = pieces[:]

    json_data, jerr := json.marshal(record, {pretty = true, indentation = 1, use_enum_names = true})
    if jerr != nil {
        log.error(jerr)
        return
    }

    
    _ = os.write_entire_file("standard.json", json_data)
}

match_win_rule_last_king_standing :: proc(game: ^Match) -> ^Team {

    if len(game.teams) < 2 do return nil

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

// the path is relative to the executable
match_make_from_file :: proc(filepath: string) -> ^Match {

    file, ferr := os.read_entire_file(filepath, context.allocator)
    defer if ferr == nil do delete(file)
    if ferr != nil {

        log.fatal("Error loading board", ferr)
        file = #load("../../assets/boards/standard.json")

    } 


    match_data: Match_Record
    uerr := json.unmarshal(file, &match_data, allocator = context.temp_allocator)
    if uerr != nil {
        log.fatal("Error unmarshaling", uerr, file)
        return nil

    }


    match := new(Match)

    match.board = board_make(match_data.board_size)
    match.win_condition = match_win_rule_last_king_standing

    teams := make([dynamic]Team)

    for team in match_data.teams {

        append(&teams, team_make(str.clone(team.name), team.color, team.march))
    }

    match.teams = teams[:]

    populate_formation(match_data.pieces, match.teams[:], &match.pieces)

    match.original_formation = make([]Piece_Record, len(match_data.pieces))

    copy(match.original_formation, match_data.pieces)
    for &piece in match.original_formation {

        for &team in match.teams {
            if piece.team == team.name {
                piece.team = team.name
            }

        }

    }

    return match


}

populate_formation :: proc(pieces: []Piece_Record, teams: []Team, dest: ^[dynamic; g.MAX_PIECES]Piece) {

    for piece in pieces {

        for &team in teams {
            if piece.team == team.name {
                append(dest, make_piece(piece.class, piece.position, &team))
            }

        }

    }

}

// make_normal_match :: proc() -> (game: ^Match) {
//
//     game = new(Match)
//
//     game.board = make_board()
//     game.teams = make([]Team, 2)
//     game.selected_piece = nil
//     game.win_condition = last_king_standing_win
//
//     game.teams[0] = make_team("White", rl.LIGHTGRAY, {0, -1})
//     game.teams[1] = make_team("Black", rl.DARKGRAY, {0, 1})
//
//     populate_normal_formation(&game.pieces, &game.teams[0], &game.teams[1])
//
//     return 
// }

// populate_normal_formation :: proc(pieces_bank: ^[dynamic; g.max_pieces]Piece, team1, team2: ^Team) {
//
//     for i in 0..<8 {
//         append(pieces_bank, make_piece(.pawn, {i32(i), 6}, team1))
//         append(pieces_bank, make_piece(.pawn, {i32(i), 1}, team2))
//     }
//
//     for i in 0..<2{
//
//         append(pieces_bank, make_piece(.rook, {i32(i * 7), 7}, team1))
//         append(pieces_bank, make_piece(.rook, {i32(i * 7), 0}, team2))
//     }
//
//     for i in 0..<2{
//
//         append(pieces_bank, make_piece(.knight, {i32(1 + i * 5), 7}, team1))
//         append(pieces_bank, make_piece(.knight, {i32(1 + i * 5), 0}, team2))
//     }
//
//     for i in 0..<2{
//
//         append(pieces_bank, make_piece(.bishop, {i32(2 + i * 3), 7}, team1))
//         append(pieces_bank, make_piece(.bishop, {i32(2 + i * 3), 0}, team2))
//     }
//
//     append(pieces_bank, make_piece(.queen, {4, 7}, team1) )
//     append(pieces_bank, make_piece(.queen, {4, 0}, team2) )
//
//     append(pieces_bank, make_piece(.king, {3, 7}, team1))
//     append(pieces_bank, make_piece(.king, {3, 0}, team2))
//
// }

match_reset :: proc(self: ^Match) {

    clear(&self.pieces)
    populate_formation(self.original_formation, self.teams, &self.pieces)
    log.debug(self.pieces)
    clear(&self.movements)
    self.selected_piece = nil
    self.curr_turn = 0
}

match_delete :: proc(match: ^Match) {

    delete(match.teams)
    board_delete(&match.board)
    delete(match.original_formation)
    for &i in match.teams {
        team_delete(&i)
    }
    free(match)


}

match_update :: proc(self: ^Match) {

    winner := self.win_condition(self) 

    if winner != nil {
        winner.score += 1

        match_reset(self)
    }

}

match_end_turn :: proc(self: ^Match) {

    self.curr_turn += 1 

    if self.curr_turn >= len(self.teams) do self.curr_turn = 0 
    if self.curr_turn < 0 do self.curr_turn = 0

}

match_get_cur_turn_team :: proc(self: ^Match) -> ^Team {

    assert(self.curr_turn >= 0 && self.curr_turn < len(self.teams), "the team index in the current turn is out of sync with the array")

    return &self.teams[self.curr_turn]

}
