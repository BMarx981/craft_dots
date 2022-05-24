import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:craft_dots/db/db_helper.dart';
import 'package:craft_dots/ui/dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/settings_model.dart';
import '../ui/peg_board_widget.dart';

class BoardUtils extends ChangeNotifier {
  static List<List<Color>> colorLists = [];
  List<Widget> board = [];
  static Color mainBoardColor = Colors.white;
  static Color standardColor = Colors.grey.withOpacity(.3);
  int colorListsSize = 0;
  int _boardSize = 0;
  int _dotSize = 0;

  int get getBoardSize => _boardSize;
  int get getDotSize => _dotSize;

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
    notifyListeners();
  }

  void initColorList(int boardSize, {previousColors}) {
    colorListsSize = boardSize;
    if (colorLists.length == boardSize) {
      mainBoardColor = Colors.white;
    } else {
      for (int i = 0; i < boardSize; i++) {
        List<Color> colors = [];
        for (int j = 0; j < boardSize; j++) {
          colors.add(standardColor);
        }
        colorLists.add(colors);
      }
      mainBoardColor = Colors.white;
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

  List<Widget> genBoard(List<String> list, int dotSize) {
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

  File? _getImageOfBoard(List<String> boardStrings, int boardSize, dotSize) {
    ScreenshotController ssc = ScreenshotController();
    File? file;
    ssc
        .captureFromWidget(
      PegBoardWidget(
          board: genBoard(boardStrings, dotSize),
          boardSize: boardSize,
          dotSize: dotSize),
    )
        .then((image) async {
      file = await _widgetToImageFile(image);
    });
    return file;
  }

  Future<File> _widgetToImageFile(Uint8List capturedImage) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    return await File(path).writeAsBytes(capturedImage);
  }

  Future<void> printBoard(String name) async {
    Map data = await DBHelper.getData(name: name);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Center(child: pw.Text('This should be an image')),
      ),
    );
    List<String> split = data['canvas'].split(' ');
    int len = sqrt(split.length - 1).ceil();
    final file = _getImageOfBoard(data['canvas'], len, data['dotsize']);
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
