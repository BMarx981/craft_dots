import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/dot.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

import '../ui/peg_board_widget.dart';

class BoardUtils extends ChangeNotifier {
  final List<List<Color>> _colorLists = [];
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
  List<List<Color>> get getColorList => _colorLists;

  void setMainColor(Color color) {
    mainBoardColor = color;
    notifyListeners();
  }

  void addColorToList(Color color) {
    colors.add(color);
    notifyListeners();
  }

  List<List<Color>> get getColorLists => _colorLists;

  void generateBoard(int allSize, int dotSize) {
    _boardSize = allSize;
    _dotSize = dotSize;
    if (_colorLists.isEmpty) {
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
            color: _colorLists[row][col],
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
    if (_colorLists.length == boardSize) {
      return;
    } else {
      for (int i = 0; i < boardSize; i++) {
        List<Color> colors = [];
        for (int j = 0; j < boardSize; j++) {
          colors.add(standardColor);
        }
        _colorLists.add(colors);
      }
      mainBoardColor = Colors.blue;
    }
  }

  String boardToString() {
    String mainString = "";
    for (List<Color> colors in _colorLists) {
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
        _colorLists[i][j] = Color(
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

  //************ Gets the image into the save item widget *******//
  Future<File> displayBoardImage(String name) async {
    final db = DBHelper.instance;
    Map data = await db.getData(name: name);
    List<String> split = data['canvas'].split(" ");
    split.removeLast();
    int len = sqrt(split.length - 1).ceil();
    return await _processBoardImage(split, len, data['dotsize']);
  }

  Future<File> _processBoardImage(
      List<String> boardStrings, int boardSize, dotSize) {
    ScreenshotController ssc = ScreenshotController();
    Future<Uint8List> image = ssc.captureFromWidget(PegBoardWidget(
      board: _genBoard(boardStrings, dotSize),
      boardSize: boardSize,
      dotSize: dotSize,
    ));

    Future<File> f = _widgetToImageFile(image);
    return f;
  }

  Future<File> _widgetToImageFile(Future<Uint8List> capturedImage) async {
    Uint8List cp = await capturedImage;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    File completed = await File(path).writeAsBytes(cp);
    return completed;
  }
  //****************** end save image image gen******************//

  //*******Prints the board to a printer ************************//
  Future printBoard(String name) async {
    final db = DBHelper.instance;
    Map data = await db.getData(name: name);
    List<String> split = data['canvas'].split(' ');
    split.removeLast();
    int len = sqrt(split.length - 1).ceil();
    _processImageOfBoard(split, len, data['dotsize']);
  }

  Future _processImageOfBoard(
      List<String> boardStrings, int boardSize, dotSize) async {
    ScreenshotController ssc = ScreenshotController();
    return await ssc
        .captureFromWidget(
      PegBoardWidget(
          board: _genBoard(boardStrings, dotSize),
          boardSize: boardSize,
          dotSize: dotSize),
    )
        .then((image) async {
      await _getPDFImageCallback(image);
    });
  }

  List<Widget> _genBoard(List<String> list, int dotSize) {
    int allSize = sqrt(list.length).ceil();
    List<List<Color>> localColors = [];
    int index = 0;
    for (int row = 0; row < allSize; row++) {
      List<Color> colColors = [];
      for (int col = 0; col < allSize; col++) {
        colColors.add(
          Color(
            int.parse(list[index++]),
          ),
        );
      }
      localColors.add(colColors);
    }
    List<Widget> localBoard = [];
    for (int row = 0; row < allSize; row++) {
      List<Widget> rows = [];
      for (int col = 0; col < allSize; col++) {
        rows.add(
          Dot(
            size: dotSize.toDouble(),
            row: row,
            col: col,
            color: localColors[row][col],
          ),
        );
      }
      localBoard.add(Row(
        children: rows,
      ));
    }
    return localBoard;
  }

  Future _getPDFImageCallback(Uint8List img) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              width: 440,
              child: pw.Image(
                pw.MemoryImage(img),
              ),
            )
          ],
        ),
      ),
    );
    return await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
