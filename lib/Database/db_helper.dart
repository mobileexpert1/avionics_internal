import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> printDbPath() async {
  final dbDir = await getDatabasesPath();
  final path = join(dbDir, 'avionics.db');
  debugPrint('DB path ➜ $path');
}

class DBHelper {
  static Database? _db;

  // Get DB instance
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Init DB
  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'avionics.db');
    debugPrint('Opening avionics DB at: $path');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create tables
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS manufacturers (
        id TEXT PRIMARY KEY,
        company_name TEXT,
        logo TEXT
      )
    ''');

    await db.execute('''
       CREATE TABLE IF NOT EXISTS flights (
        id TEXT PRIMARY KEY,
        model TEXT,
        code TEXT,
        company_name TEXT,
        image TEXT,
        logo TEXT,
        flight_id TEXT
      )
    ''');

    await db.execute('''
     CREATE TABLE IF NOT EXISTS favourites (
        id TEXT PRIMARY KEY,
        model TEXT,
        logo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_details (
        id TEXT PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        email TEXT,
        phone_number TEXT,
        professional_role TEXT,
        experience_level TEXT,
        user_type TEXT,
        auth_type TEXT,
        is_active INTEGER,
        is_active_subscription INTEGER
      );
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS glossary (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT
      );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS unit_prefs (
        id TEXT PRIMARY KEY,     
        unit TEXT,
        is_selected INTEGER
    );
    ''');
  }

  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    ConflictAlgorithm algo = ConflictAlgorithm.abort,
  }) async {
    final db = await database;
    return db.insert(table, values, conflictAlgorithm: algo);
  }

  Future<List<Map<String, Object?>>> get(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }
}

abstract class BaseModel {
  String get table;
  String get id;
  Map<String, dynamic> toMap();
}
