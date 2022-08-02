import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/ui/color_row.dart';
import 'package:craft_dots/ui/peg_board_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/edit_utils.dart';

class PegBoard extends StatelessWidget {
  const PegBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int boardSize = Provider.of<BoardUtils>(context).getBoardSize;
    int dotSize = Provider.of<BoardUtils>(context).getDotSize;
    Provider.of<BoardUtils>(context, listen: false).initColorList(boardSize);
    Provider.of<BoardUtils>(context, listen: false)
        .generateBoard(boardSize, dotSize);
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
                  GestureDetector(
                    child: Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.format_paint_outlined),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Provider.of<BoardUtils>(context).getFillEnabled
                              ? Colors.lightBlue
                              : Colors.transparent),
                    ),
                    onTap: () {
                      Provider.of<BoardUtils>(context, listen: false)
                          .toggleFillEnabled();
                    },
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.swap_horizontal_circle_outlined),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Provider.of<BoardUtils>(context)
                                  .getChangeColorEnabled
                              ? Colors.lightBlue
                              : Colors.transparent),
                    ),
                    onTap: () {
                      Provider.of<BoardUtils>(context, listen: false)
                          .toggleChangeColorEnabled();
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.trash),
                onPressed: () {
                  EditUtils.clearBoard(context);
                },
              ),
              IconButton(
                disabledColor: Colors.grey.withOpacity(.2),
                icon: Provider.of<BoardUtils>(context, listen: false).canUndo
                    ? const Icon(Icons.undo)
                    : Icon(
                        Icons.undo,
                        color: Colors.grey.withOpacity(.4),
                      ),
                onPressed: () {
                  Provider.of<BoardUtils>(context, listen: false).canUndo
                      ? Provider.of<BoardUtils>(context, listen: false).undo()
                      : null;
                },
              ),
              IconButton(
                disabledColor: Colors.grey.shade300,
                icon: Provider.of<BoardUtils>(context, listen: false).canRedo
                    ? const Icon(Icons.redo)
                    : Icon(
                        Icons.redo,
                        color: Colors.grey.withOpacity(.4),
                      ),
                onPressed: () {
                  Provider.of<BoardUtils>(context, listen: false).canRedo
                      ? Provider.of<BoardUtils>(context, listen: false).redo()
                      : null;
                },
              ),
            ],
          ),
          Expanded(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(double.infinity),
              minScale: 0.1,
              maxScale: 8.6,
              clipBehavior: Clip.hardEdge,
              // constrained: false,
              child: Center(
                child: PegBoardWidget(
                    board: Provider.of<BoardUtils>(context).board,
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
