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
  final List<List<Color>> _colorLists = [];
  List<Widget> board = [];
  Color mainBoardColor = Colors.blue;
  static Color standardColor = Colors.grey.withOpacity(.3);
  int colorListsSize = 0;
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

  List<List<Color>> get getColorLists => _colorLists;

  setColorLists(List<List<Color>> list) {
    _colorLists.clear();
    _colorLists.addAll(list);
  }

  void updateSize(int inputSize) {
    _boardSize = inputSize;
    notifyListeners();
  }

  void updateDotSize(int size) {
    _dotSize = size;
    notifyListeners();
  }

  void addToUndo(int row, int col, Color color) {
    _undo.add(
      Change(
        _colorLists[row][col],
        () {
          _colorLists[row][col] = color;
          notifyListeners();
        },
        (Color old) {
          _colorLists[row][col] = old;
          notifyListeners();
        },
      ),
    );
  }

  void addGroupToUndo(List<Change> changeList) {
    _undo.addGroup(changeList);
  }

  void undoNotify() {
    notifyListeners();
  }

  void undo() {
    _undo.undo();
    generateBoard(_boardSize, _dotSize);
  }

  void redo() {
    _undo.redo();
    generateBoard(_boardSize, _dotSize);
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
    for (int i = 0; i < _colorLists.length; i++) {
      for (int j = 0; j < _colorLists[i].length; j++) {
        if (!map.containsKey(_colorLists[i][j])) {
          map[_colorLists[i][j]] = 1;
        } else {
          map[_colorLists[i][j]] = map[_colorLists[i][j]]! + 1;
        }
      }
    }
    return map;
  }

  void clearBoard(int boardSize) {
    final List<List<Color>> temp = [];
    for (List<Color> ele in _colorLists) {
      temp.add(ele);
    }
    _undo.add(
      Change(temp, () {
        _colorLists.clear();
        initColorList(boardSize);
        loadBoard(boardToString(), _dotSize);
        notifyListeners();
      }, (List<List<Color>> oldList) {
        for (int i = 0; i < oldList.length; i++) {
          for (int j = 0; j < oldList[i].length; j++) {
            _colorLists[i][j] = oldList[i][j];
          }
        }
        loadBoard(boardToString(), _dotSize);
        notifyListeners();
      }),
    );
    _colorLists.clear();
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

  void loadBoardFromPic(List<Color> cList) {
    int rowLength = sqrt(cList.length).ceil();
    int k = 0;
    for (int row = 0; row < rowLength; row++) {
      for (int col = 0; col < rowLength; col++) {
        _colorLists[row][col] = cList[k++];
      }
    }
    generateBoard(rowLength, _dotSize);
    notifyListeners();
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
