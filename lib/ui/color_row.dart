import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:craft_dots/l10n/app_localizations.dart';

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

  List<Widget> _buildColorRow(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < Provider.of<BoardUtils>(context).palette.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: GestureDetector(
            onLongPress: () {
              _showAlert(
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

  void _showAlert(BuildContext context, Color original) {
    final text = AppLocalizations.of(context);
    Color tempColor = original;
    Widget okButton = TextButton(
      child: Text(text!.ok),
      onPressed: () {
        _changeColor(tempColor, context);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = TextButton(
      child: Text(text.cancel),
      onPressed: () {
        Provider.of<BoardUtils>(context, listen: false).setMainColor(original);
        Navigator.pop(context);
      },
    );

    changeTempColor(Color colorTemp) {
      tempColor = colorTemp;
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(text.colorPicker),
      content: ColorPicker(
          pickerAreaBorderRadius: BorderRadius.circular(25),
          pickerColor: original,
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

  void _changeColor(Color color, BuildContext context) {
    Provider.of<BoardUtils>(context, listen: false).addColorToPalette(color);
    Provider.of<BoardUtils>(context, listen: false).setMainColor(color);
  }
}
