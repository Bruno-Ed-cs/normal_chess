from enum import Enum
from typing import Tuple, List
import json


class Roles(Enum):
    pawn = 1
    rook = 2
    bishop = 3
    king = 4
    queen = 5
    knight = 6


class Piece:
    position: Tuple[int, int]
    team: str
    role: Roles

    def __init__(self, position, team, role):
        self.position = position
        self.team = team
        self.role = role

    def get_dict(self):
        return {
                "position": self.position,
                "team": self.team,
                "class": self.role.value
        }


class Team:
    color: Tuple[int, int, int, int]
    name: str
    march: Tuple[int, int]

    def __init__(self, color, name, march):
        self.color = color
        self.name = name
        self.march = march

class Board:
    pieces: List[Piece]
    board_size: int[2]
    teams: List[Team]

    def __init__(self, size: int[2]):
        self.board_size = size
        self.pieces = []
        self.teams = []

    def get_dict(self):
        return {
            "pieces": [pi.get_dict() for pi in self.pieces],
            "board_size": self.board_size,
            "teams": [te.__dict__ for te in self.teams],
        }

if __name__ == "__main__":

    test_board = Board((8,8))
    test_board.pieces.append(Piece((1, 1), "White", Roles.king))
    test_board.teams.append(Team((1, 1, 1, 255), "White", (0, 1)))

    print(test_board.get_dict())

    with open("mini.json", "w") as file:
        json.dump(test_board.get_dict(), file, indent=2)
        print("success")
