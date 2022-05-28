import 'dart:math';
import 'dart:typed_data';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/dot.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

import '../ui/peg_board_widget.dart';

class BoardUtils extends ChangeNotifier {
  List<List<Color>> colorLists = [];
  List<Widget> board = [];
  Color mainBoardColor = Colors.white;
  static Color standardColor = Colors.grey.withOpacity(.3);
  int colorListsSize = 0;
  int _boardSize = 0;
  int _dotSize = 0;

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

  int get getBoardSize => _boardSize;
  int get getDotSize => _dotSize;

  void setMainColor(Color color) {
    mainBoardColor = color;
    notifyListeners();
  }

  void addColorToList(Color color) {
    colors.add(color);
    notifyListeners();
  }

  List<List<Color>> get getColorLists => colorLists;

  void generateBoard(int allSize, int dotSize) {
    _boardSize = allSize;
    _dotSize = dotSize;
    if (colorLists.isEmpty) {
      return;
    }
    board.clear();
    for (int row = 0; row < allSize; row++) {
      List<Widget> rows = [];
      for (int col = 0; col < allSize; col++) {
        rows.add(
          Dot(
            size: dotSize.toDouble(),
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
  }

  void initColorList(int boardSize, {previousColors}) {
    colorListsSize = boardSize;
    if (colorLists.length == boardSize) {
      return;
    } else {
      for (int i = 0; i < boardSize; i++) {
        List<Color> colors = [];
        for (int j = 0; j < boardSize; j++) {
          colors.add(standardColor);
        }
        colorLists.add(colors);
      }
      mainBoardColor = Colors.blue;
    }
  }

  String boardToString() {
    String mainString = "";
    for (List<Color> colors in colorLists) {
      for (Color color in colors) {
        mainString += color.value.toString() + " ";
      }
    }
    return mainString;
  }

  void loadBoard(String data, int dotSize) {
    List<String> split = data.split(" ");
    int rowLength = sqrt(split.length - 1).ceil();
    int k = 0;
    for (int i = 0; i < rowLength; i++) {
      for (int j = 0; j < rowLength; j++) {
        colorLists[i][j] = Color(
          int.parse(
            split[k++],
          ),
        );
      }
    }
    generateBoard(
      rowLength,
      dotSize,
    );
    notifyListeners();
  }

  Future<void> printBoard(String name) async {
    Map data = await DBHelper.getData(name: name);
    List<String> split = data['canvas'].split(' ');
    split.removeLast();
    int len = sqrt(split.length - 1).ceil();
    _processImageOfBoard(split, len, data['dotsize']);
  }

  void _processImageOfBoard(List<String> boardStrings, int boardSize, dotSize) {
    ScreenshotController ssc = ScreenshotController();
    Uint8List file;
    ssc
        .captureFromWidget(
      PegBoardWidget(
          board: _genBoard(boardStrings, dotSize),
          boardSize: boardSize,
          dotSize: dotSize),
    )
        .then((image) async {
      await _getImageCallback(image);
    });
  }

  List<Widget> _genBoard(List<String> list, int dotSize) {
    int allSize = sqrt(list.length).ceil();
    List<Widget> localBoard = [];
    for (int row = 0; row < allSize; row++) {
      List<Widget> rows = [];
      for (int col = 0; col < allSize; col++) {
        rows.add(
          Dot(
            size: dotSize.toDouble(),
            row: row,
            col: col,
            color: colorLists[row][col],
          ),
        );
      }
      localBoard.add(Row(
        children: rows,
      ));
    }
    return localBoard;
  }

  _getImageCallback(Uint8List img) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Center(child: pw.Image(pw.MemoryImage(img))),
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Future<File> _widgetToImageFile(Uint8List capturedImage) async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   final ts = DateTime.now().millisecondsSinceEpoch.toString();
  //   String path = '$tempPath/$ts.png';
  //   return await File(path).writeAsBytes(capturedImage);
  // }
}
