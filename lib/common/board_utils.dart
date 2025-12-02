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
import 'package:undo/undo.dart';

import '../ui/peg_board_widget.dart';

class BoardUtils extends ChangeNotifier {
  List<List<Color>> colorLists = [];
  List<Widget> board = [];
  Color mainBoardColor = Colors.blue;
  static Color standardColor = Colors.grey.withAlpha(77);
  int _boardSize = 29;
  int _dotSize = 11;
  bool _isFillEnabled = false;
  bool _isChangeColorEnabled = false;
  final ChangeStack _undo = ChangeStack(limit: 200);

  List<Color> palette = [
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

  bool get canUndo => _undo.canUndo;
  bool get canRedo => _undo.canRedo;

  List<List<Color>> get getColorLists => colorLists;

  setColorLists(List<List<Color>> list) {
    colorLists.clear();
    colorLists.addAll(list);
  }

  void updateSize(int inputSize) {
    _boardSize = inputSize;
    board = [];
    colorLists.clear();

    initColorList(_boardSize);
    generateBoard(_boardSize, _dotSize);
    notifyListeners();
  }

  void updateDotSize(int size) {
    _dotSize = size;
    board = [];
    colorLists.clear();

    initColorList(_boardSize);
    generateBoard(_boardSize, _dotSize);
    notifyListeners();
  }

  void addToUndo(int row, int col, Color color) {
    _undo.add(
      Change(
        colorLists[row][col],
        () {
          colorLists[row][col] = color;
          notifyListeners();
        },
        (Color old) {
          colorLists[row][col] = old;
          notifyListeners();
        },
      ),
    );
  }

  void addSingleChangeForGroup(
      List<Map<String, dynamic>> undoData, List<List<Color>> board) {
    _undo.add(
      Change<List<Map<String, dynamic>>>(
        undoData,
        () {
          for (var cell in undoData) {
            int r = cell['row'] as int;
            int c = cell['col'] as int;
            Color newColor = cell['newColor'] as Color;
            colorLists[r][c] = newColor;
          }
          rebuildBoard();
        },
        (List<Map<String, dynamic>> data) {
          for (var cell in data) {
            int r = cell['row'] as int;
            int c = cell['col'] as int;
            Color oldColor = cell['oldColor'] as Color;
            colorLists[r][c] = oldColor;
          }
          rebuildBoard();
          return data;
        },
      ),
    );
  }

  void addGroupToUndo(List<Change<Color>> changeList) {
    _undo.addGroup(changeList);
  }

  void undoNotify() {
    notifyListeners();
  }

  void undo() {
    if (_undo.canUndo) {
      _undo.undo();
      rebuildBoard();
    }
  }

  void redo() {
    if (_undo.canRedo) {
      _undo.redo();
      rebuildBoard();
    }
  }

  void clearUndoHistory() {
    _undo.clearHistory();
  }

  bool get getFillEnabled => _isFillEnabled;
  void toggleFillEnabled() {
    _isFillEnabled = !_isFillEnabled;
    if (_isChangeColorEnabled) {
      _isChangeColorEnabled = !_isChangeColorEnabled;
    }
    notifyListeners();
  }

  bool get getChangeColorEnabled => _isChangeColorEnabled;
  void toggleChangeColorEnabled() {
    _isChangeColorEnabled = !_isChangeColorEnabled;
    if (_isFillEnabled) {
      _isFillEnabled = !_isFillEnabled;
    }
    notifyListeners();
  }

  void setMainColor(Color color) {
    mainBoardColor = color;
    notifyListeners();
  }

  void addColorToPalette(Color color) {
    palette.add(color);
    notifyListeners();
  }

  Map<Color, int> getColorCount() {
    Map<Color, int> map = {};
    for (int i = 0; i < colorLists.length; i++) {
      for (int j = 0; j < colorLists[i].length; j++) {
        if (!map.containsKey(colorLists[i][j])) {
          map[colorLists[i][j]] = 1;
        } else {
          map[colorLists[i][j]] = map[colorLists[i][j]]! + 1;
        }
      }
    }
    return map;
  }

  void clearBoard(int boardSize) {
    final List<List<Color>> temp = [];
    for (List<Color> ele in colorLists) {
      temp.add(ele);
    }
    _undo.add(
      Change(temp, () {
        colorLists.clear();
        initColorList(boardSize);
        loadBoard(boardToString(), _dotSize);
        notifyListeners();
      }, (List<List<Color>> oldList) {
        for (int i = 0; i < oldList.length; i++) {
          for (int j = 0; j < oldList[i].length; j++) {
            colorLists[i][j] = oldList[i][j];
          }
        }
        loadBoard(boardToString(), _dotSize);
        notifyListeners();
      }),
    );
    colorLists.clear();
    initColorList(boardSize);
    loadBoard(boardToString(), _dotSize);
    notifyListeners();
  }

  void rebuildBoard() {
    loadBoard(boardToString(), _dotSize);
    notifyListeners();
  }

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

  void initColorList(int boardSize) {
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

  void loadBoardFromPic(List<Color> cList) {
    int rowLength = sqrt(cList.length).ceil();
    int k = 0;
    for (int row = 0; row < rowLength; row++) {
      for (int col = 0; col < rowLength; col++) {
        colorLists[row][col] = cList[k++];
      }
    }
    generateBoard(rowLength, _dotSize);
    notifyListeners();
  }

  void loadBoard(String data, int dotSize) {
    List<String> split = data.split(" ");
    int rowLength = sqrt(split.length - 1).ceil();
    List<List<Color>> tempRow = [];
    int k = 0;
    for (int i = 0; i < rowLength; i++) {
      List<Color> tempCol = [];
      for (int j = 0; j < rowLength; j++) {
        tempCol.add(Color(
          int.parse(
            split[k++],
          ),
        ));
      }
      tempRow.add(tempCol);
    }
    colorLists = tempRow;
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
    String? canvas = data['canvas'];
    if (canvas == null) throw (Exception());
    List<String> split = canvas.split(" ");
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
