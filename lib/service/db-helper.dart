
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secrets/model/group.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  final uuid = Uuid();

  static final _databaseName = "secrets.db";
  static final _databaseVersion = 1;

  static final table = 'groups';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnKey = 'key';
  static final columnIv = 'iv';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    print('init db');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    // var databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, _databaseName);
    // Delete the database
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnKey TEXT NOT NULL,
            $columnIv TEXT NOT NULL
          )
          ''');
    await db.insert(table, Group.newGroup('Only Me').getValueMap());
    print('done');
  }

  Future<int> insert(Group group) async {
    Database db = await instance.database;
    return await db.insert(table, group.getValueMap());
  }

  Future<List<Group>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(table);
    List<Group> groups = List();
    results.forEach((element) {
      groups.add(Group.fromValueMap(element));
    });
    return groups;
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Group group) async {
    Database db = await instance.database;
    return await db.update(table, group.getValueMap(), where: '$columnId = ?', whereArgs: [group.id]);
  }

  Future<int> delete(Group group) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [group.id]);
  }

  Future<Group> get(String id) async {
    Database db = await instance.database;
    final List results = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Group.fromValueMap(results.first);
    } else {
      return null;
    }
  }
}