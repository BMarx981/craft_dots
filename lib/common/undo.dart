import 'package:flutter/material.dart';

import 'board_utils.dart';

class Undo {
  BoardUtils bu = BoardUtils();
  final List<UndoEvent> events = [];

  List<UndoEvent> eventsStack = [];

  void add(UndoEvent event) {
    eventsStack.add(event);
  }

  void undo() {
    UndoEvent event = eventsStack.last;

    bu.getColorLists[event.row][event.col] = event.color;
    eventsStack.removeLast();
  }
}

class UndoEvent {
  final int row;
  final int col;
  final Color color;

  UndoEvent({required this.row, required this.col, required this.color});
}
