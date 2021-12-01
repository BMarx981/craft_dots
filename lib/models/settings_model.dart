import 'package:flutter/material.dart';

class SM extends ChangeNotifier {
  int _size = 30;

  void updateSize(int size) {
    _size = size;
    notifyListeners();
  }

  int get getSize => _size;
}
