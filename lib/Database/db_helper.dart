import 'package:avionics_internal/bloc/manufacturer/manufacturer_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../bloc/home/home_model.dart';


Future<void> printDbPath() async {
  final dbDir = await getDatabasesPath();
  final path  = join(dbDir, 'avionics.db');
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
      CREATE TABLE manufacturers (
        id TEXT PRIMARY KEY,
        company_name TEXT,
        logo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE flights (
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
      CREATE TABLE favourites (
        id TEXT PRIMARY KEY,
        model TEXT,
        logo TEXT
      )
    ''');
  }

  // INSERT METHODS
  static Future<void> insertManufacturers(List<Manufacturer> list) async {
    final db = await database;
    for (var item in list) {
      await db.insert(
        'manufacturers',
        {
          'id': item.id,
          'company_name': item.companyName,
          'logo': item.icon,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> insertFavourites(List<Favourite> list) async {
    final db = await database;
    for (var item in list) {
      await db.insert(
        'favourites',
        {
          'id': item.id,
          'model': item.model,
          'logo': item.logo,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // FETCH METHODS
  static Future<List<Manufacturer>> getManufacturersFromDb() async {
    final db = await database;
    final result = await db.query('manufacturers');
    return result.map((e) => Manufacturer(
      id: e['id'] as String,
      companyName: e['company_name'] as String,
      icon: e['logo'] as String,
    )).toList();
  }

  static Future<List<Favourite>> getFavouritesFromDb() async {
    final db = await database;
    final result = await db.query('favourites');
    return result.map((e) => Favourite(
      id: e['id'] as String,
      model: e['model'] as String,
      logo: e['logo'] as String,
    )).toList();
  }
}
