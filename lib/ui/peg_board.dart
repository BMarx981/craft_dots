import 'package:flutter/material.dart';

class PegBoard extends StatefulWidget {
  const PegBoard({Key? key}) : super(key: key);

  @override
  _PegBoardState createState() => _PegBoardState();
}

class _PegBoardState extends State<PegBoard> {
  List<List<Color>> colorLists = [];
  Color currentColor = Colors.white;
  int size = 15;

  @override
  void initState() {
    colorLists = List.generate(
        15,
        (i) => List.generate(
              15,
              (_) => Colors.blue,
            ),
        growable: false);
    _generateBoard(size);
    super.initState();
  }

  List<Widget> _generateBoard(int size) {
    List<Widget> board = [];
    for (var row = 0; row < size; row++) {
      List<Widget> rows = List.generate(size, (col) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: _buildADot(
            size: 18,
            color: colorLists[row][col],
            col: col,
            row: row,
          ),
        );
      });
      board.add(Row(children: rows));
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

  List<Widget> _buildColorRow() {
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
    List<Widget> list = [];
    for (var i = 0; i < colors.length; i++) {
      list.add(GestureDetector(
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
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> board = _generateBoard(15);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: board[index],
                );
              },
              itemCount: board.length,
            ),
          ),
          const Divider(thickness: 2),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Selected Color:"),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(color: currentColor),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildColorRow(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
