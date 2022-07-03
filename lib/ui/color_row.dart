import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../common/board_utils.dart';

class ColorRow extends StatelessWidget {
  const ColorRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _buildColorRow(context),
        ),
      ),
    );
  }

  void _changeColor(Color color, BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false).palette.add(color);
    Provider.of<BoardUtils>(context, listen: false).setMainColor(color);
  }

  List<Widget> _buildColorRow(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0;
        i < Provider.of<BoardUtils>(context, listen: false).palette.length;
        i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: GestureDetector(
            onLongPress: () {
              showAlert(
                  context,
                  Provider.of<BoardUtils>(context, listen: false)
                      .mainBoardColor);
            },
            onTap: () {
              Provider.of<BoardUtils>(context, listen: false).setMainColor(
                  Provider.of<BoardUtils>(context, listen: false).palette[i]);
              Provider.of<BoardUtils>(context, listen: false).palette[i];
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Provider.of<BoardUtils>(context, listen: false)
                      .palette[i]),
            ),
          ),
        ),
      );
    }
    return list;
  }

  void showAlert(BuildContext context, Color original) {
    Color tempColor =
        Provider.of<BoardUtils>(context, listen: false).mainBoardColor;
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        _changeColor(tempColor, context);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Provider.of<BoardUtils>(context, listen: false).setMainColor(original);
        Navigator.pop(context);
      },
    );

    changeTempColor(Color colorTemp) {
      Provider.of<BoardUtils>(context, listen: false)
          .addColorToPalette(colorTemp);
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Color Picker"),
      content: ColorPicker(
          pickerColor:
              Provider.of<BoardUtils>(context, listen: false).mainBoardColor,
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
