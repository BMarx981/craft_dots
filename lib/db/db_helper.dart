import 'dart:io';

import 'package:craft_dots/models/save_model.dart';
import 'package:../sqflite/sqflite.dart';
import 'package:../path_provider/path_provider.dart';

class DBHelper {
  static const _databaseName = "SaveDatabase.db";

  static const table = 'save_canvas';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnCanvas = 'canvas';

  static late Database _database;

  static Future<void> createDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = docDir.path + _databaseName;
    _database = await openDatabase(path);
    await createTable();
  }

  static Future<void> createTable() async {
    await _database.execute(
        'CREATE TABLE IF NOT EXISTS $table ($columnId TEXT, $columnName TEXT, $columnCanvas TEXT)');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    return await _database.insert(table, row);
  }

  static Future<int> save(String name, String data) async {
    Map<String, String> row = {columnName: name, columnCanvas: data};
    return _database.insert(table, row);
  }

  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    List<Map<String, Object?>> response = await _database.query(table);
    print(response);
    return response;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    return await _database.rawQuery('SELECT * FROM $table');
  }

  static Future<String> getData({required String name}) async {
    List<Map> list = await _database
        .rawQuery('SELECT * FROM $table WHERE $columnName = "$name"');
    print(list);
    return list[0]['canvas'];
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
  static Future<int> update(String name, String data) async {
    Map<String, dynamic> row = {columnName: name, columnCanvas: data};
    return await _database.update(table, row);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<void> delete(String name) async {
    await _database.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }

  // Map<String, dynamic> toMap(
  //   String id,
  //   String name,
  // ) {
  //   return {
  //     DBHelper.columnId: id,
  //     DBHelper.columnName: name,
  //     DBHelper.columnCanvas: _processFinalList(),
  //   };
  // }
  //
  // String _processFinalList() {
  //   String str = "";
  //   for (int i = 0; i < saveColorList.length; i++) {
  //     for (int j = 0; j < saveColorList[i].length; j++) {
  //       str += bu.getColorLists[i][j].value.toString() + " ";
  //     }
  //     str += delimiter;
  //   }
  //   return str;
  // }
}
