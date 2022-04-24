import 'package:craft_dots/ui/dot.dart';
import 'package:flutter/material.dart';

class BoardUtils extends ChangeNotifier {
  static List<List<Color>> colorLists = [];
  List<Widget> board = [];
  static Color mainBoardColor = Colors.white;
  static Color standardColor = Colors.grey.withOpacity(.3);
  int colorListsSize = 0;

  List<List<Color>> get getColorLists => colorLists;

  void generateBoard(int allSize, int dotSize) {
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

  void boardToString() {
    String mainString = "";
    for (List<Color> colors in colorLists) {
      for (Color color in colors) {
        mainString += color.value.toString() + " ";
      }
    }
    print(mainString);
  }
}
