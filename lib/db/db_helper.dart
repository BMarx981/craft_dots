import 'dart:io';

import 'package:../sqflite/sqflite.dart';
import 'package:../path_provider/path_provider.dart';

class DBHelper {
  static const _databaseName = "SaveDatabase.db";

  static const table = 'save_canvas';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnCanvas = 'canvas';
  static const columnDotSize = 'dotsize';

  static late Database _database;

  static Future<void> createDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = docDir.path + _databaseName;
    _database = await openDatabase(path);
    await createTable();
  }

  static Future<void> createTable() async {
    await _database.execute(
        'CREATE TABLE IF NOT EXISTS $table ($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnCanvas TEXT, $columnDotSize INT)');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    return await _database.insert(table, row);
  }

  static Future<int> saveAs(String name, String data, int dotSize) async {
    Map<String, dynamic> row = {
      columnName: name,
      columnCanvas: data,
      columnDotSize: dotSize
    };
    return _database.insert(table, row);
  }

  static Future<int> save(String name, String data, int dotSize) async {
    Map<String, dynamic> row = {
      columnName: name,
      columnCanvas: data,
      columnDotSize: dotSize
    };
    return _database.update(table, row);
  }

  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    List<Map<String, Object?>> response = await _database.query(table);
    print("Query all rows");
    for (var element in response) {
      print(element['name']);
    }
    return response;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    var li = await _database.rawQuery('SELECT * FROM $table');
    return li;
  }

  static Future<Map> getData({required String name}) async {
    List<Map> list = await _database
        .rawQuery('SELECT * FROM $table WHERE $columnName = "$name"');
    Map<String, dynamic> map = {};
    if (list.isNotEmpty) {
      map = {
        columnCanvas: list[0][columnCanvas],
        columnDotSize: list[0][columnDotSize]
      };
    }
    return map;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static Future<int?> queryRowCount() async {
    return Sqflite.firstIntValue(
        await _database.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //Save resources and avoid memory leaks by closing the database when finished
  // using it.
  static Future<void> closeDB() async {
    await _database.close();
  }

  static Future<void> dropTable() async {
    await _database.rawQuery('DROP TABLE $table');
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  static Future<int> update(String name, String data, int dotSize) async {
    Map<String, dynamic> row = {
      columnName: name,
      columnCanvas: data,
      columnDotSize: dotSize
    };
    return await _database
        .update(table, row, where: '$columnName = ?', whereArgs: [name]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<void> delete(String name) async {
    await _database.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }
}
