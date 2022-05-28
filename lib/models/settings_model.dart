import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  int _size = 29;
  int _dotSize = 11;

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
