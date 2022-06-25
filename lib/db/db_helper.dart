import 'dart:async';
import 'dart:io';

import 'package:../sqflite/sqflite.dart';
import 'package:../path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  static const _databaseName = "SaveDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'save_canvas';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnCanvas = 'canvas';
  static const columnDotSize = 'dotsize';

  static Database? _database;

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Future<void> createDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = docDir.path + _databaseName;
    _database = await openDatabase(path);
    await createTable();
  }

  static Future createTable() async {
    Database? db = await instance.database;
    await _database?.execute('''CREATE TABLE IF NOT EXISTS $table 
        ($columnId INTEGER PRIMARY KEY, 
        $columnName TEXT, 
        $columnCanvas TEXT, 
        $columnDotSize INT)''');
  }

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          'CREATE TABLE IF NOT EXISTS $table '
        '($columnId INTEGER PRIMARY KEY, '
        '$columnName TEXT, '
        '$columnCanvas TEXT, '
        '$columnDotSize INT)'
          ''');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  static Future<int> saveAs(String name, String data, int dotSize) async {
    Database? db = await instance.database;
    Map<String, dynamic> row = {
      columnName: name,
      columnCanvas: data,
      columnDotSize: dotSize
    };
    return db!.insert(table, row);
  }

  static Future<int> save(String name, String data, int dotSize) async {
    Database? db = await instance.database;
    Map<String, dynamic> row = {
      columnName: name,
      columnCanvas: data,
      columnDotSize: dotSize
    };
    return db!.update(table, row);
  }

  static Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    List<Map<String, Object?>> response = await db!.query(table);
    return response;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    Database? db = await instance.database;
    var li = await db!.rawQuery('SELECT * FROM $table');
    return li;
  }

  static Future<Map> getData({required String name}) async {
    final db = await instance.database;
    final list =
        await db?.rawQuery('SELECT * FROM $table WHERE $columnName = "$name"');
    Map<String, dynamic> map = {};
    if (list!.isNotEmpty) {
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
    final db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //Save resources and avoid memory leaks by closing the database when finished
  // using it.
  static Future<void> closeDB() async {
    final db = await instance.database;
    await db!.close();
  }

  static Future<void> dropTable() async {
    final db = await instance.database;
    await db!.rawQuery('DROP TABLE $table');
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  static Future<int> update(String name, String data, int dotSize) async {
    final db = await instance.database;
    Map<String, dynamic> row = {
      columnName: name,
      columnCanvas: data,
      columnDotSize: dotSize
    };
    return await db!
        .update(table, row, where: '$columnName = ?', whereArgs: [name]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  static Future<void> delete(String name) async {
    final db = await instance.database;
    await db!.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }
}
