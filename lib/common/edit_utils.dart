import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undo/undo.dart';

class EditUtils {
  static void fillFunc(int row, int col, Color color, BuildContext context) {
    final boardUtils = Provider.of<BoardUtils>(context, listen: false);
    final board = boardUtils.getColorLists;
    final targetColor = board[row][col];

    if (targetColor == color) return;

    List<Map<String, dynamic>> cellsToChange = [];
    Set<String> visited = {};

    collectCells(row, col, targetColor, board, cellsToChange, visited);

    if (cellsToChange.isEmpty) return;

    List<Map<String, dynamic>> undoData = cellsToChange
        .map((cell) => {
              'row': cell['row'],
              'col': cell['col'],
              'oldColor': cell['oldColor'],
              'newColor': color,
            })
        .toList();

    boardUtils.addSingleChangeForGroup(undoData, board);

    for (var cell in cellsToChange) {
      board[cell['row'] as int][cell['col'] as int] = color;
    }

    boardUtils.rebuildBoard();
  }

  static void changeColorFill(
      int row, int col, Color current, BuildContext context) {
    final boardUtils = Provider.of<BoardUtils>(context, listen: false);
    final board = boardUtils.getColorLists;
    final selected = boardUtils.mainBoardColor;

    if (current == selected) return;

    List<Map<String, dynamic>> cellsToChange = [];
    Set<String> visited = {};

    collectCells(row, col, current, board, cellsToChange, visited);

    if (cellsToChange.isEmpty) return;

    List<Map<String, dynamic>> undoData = cellsToChange
        .map((cell) => {
              'row': cell['row'],
              'col': cell['col'],
              'oldColor': cell['oldColor'],
              'newColor': selected,
            })
        .toList();

    boardUtils.addSingleChangeForGroup(undoData, board);

    for (var cell in cellsToChange) {
      board[cell['row'] as int][cell['col'] as int] = selected;
    }

    boardUtils.rebuildBoard();
  }

  static void collectCells(
    int row,
    int col,
    Color targetColor,
    List<List<Color>> board,
    List<Map<String, dynamic>> cells,
    Set<String> visited,
  ) {
    if (row < 0 || col < 0 || row >= board.length || col >= board[row].length) {
      return;
    }

    String key = '$row,$col';
    if (visited.contains(key)) return;
    if (board[row][col] != targetColor) return;

    visited.add(key);
    cells.add({'row': row, 'col': col, 'oldColor': board[row][col]});

    collectCells(row + 1, col, targetColor, board, cells, visited);
    collectCells(row - 1, col, targetColor, board, cells, visited);
    collectCells(row, col + 1, targetColor, board, cells, visited);
    collectCells(row, col - 1, targetColor, board, cells, visited);
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
