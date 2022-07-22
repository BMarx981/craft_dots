import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undo/undo.dart';

import '../models/settings_model.dart';

class EditUtils {
  static void fillFunc(int row, int col, Color color, BuildContext context) {
    final ob = Provider.of<BoardUtils>(context, listen: false).getColorLists;
    final sc = BoardUtils.standardColor;
    List<Change> changeList = [];
    fillHelper(row, col, color, ob, sc, context, changeList);
    Provider.of<BoardUtils>(context, listen: false).addGroupToUndo(changeList);
    Provider.of<BoardUtils>(context, listen: false).rebuildBoard();
  }

  static void fillHelper(int row, int col, Color color, List<List<Color>> board,
      Color sc, BuildContext bc, List<Change> cl) {
    if (row < 0 ||
        col < 0 ||
        row > board.length - 1 ||
        col > board[row].length - 1) {
      return;
    }
    if (board[row][col] != sc) {
      return;
    }
    cl.add(Change(board[row][col], () {
      board[row][col] = color;
      Provider.of<BoardUtils>(bc, listen: false).undoNotify();
    }, (oldColor) {
      board[row][col] = oldColor;
      Provider.of<BoardUtils>(bc, listen: false).undoNotify();
    }));

    board[row][col] = color;
    fillHelper(row + 1, col, color, board, sc, bc, cl);
    fillHelper(row - 1, col, color, board, sc, bc, cl);
    fillHelper(row, col + 1, color, board, sc, bc, cl);
    fillHelper(row, col - 1, color, board, sc, bc, cl);
  }

  static void clearBoard(BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false)
        .clearBoard(Provider.of<SettingsModel>(context, listen: false).getSize);
  }

  static void changeColorFill(
      int row, int col, Color current, BuildContext context) {
    Color selected =
        Provider.of<BoardUtils>(context, listen: false).mainBoardColor;
    List<Change> changeList = [];
    changeColorHelper(
        row,
        col,
        current,
        selected,
        Provider.of<BoardUtils>(context, listen: false).getColorLists,
        context,
        changeList);
    Provider.of<BoardUtils>(context, listen: false).addGroupToUndo(changeList);
    Provider.of<BoardUtils>(context, listen: false).rebuildBoard();
  }

  static void changeColorHelper(int row, int col, Color current, Color selected,
      List<List<Color>> board, BuildContext bc, List<Change> cl) {
    if (row < 0 ||
        col < 0 ||
        row > board.length - 1 ||
        col > board[row].length - 1) {
      return;
    }
    if (board[row][col] != current) {
      return;
    }

    cl.add(Change(board[row][col], () {
      board[row][col] = selected;
      Provider.of<BoardUtils>(bc, listen: false).undoNotify();
    }, (oldColor) {
      board[row][col] = oldColor;
      Provider.of<BoardUtils>(bc, listen: false).undoNotify();
    }));

    board[row][col] = selected;
    changeColorHelper(row + 1, col, current, selected, board, bc, cl);
    changeColorHelper(row - 1, col, current, selected, board, bc, cl);
    changeColorHelper(row, col + 1, current, selected, board, bc, cl);
    changeColorHelper(row, col - 1, current, selected, board, bc, cl);
  }
}
