package match

import ent "../entities"
import rl "vendor:raylib"

Match :: struct {
    selected_piece: ^ent.Piece,
    pieces: []ent.Piece,
    teams: []ent.Team,
    movements: [dynamic]ent.Move,
    board: ent.Board,
}

make_normal_match :: proc(textures: ^map[string]rl.Texture2D) -> (game: ^Match) {


    game = new(Match)

    game.board = ent.make_board()
    game.pieces = make([]ent.Piece, game.board.size.x * game.board.size.y)
    game.teams = make([]ent.Team, 2)
    game.movements = make([dynamic]ent.Move)
    game.selected_piece = nil

    game.teams[0] = ent.Team{
        color = rl.WHITE,
        name = "white",
        score = 0
    }

    game.teams[1] = ent.Team{
        color = rl.BLACK,
        name = "black",
        score = 0
    }


    for i in 0..<8 {
        game.pieces[i] = ent.make_pawn(textures["pawn"], {i32(i), 6}, &game.teams[0])
    }
    game.pieces[8] = ent.make_pawn(textures["pawn"], {3, 4}, &game.teams[0])
    game.pieces[9] = ent.make_pawn(textures["pawn"], {5, 5}, &game.teams[0])


    return 
}

delete_match :: proc(match: ^Match) {

    delete(match.pieces)
    delete(match.teams)
    delete(match.movements)
    ent.delete_board(&match.board)

}
