import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/ui/color_row.dart';
import 'package:craft_dots/ui/peg_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/edit_utils.dart';

class PegBoard extends StatelessWidget {
  const PegBoard({Key? key, required this.boardSize, required this.dotSize})
      : super(key: key);

  final int boardSize;
  final int dotSize;

  @override
  Widget build(BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false).initColorList(boardSize);
    Provider.of<BoardUtils>(context, listen: false)
        .generateBoard(boardSize, dotSize);
    bool fill = Provider.of<BoardUtils>(context).getFillEnabled;
    print("Getfillenaabled $fill");
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: fill ? Colors.purpleAccent : Colors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_paint_outlined),
                    onPressed: () {
                      Provider.of<BoardUtils>(context, listen: false)
                          .toggleFillEnabled();
                      print("Fill pressed");
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.check_box_outline_blank_rounded),
                onPressed: () {
                  EditUtils.clearBoard(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.swap_horizontal_circle_outlined),
                onPressed: () {
                  print("Change colors");
                },
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () {
                  print("Undo");
                },
              ),
            ],
          ),
          Expanded(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(8.0),
              minScale: 0.1,
              maxScale: 2.6,
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: PegBoardWidget(
                    board:
                        Provider.of<BoardUtils>(context, listen: false).board,
                    boardSize: boardSize,
                    dotSize: dotSize),
              ),
            ),
          ),
          const Divider(thickness: 2),

          //Selected color bottom piece
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("Selected Color:"),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Provider.of<BoardUtils>(context).mainBoardColor,
                    ),
                  ),
                ],
              ),
              const ColorRow(),
            ],
          )
        ],
      ),
    );
  }
}
