import 'dart:io';

import 'package:craft_dots/common/board_utils.dart';
import 'package:craft_dots/db/db_helper.dart';
import 'package:flutter/material.dart';

class SaveModel {
  String? id;
  String name;
  List<List<Color>> saveColorList = [];
  String delimiter = " ";
  BoardUtils bu = BoardUtils();

  SaveModel({this.id, required this.name, required this.saveColorList});

  factory SaveModel.fromMap(Map<String, dynamic> json) {
    List<List<Color>> mainList = [];
    List<String> lineSplit = json[DBHelper.columnCanvas].split(' ');

    for (String line in lineSplit) {
      List<String> listOfColors = line.split(" ");
      List<Color> colors = [];
      for (String element in listOfColors) {
        print(element.toString());
        colors.add(Color(int.parse(element.toString())));
      }
      mainList.add(colors);
      colors.clear();
    }
    return SaveModel(
        name: json[DBHelper.columnName],
        saveColorList: mainList,
        id: json[DBHelper.columnId]);
  }

  Map<String, dynamic> toMap() {
    return {
      DBHelper.columnId: id,
      DBHelper.columnName: name,
      DBHelper.columnCanvas: _processFinalList(),
    };
  }

  String _processFinalList() {
    String str = "";
    for (int i = 0; i < saveColorList.length; i++) {
      for (int j = 0; j < saveColorList[i].length; j++) {
        str += bu.getColorLists[i][j].value.toString() + " ";
      }
      str += delimiter;
    }
    return str;
  }

  List<List<Color>> extractList(String json) {
    List<List<Color>> mainList = [];
    List<String> lineSplit = json.split(delimiter);

    for (String line in lineSplit) {
      List<String> colorStrings = line.split(delimiter);
      List<Color> colors = [];
      for (String color in colorStrings) {
        colors.add(Color(int.parse(color)));
      }
      mainList.add(colors);
      colors.clear();
    }
    return mainList;
  }
}
