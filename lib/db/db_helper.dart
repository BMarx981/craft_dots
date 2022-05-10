import 'dart:io';

import 'package:craft_dots/models/save_model.dart';
import 'package:path/path.dart';
import 'package:../sqflite/sqflite.dart';
import 'package:../path_provider/path_provider.dart';

class DBHelper {
  static const _databaseName = "SaveDatabase.db";
  static const _databaseVersion = 1;

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
        'CREATE TABLE $table ($columnId TEXT, $columnName TEXT, $columnCanvas TEXT)');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY NOT NULL,
            $columnName TEXT NOT NULL,
            $columnCanvas TEXT NOT NULL
          )
          ''');
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
    return await _database.query(table);
  }

  static Future<SaveModel> getData({required String name}) async {
    List<Map> list = await _database
        .rawQuery('SELECT * FROM $table WHERE $columnName = $name');

    return SaveModel(
        name: list[0][columnName], saveColorList: list[0][columnCanvas]);
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
  // Future<int> update(Map<String, dynamic> row) async {
  //
  //   int id = row[columnId];
  //   return await update(table, row, where: '$columnId = ?', whereArgs: [id]);
  // }
  //
  // // Deletes the row specified by the id. The number of affected rows is
  // // returned. This should be 1 as long as the row exists.
  static Future<void> delete(String name) async {
    await _database.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }
}
