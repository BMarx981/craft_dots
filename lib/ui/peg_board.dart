import 'package:craft_dots/models/settings_model.dart';
import 'package:craft_dots/models/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class PegBoard extends StatefulWidget {
  const PegBoard({Key? key}) : super(key: key);

  @override
  _PegBoardState createState() => _PegBoardState();
}

class _PegBoardState extends State<PegBoard> {
  List<Widget> board = [];
  Color mainBoardColor = Colors.grey.withOpacity(.3);
  List<List<Color>> colorLists = [];
  Color currentColor = Colors.white;
  int size = 30;
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
  void initState() {
    colorLists = List.generate(
        size,
        (i) => List.generate(
              size,
              (_) => mainBoardColor,
            ),
        growable: false);
    board = _generateBoard(size);
    super.initState();
    // size = Provider.of<SM>(context).getSize;
  }

  // @override
  // void didUpdateWidget(PegBoard oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   print("Size is now: $size");
  //   int s = Provider.of<SM>(context).getSize;
  //   if (s != size) {
  //     print("Old widget size is now: $size");
  //   }
  // }

  List<Widget> _generateBoard(int size) {
    double dotSize = (size / 2);
    List<Widget> board = [];
    for (var row = 0; row < size; row++) {
      List<Widget> rows = List.generate(size, (col) {
        return _buildADot(
          // size: size / 2,
          size: dotSize,
          color: colorLists[row][col],
          col: col,
          row: row,
        );
      });
      board.add(Row(
        children: rows,
      ));
    }
    return board;
  }

  _buildADot(
      {required double size,
      required int row,
      required int col,
      required Color color}) {
    return GestureDetector(
      onTap: () {
        if (colorLists[row][col] == currentColor) {
          colorLists[row][col] = mainBoardColor;
          setState(() {});
          return;
        }
        colorLists[row][col] = currentColor;
        setState(() {});
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

  void changeColor(Color color) {
    colors.add(color);
    setState(() => currentColor = color);
  }

  void showAlert(BuildContext context, Color original) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        setState(() => currentColor = original);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Color Picker"),
      content:
          ColorPicker(pickerColor: currentColor, onColorChanged: changeColor),
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

  List<Widget> _buildColorRow() {
    List<Widget> list = [];
    for (var i = 0; i < colors.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(right: 2.0),
        child: GestureDetector(
          onLongPress: () {
            showAlert(context, currentColor);
          },
          onTap: () {
            setState(() {
              currentColor = colors[i];
            });
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: colors[i]),
          ),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    board = _generateBoard(size);
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                // width: SizeConfig.screenWidth + size * (size / 6),
                width: (size * (size / 2)),
                height: (size * (size / 2)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return board[index];
                  },
                  itemCount: size,
                ),
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
                    decoration: BoxDecoration(color: currentColor),
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
}
