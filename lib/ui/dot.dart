import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';

class Dot extends StatefulWidget {
  Dot({
    Key? key,
    this.size = 0,
    this.color = Colors.white,
    this.row = 0,
    this.col = 0,
  }) : super(key: key);
  final double size;
  Color color;
  final int row;
  final int col;

  @override
  State<Dot> createState() => _DotState();
}

class _DotState extends State<Dot> {
  BoardUtils bu = BoardUtils();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.color == BoardUtils.mainBoardColor) {
          setState(() => widget.color = BoardUtils.standardColor);
          bu.getColorLists[widget.row][widget.col] = BoardUtils.standardColor;
          return;
        }
        setState(() => widget.color = BoardUtils.mainBoardColor);
        bu.getColorLists[widget.row][widget.col] = BoardUtils.mainBoardColor;
      },
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.size),
        ),
      ),
    );
  }
}
