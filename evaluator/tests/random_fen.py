import random
import json

def random_board_fen():
    pieces = ['r','n','b','q','k','p','R','N','B','Q','K','P']
    board = []
    for _ in range(8):
        row = []
        empty = 0
        for _ in range(8):
            if random.random() < 0.25:  # 25% chance of a piece
                if empty > 0:
                    row.append(str(empty))
                    empty = 0
                row.append(random.choice(pieces))
            else:
                empty += 1
        if empty > 0:
            row.append(str(empty))
        board.append(''.join(row))
    return '/'.join(board)

def random_fen():
    board_fen = random_board_fen()
    color = random.choice(['w','b'])
    castling = ''.join(c for c in 'KQkq' if random.random() < 0.5) or '-'
    en_passant = random.choice(['-','a3','b3','c3','d3','e3','f3','g3','h3',
                                'a6','b6','c6','d6','e6','f6','g6','h6'])
    halfmove = str(random.randint(0, 50))
    fullmove = str(random.randint(1, 40))
    return f"{board_fen} {color} {castling} {en_passant} {halfmove} {fullmove}"

# Generate 50 random FENs as JSON objects
for _ in range(50):
    fen = random_fen()
    print(json.dumps({"fen": fen}))
