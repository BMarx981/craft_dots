import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/models/size_config.dart';
import 'package:craft_dots/ui/color_row.dart';
import 'package:craft_dots/ui/peg_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../models/settings_model.dart';

class PegBoard extends StatelessWidget {
  PegBoard({Key? key}) : super(key: key);

  int boardSize = 0;
  int dotSize = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    boardSize = Provider.of<SettingsModel>(context, listen: false).getSize;
    dotSize = Provider.of<SettingsModel>(context, listen: false).getDotSize;
    Provider.of<BoardUtils>(context, listen: false).initColorList(boardSize);
    Provider.of<BoardUtils>(context, listen: false)
        .generateBoard(boardSize, dotSize);
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              child: PegBoardWidget(
                  board: Provider.of<BoardUtils>(context, listen: false).board,
                  boardSize: boardSize,
                  dotSize: dotSize),
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
                        color: Provider.of<BoardUtils>(context).mainBoardColor),
                  ),
                ],
              ),
              ColorRow(),
            ],
          )
        ],
      ),
    );
  }
}
