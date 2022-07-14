import 'package:flutter/material.dart';

class Undo {
  final List<UndoEvent> events = [];
  final UndoEvent event = UndoEvent(row: 0, col: 0, color: Colors.white);
}

class UndoEvent {
  final int row;
  final int col;
  final Color color;

  UndoEvent({required this.row, required this.col, required this.color});
}
