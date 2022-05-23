import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/models/size_config.dart';
import 'package:craft_dots/ui/peg_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../models/settings_model.dart';

class PegBoard extends StatefulWidget {
  const PegBoard({Key? key}) : super(key: key);

  @override
  _PegBoardState createState() => _PegBoardState();
}

class _PegBoardState extends State<PegBoard> {
  int boardSize = 0;
  int dotSize = 0;
  List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.brown,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.yellow,
    Colors.pink,
    Colors.red,
    Colors.grey,
  ];

  @override
  void didChangeDependencies() {
    boardSize = Provider.of<SettingsModel>(context).getSize;
    dotSize = Provider.of<SettingsModel>(context).getDotSize;
    // Provider.of<BoardUtils>(context, listen: false).initColorList(boardSize);
    Provider.of<BoardUtils>(context, listen: false)
        .generateBoard(boardSize, dotSize);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              child: PegBoardWidget(
                  board: Provider.of<BoardUtils>(context).board,
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
                    decoration: BoxDecoration(color: BoardUtils.mainBoardColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildColorRow(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    colors.add(color);
    setState(() => BoardUtils.mainBoardColor = color);
  }

  List<Widget> _buildColorRow() {
    List<Widget> list = [];
    for (int i = 0; i < colors.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: GestureDetector(
            onLongPress: () {
              showAlert(context, BoardUtils.mainBoardColor);
            },
            onTap: () {
              setState(() {
                BoardUtils.mainBoardColor = colors[i];
              });
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: colors[i]),
            ),
          ),
        ),
      );
    }
    return list;
  }

  void showAlert(BuildContext context, Color original) {
    Color tempColor = BoardUtils.mainBoardColor;
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        _changeColor(tempColor);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        setState(() => BoardUtils.mainBoardColor = original);
        Navigator.pop(context);
      },
    );

    changeTempColor(Color colorTemp) {
      tempColor = colorTemp;
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Color Picker"),
      content: ColorPicker(
          pickerColor: BoardUtils.mainBoardColor,
          onColorChanged: changeTempColor),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
