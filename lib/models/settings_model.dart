import 'package:flutter/material.dart';

class SM extends ChangeNotifier {
  int _size = 30;

  void updateSize(int inputSize) {
    _size = inputSize;
    notifyListeners();
  }

  int get getSize => _size;
}
