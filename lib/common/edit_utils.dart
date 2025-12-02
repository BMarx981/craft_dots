import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undo/undo.dart';

class EditUtils {
  static void fillFunc(int row, int col, Color color, BuildContext context) {
    final board = Provider.of<BoardUtils>(context, listen: false).getColorLists;
    final targetColor = board[row][col];

    if (targetColor == color) return;

    List<Change<Color>> changeList = [];
    Set<String> visited = {};

    fillHelper(
        row, col, color, targetColor, board, context, changeList, visited);

    if (changeList.isNotEmpty) {
      Provider.of<BoardUtils>(context, listen: false)
          .addGroupToUndo(changeList);
      Provider.of<BoardUtils>(context, listen: false).rebuildBoard();
    }
  }

  static void fillHelper(
    int row,
    int col,
    Color newColor,
    Color targetColor,
    List<List<Color>> board,
    BuildContext bc,
    List<Change<Color>> cl,
    Set<String> visited,
  ) {
    if (row < 0 || col < 0 || row >= board.length || col >= board[row].length) {
      return;
    }

    String key = '$row,$col';
    if (visited.contains(key)) {
      return;
    }

    if (board[row][col] != targetColor) {
      return;
    }

    visited.add(key);

    final capturedRow = row;
    final capturedCol = col;
    final oldColor = board[row][col];

    cl.add(Change(
      oldColor,
      () {
        board[capturedRow][capturedCol] = newColor;
        Provider.of<BoardUtils>(bc, listen: false).undoNotify();
      },
      (old) {
        board[capturedRow][capturedCol] = old;
        Provider.of<BoardUtils>(bc, listen: false).undoNotify();
        return old;
      },
    ));

    board[row][col] = newColor;

    fillHelper(row + 1, col, newColor, targetColor, board, bc, cl, visited);
    fillHelper(row - 1, col, newColor, targetColor, board, bc, cl, visited);
    fillHelper(row, col + 1, newColor, targetColor, board, bc, cl, visited);
    fillHelper(row, col - 1, newColor, targetColor, board, bc, cl, visited);
  }

  static void clearBoard(BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false).clearBoard(
        Provider.of<BoardUtils>(context, listen: false).getBoardSize);
  }

  static void changeColorFill(
      int row, int col, Color current, BuildContext context) {
    Color selected =
        Provider.of<BoardUtils>(context, listen: false).mainBoardColor;

    if (current == selected) return;

    List<Change<Color>> changeList = [];
    Set<String> visited = {};

    changeColorHelper(
      row,
      col,
      current,
      selected,
      Provider.of<BoardUtils>(context, listen: false).getColorLists,
      context,
      changeList,
      visited,
    );

    if (changeList.isNotEmpty) {
      Provider.of<BoardUtils>(context, listen: false)
          .addGroupToUndo(changeList);
      Provider.of<BoardUtils>(context, listen: false).rebuildBoard();
    }
  }

  static void changeColorHelper(
    int row,
    int col,
    Color targetColor,
    Color newColor,
    List<List<Color>> board,
    BuildContext bc,
    List<Change<Color>> cl,
    Set<String> visited,
  ) {
    if (row < 0 || col < 0 || row >= board.length || col >= board[row].length) {
      return;
    }

    String key = '$row,$col';
    if (visited.contains(key)) {
      return;
    }

    if (board[row][col] != targetColor) {
      return;
    }

    visited.add(key);

    final capturedRow = row;
    final capturedCol = col;
    final oldColor = board[row][col];

    cl.add(Change(
      oldColor,
      () {
        board[capturedRow][capturedCol] = newColor;
        Provider.of<BoardUtils>(bc, listen: false).undoNotify();
      },
      (old) {
        board[capturedRow][capturedCol] = old;
        Provider.of<BoardUtils>(bc, listen: false).undoNotify();
        return old;
      },
    ));

    board[row][col] = newColor;

    changeColorHelper(
        row + 1, col, targetColor, newColor, board, bc, cl, visited);
    changeColorHelper(
        row - 1, col, targetColor, newColor, board, bc, cl, visited);
    changeColorHelper(
        row, col + 1, targetColor, newColor, board, bc, cl, visited);
    changeColorHelper(
        row, col - 1, targetColor, newColor, board, bc, cl, visited);
  }
}
