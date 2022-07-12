import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/settings_model.dart';

class EditUtils {
  static void fillFunc(int row, int col, Color color, BuildContext context) {
    final ob = Provider.of<BoardUtils>(context, listen: false).getColorLists;
    final sc = BoardUtils.standardColor;
    fillHelper(row, col, color, ob, sc);
    Provider.of<BoardUtils>(context, listen: false).rebuildBoard();
  }

  static void fillHelper(
      int row, int col, Color color, List<List<Color>> board, Color sc) {
    if (row < 0 || col < 0 || row >= board.length || col >= board[row].length) {
      return;
    }
    if (board[row][col] != sc) {
      return;
    }
    board[row][col] = color;
    fillHelper(row + 1, col, color, board, sc);
    fillHelper(row - 1, col, color, board, sc);
    fillHelper(row, col + 1, color, board, sc);
    fillHelper(row, col - 1, color, board, sc);
  }

  static void clearBoard(BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false)
        .clearBoard(Provider.of<SettingsModel>(context, listen: false).getSize);
  }

  static void changeColorFill(
      int row, int col, Color current, BuildContext context) {
    Color selected =
        Provider.of<BoardUtils>(context, listen: false).mainBoardColor;
    changeColorHelper(
      row,
      col,
      current,
      selected,
      Provider.of<BoardUtils>(context, listen: false).getColorLists,
    );
    Provider.of<BoardUtils>(context, listen: false).rebuildBoard();
  }

  static void changeColorHelper(int row, int col, Color current, Color selected,
      List<List<Color>> board) {
    if (row < 0 || col < 0 || row >= board.length || col >= board[row].length) {
      return;
    }
    if (board[row][col] != current) {
      return;
    }
    board[row][col] = selected;
    changeColorHelper(row + 1, col, current, selected, board);
    changeColorHelper(row - 1, col, current, selected, board);
    changeColorHelper(row, col + 1, current, selected, board);
    changeColorHelper(row, col - 1, current, selected, board);
  }
}