import 'package:flutter/material.dart';

class DotLists with ChangeNotifier {
  List<List<Color>> colorList = [[]];

  DotLists();

  DotLists.generate(int size) {
    colorList = List.generate(
        size + 1, (i) => List.filled(size + 1, Colors.blue, growable: false),
        growable: false);
  }

  void updateList(int row, int col, Color color) {
    colorList[row][col] = color;
    notifyListeners();
  }
}
