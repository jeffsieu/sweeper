class SweeperGame {
  SweeperGame(this.rows, this.cols, this.mines)
      : assert(rows > 0),
        assert(cols > 0),
        assert(mines < rows * cols) {
    final List<bool> mineLocations =
        List.generate(rows * cols, (index) => index < mines ? true : false)
          ..shuffle();

    final hasMine = (List<bool> mineLocations, int row, int col) {
      final int index = row * cols + col;
      if (index < 0 || index > mineLocations.length - 1) return false;
      return mineLocations[index];
    };

    final getMineCount = (List<bool> mineLocations, int row, int col) {
      if (hasMine(mineLocations, row, col)) {
        return -1;
      }

      int mineCount = 0;
      for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
          if (hasMine(mineLocations, r, c)) {
            mineCount++;
          }
        }
      }
      return mineCount;
    };
    this.map = List.generate(
      rows,
      (row) => List.generate(
        cols,
        (col) {
          int mineCount = getMineCount(mineLocations, row, col);
          if (mineCount == -1) {
            return MineTile();
          } else {
            return FreeTile(mineCount);
          }
        },
      ),
    );
  }

  void openTile(int row, int col) {
    Tile? tile = getTile(row, col);
    if (tile?.isOpen ?? false) return;
    tile?.isOpen = true;
    if (tile is MineTile) {
      // TODO: end game
    } else if (tile is FreeTile) {
      if (tile.mineCount == 0) {
        for (int r = row - 1; r <= row + 1; r++) {
          for (int c = col - 1; c <= col + 1; c++) {
            openTile(r, c);
          }
        }
      }
    }
  }

  Tile? getTile(int row, int col) {
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      return map[row][col];
    }
  }

  final int rows;
  final int cols;
  final int mines;
  late final List<List<Tile>> map;
}

abstract class Tile {
  bool isOpen = false;

  String toDisplayString();
}

class MineTile extends Tile {
  @override
  String toDisplayString() {
    return 'MINE!';
  }
}

class FreeTile extends Tile {
  FreeTile(this.mineCount);

  int mineCount;

  @override
  String toDisplayString() {
    return mineCount > 0 ? mineCount.toString() : '';
  }
}
