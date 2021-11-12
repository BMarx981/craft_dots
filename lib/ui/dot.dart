import 'package:craft_dots/models/dot_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dot extends StatelessWidget {
  Dot({
    Key? key,
    this.size = 0,
    this.color = Colors.white,
    this.row = 0,
    this.col = 0,
    required this.callback,
  }) : super(key: key);
  double size;
  Color color;
  int row;
  int col;
  Function callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<DotLists>(context, listen: false)
            .updateList(row, col, color);
        print("Callback called? $row $col ${color}");
        callback;
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}
