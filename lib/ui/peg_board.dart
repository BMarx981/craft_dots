import 'package:craft_dots/models/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PegBoard extends StatefulWidget {
  final int boardSize;
  final int dotSize;
  PegBoard({required this.boardSize, required this.dotSize, Key? key})
      : super(key: key);

  @override
  _PegBoardState createState() => _PegBoardState();
}

class _PegBoardState extends State<PegBoard> {
  List<Widget> board = [];
  Color mainBoardColor = Colors.grey.withOpacity(.3);
  List<List<Color>> colorLists = [];
  Color currentColor = Colors.white;
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
    board = _generateBoard(widget.boardSize);
    super.initState();
  }

  List<Widget> _generateBoard(int allSize) {
    double dotSize = widget.dotSize.toDouble();
    List<Widget> board = [];
    if (colorLists.length < allSize) {
      colorLists = _buildColorList();
    }

    for (int row = 0; row < allSize; row++) {
      List<Widget> rows = [];
      for (int col = 0; col < allSize; col++) {
        rows.add(
          _buildADot(
            size: dotSize,
            row: row,
            col: col,
            color: colorLists[row][col],
          ),
        );
      }
      board.add(Row(
        children: rows,
      ));
    }
    return board;
  }

  List<List<Color>> _buildColorList({previousColors}) {
    List<List<Color>> mainList = [];
    for (int i = 0; i < widget.boardSize; i++) {
      List<Color> list = [];
      for (int j = 0; j < widget.boardSize; j++) {
        list.add(mainBoardColor);
      }
      mainList.add(list);
    }
    return mainList;
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
    board = _generateBoard(widget.boardSize);
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: (widget.boardSize * widget.dotSize).toDouble(),
                height: (widget.boardSize * widget.dotSize).toDouble(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return board[index];
                  },
                  itemCount: widget.boardSize,
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

  void showAlert(BuildContext context, Color original) {
    Color tempColor = currentColor;
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        changeColor(tempColor);
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

    changeTempColor(Color colorTemp) {
      tempColor = colorTemp;
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Color Picker"),
      content: ColorPicker(
          pickerColor: currentColor, onColorChanged: changeTempColor),
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
