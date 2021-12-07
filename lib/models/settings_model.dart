import 'package:flutter/material.dart';

class SM extends ChangeNotifier {
  int _size = 30;
  int _dotSize = 15;

  void updateSize(int inputSize) {
    _size = inputSize;
    notifyListeners();
  }

  void updateDotSize(int size) {
    _dotSize = size;
    notifyListeners();
  }

  int get getSize => _size;
  int get getDotSize => _dotSize;
}
