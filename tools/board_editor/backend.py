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
    wizard = 7
    cop = 8
    archer = 9
    clown = 10
    devil = 11
    angel = 12

class BoardPos:
    x: int
    y: int

    def __init__(self, x = 0, y = 0):
        self.x = x
        self.y = y

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
                "class": self.role.name
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
    size: List[int]
    teams: List[Team]

    def __init__(self, size = [0, 0]):
        self.size = size
        self.pieces = []
        self.teams = []

    def load_from_json(self, json_data: dict):
        self.size = json_data["board_size"]
        # print(self.size)
        self.pieces = [Piece(p["position"], p["team"], Roles[p["class"]]) for p in json_data["pieces"]]
        # print(self.pieces)
        self.teams = [Team(t.get("color"), t.get("name"), t.get("march")) for t in json_data.get("teams")]
        # print(self.teams)

        return self

    def get_dict(self):
        return {
            "pieces": [pi.get_dict() for pi in self.pieces],
            "board_size": self.size,
            "teams": [te.__dict__ for te in self.teams],
        }

    def save_to_file(self, filepath):

        try:
            with open(filepath, "w") as file:
                json.dump(self.get_dict(), file, indent= 2)
                print("saved")
        except Exception as err:
            print(f"The error {err} has ocurred")

if __name__ == "__main__":

    test_board = Board((8,8))
    test_board.pieces.append(Piece((1, 1), "White", Roles.king))
    test_board.teams.append(Team((1, 1, 1, 255), "White", (0, 1)))

    print(test_board.get_dict())

    test_board.save_to_file("smol.json")

    with open("smol.json", "r") as file:
        data = json.load(file)
        # print(data)
        smol_board = Board().load_from_json(data)
        print(smol_board.get_dict())

