import 'dart:math';

import 'package:craft_dots/ui/dot.dart';
import 'package:flutter/material.dart';

class BoardUtils extends ChangeNotifier {
  static List<List<Color>> colorLists = [];
  List<Widget> board = [];
  static Color mainBoardColor = Colors.white;
  static Color standardColor = Colors.grey.withOpacity(.3);
  int colorListsSize = 0;
  int _dotSize = 0;

  int get getDotSize => _dotSize;

  List<List<Color>> get getColorLists => colorLists;

  void generateBoard(int allSize, int dotSize) {
    _dotSize = _dotSize;
    if (colorLists.isEmpty) {
      return;
    }
    for (int row = 0; row < allSize; row++) {
      List<Widget> rows = [];
      for (int col = 0; col < allSize; col++) {
        rows.add(
          Dot(
            size: dotSize.toDouble(),
            row: row,
            col: col,
            color: colorLists[row][col],
          ),
        );
      }
      board.add(Row(
        children: rows,
      ));
    }
  }

  void initColorList(int boardSize, {previousColors}) {
    colorListsSize = boardSize;
    for (int i = 0; i < boardSize; i++) {
      List<Color> colors = [];
      for (int j = 0; j < boardSize; j++) {
        colors.add(standardColor);
      }
      colorLists.add(colors);
    }
    mainBoardColor = Colors.white;
  }

  String boardToString() {
    String mainString = "";
    for (List<Color> colors in colorLists) {
      for (Color color in colors) {
        mainString += color.value.toString() + " ";
      }
    }
    return mainString;
  }

  void loadBoard(String data) {
    List<String> split = data.split(" ");
    int rowLength = sqrt(split.length - 1).ceil();
    int k = 0;
    for (int i = 0; i < rowLength; i++) {
      for (int j = 0; j < rowLength; j++) {
        colorLists[i][j] = Color(int.parse(split[k++]));
      }
    }
    generateBoard(rowLength, _dotSize);
    notifyListeners();
  }
}
