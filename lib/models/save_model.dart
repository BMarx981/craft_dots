import 'dart:io';

import 'package:craft_dots/common/board_utils.dart';
import 'package:flutter/material.dart';

class SaveModel {
  String? id;
  String name;
  List<List<Color>> finalList = [];
  static String delimiter = ",|";
  static String lineDelimiter = "??||";

  SaveModel({this.id, required this.name, required this.finalList});

  factory SaveModel.fromMap(Map<String, dynamic> json) {
    List<List<Color>> mainList = [];
    List<String> lineSplit = json['finalList'].split(lineDelimiter);

    for (String line in lineSplit) {
      List<String> list = line.split(delimiter);
      List<Color> colors = [];
      for (String element in list) {
        print(element.toString());
        colors.add(Color(int.parse(element.toString())));
      }
      mainList.add(colors);
      colors.clear();
    }
    return SaveModel(name: json['name'], finalList: mainList, id: json['id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'finalList': _processFinalList(),
    };
  }

  String _processFinalList() {
    String str = "";
    for (int i = 0; i < finalList.length; i++) {
      for (int j = 0; j < finalList[i].length; j++) {
        str += finalList[i].elementAt(j).toString();
        str += delimiter;
        print(str);
      }
      str += lineDelimiter;
    }
    return str;
  }

  List<List<Color>> extractList(String json) {
    List<List<Color>> mainList = [];
    List<String> lineSplit = json.split(lineDelimiter);

    for (String line in lineSplit) {
      List<String> list = line.split(delimiter);
      List<Color> colors = [];
      for (String element in list) {
        print(element.toString());
        colors.add(Color(int.parse(element.toString())));
      }
      mainList.add(colors);
      colors.clear();
    }
    return mainList;
  }
}
