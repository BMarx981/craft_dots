import 'package:craft_dots/models/settings_model.dart';
import 'package:craft_dots/models/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class PegBoard extends StatefulWidget {
  final int boardSize;
  PegBoard({required this.boardSize, Key? key}) : super(key: key);

  @override
  _PegBoardState createState() => _PegBoardState();
}

class _PegBoardState extends State<PegBoard> {
  List<Widget> board = [];
  Color mainBoardColor = Colors.grey.withOpacity(.3);
  List<List<Color>> colorLists = [];
  Color currentColor = Colors.white;
  final int _dotSize = 30;
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
    colorLists = _buildColorList();
    board = _generateBoard();
    super.initState();
  }

  List<Widget> _generateBoard() {
    int allSize = Provider.of<SM>(context, listen: false).getSize;
    double dotSize = (_dotSize / 2);
    List<Widget> board = [];
    for (var row = 0; row < allSize; row++) {
      List<Widget> rows = List.generate(allSize, (col) {
        return _buildADot(
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

  List<List<Color>> _buildColorList() {
    List<List<Color>> list = [];
    if (colorLists.isNotEmpty) {
      print("Colorlists $colorLists");
      int rem =
          (colorLists.length - Provider.of<SM>(context, listen: false).getSize)
              .abs();
      print("REM $rem");
      for (int i = widget.boardSize; i < rem; i++) {
        List<Color> newList = [];
        for (int j = colorLists.length; j < rem; j++) {
          newList[j] = mainBoardColor;
        }
        list.add(newList);
      }
      return list;
    }
    return List.generate(
      widget.boardSize,
      (i) => List.generate(
        widget.boardSize,
        (_) => mainBoardColor,
      ),
    );
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
    board = _generateBoard();
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: (_dotSize * (_dotSize / 2)),
                height: (_dotSize * (_dotSize / 2)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return board[index];
                  },
                  itemCount: Provider.of<SM>(context).getSize,
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
