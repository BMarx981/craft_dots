import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/edit_utils.dart';

class Dot extends StatefulWidget {
  Dot({
    Key? key,
    this.size = 0,
    required this.color,
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<BoardUtils>(context, listen: false).getFillEnabled) {
          EditUtils.fillFunc(widget.row, widget.col, widget.color, context);
        }
        if (widget.color ==
            Provider.of<BoardUtils>(context, listen: false).mainBoardColor) {
          setState(() => widget.color = BoardUtils.standardColor);
          Provider.of<BoardUtils>(context, listen: false)
              .getColorLists[widget.row][widget.col] = BoardUtils.standardColor;
          return;
        }
        setState(() => widget.color =
            Provider.of<BoardUtils>(context, listen: false).mainBoardColor);
        Provider.of<BoardUtils>(context, listen: false)
                .getColorLists[widget.row][widget.col] =
            Provider.of<BoardUtils>(context, listen: false).mainBoardColor;
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
