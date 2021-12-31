import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  List<List<Color>> dbColors = [];
  String dbName = "Dots.db";
  static const int _databaseVersion = 1;

  // make this a singleton class
  DBHelper._init();

  static final DBHelper instance = DBHelper._init();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase('saved.db');
    return _database;
  }

  _initDatabase(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE table savedItems(
      id INTEGER PRIMARY KEY,
      dotBoard TEXT)
    ''');
  }
}
