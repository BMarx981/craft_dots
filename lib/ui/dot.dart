import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/edit_utils.dart';

class Dot extends StatefulWidget {
  const Dot({
    Key? key,
    this.size = 0,
    required this.color,
    this.row = 0,
    this.col = 0,
  }) : super(key: key);
  final double size;
  final Color color;
  final int row;
  final int col;

  @override
  State<Dot> createState() => _DotState();
}

class _DotState extends State<Dot> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    color = widget.color;
    return GestureDetector(
      onTap: () {
        Color main =
            Provider.of<BoardUtils>(context, listen: false).mainBoardColor;
        if (Provider.of<BoardUtils>(context, listen: false).getFillEnabled) {
          Provider.of<BoardUtils>(context, listen: false)
              .addToUndo(widget.row, widget.col, BoardUtils.standardColor);
          EditUtils.fillFunc(widget.row, widget.col, main, context);
          setState(() {});
          return;
        }
        if (Provider.of<BoardUtils>(context, listen: false)
            .getChangeColorEnabled) {
          EditUtils.changeColorFill(widget.row, widget.col, color, context);
          setState(() {});
          return;
        }
        if (color == main) {
          setState(() => color = BoardUtils.standardColor);
          Provider.of<BoardUtils>(context, listen: false)
              .addToUndo(widget.row, widget.col, BoardUtils.standardColor);
          Provider.of<BoardUtils>(context, listen: false)
              .getColorLists[widget.row][widget.col] = BoardUtils.standardColor;

          return;
        }
        setState(() => color = main);
        Provider.of<BoardUtils>(context, listen: false)
            .addToUndo(widget.row, widget.col, color);
        Provider.of<BoardUtils>(context, listen: false)
            .getColorLists[widget.row][widget.col] = main;
      },
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.size),
        ),
      ),
    );
  }
}
