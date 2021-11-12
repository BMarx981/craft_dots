import 'package:flutter/material.dart';

class DotLists with ChangeNotifier {
  List<List<Color>> colorList = [[]];

  DotLists();

  DotLists.generate(int size) {
    colorList = List.generate(
        size + 1, (i) => List.filled(size + 1, Colors.blue, growable: false),
        growable: false);
    // for (int row = 0; row < size; row++) {
    //   for (int col = 0; col < size; col++) {
    //     colorList.
    //   }
    // }
    print(colorList.first.first);
  }

  void updateList(int row, int col, Color color) {
    colorList[row][col] = color;
    notifyListeners();
  }
}
