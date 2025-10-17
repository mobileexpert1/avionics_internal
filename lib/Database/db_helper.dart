import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> printDbPath() async {
  if (kIsWeb) {
    debugPrint('Skipping DB path print on web.');
    return;
  }
  final dbDir = await getDatabasesPath();
  debugPrint('DB path ➜ ${join(dbDir, DBHelper._dbName)}');
}

class DBHelper {
  static const _dbName = 'avionics.db';
  static const _dbVersion = 2;

  static Database? _db;

  static Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on web.');
    }
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    debugPrint('Opening avionics DB at: $path');

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _createUserIdIndices(db);
  }

  static Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      for (final t in _tables) {
        await db.execute('ALTER TABLE $t ADD COLUMN user_id TEXT;');
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_${t}_user ON $t(user_id);',
        );
      }
    }
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE manufacturers (
        id TEXT PRIMARY KEY,
        company_name TEXT,
        logo TEXT,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE flights (
        id TEXT PRIMARY KEY,
        model TEXT,
        code TEXT,
        company_name TEXT,
        image TEXT,
        logo TEXT,
        flight_id TEXT,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE favourites (
        id TEXT PRIMARY KEY,
        model TEXT,
        logo TEXT,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE user_details (
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
        is_active_subscription INTEGER,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE glossary (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE unit_prefs (
        id TEXT PRIMARY KEY,
        unit TEXT,
        is_selected INTEGER,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE user_profile (
        id TEXT PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        email TEXT,
        phone_number TEXT,
        user_type TEXT,
        auth_type TEXT,
        is_active INTEGER,
        is_active_subscription INTEGER,
        professional_role TEXT,
        experience_level TEXT,
        country_code TEXT,
        profile_image TEXT,
        gender TEXT,
        dob TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        zip_code TEXT,
        country TEXT,
        user_id TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        author TEXT,
        text TEXT,
        session_id TEXT,
        user_id TEXT
      );
    ''');

    await db.execute('''
    CREATE TABLE selected_aircraft (
      id TEXT PRIMARY KEY,
      aircraftModel TEXT,
      manufacturerName TEXT,
      user_id TEXT,
      icaoTypeCode TEXT,
      isFavorite INTEGER,
      image TEXT
    );
  ''');

  }

  static Future<void> _createUserIdIndices(Database db) async {
    for (final t in _tables) {
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_${t}_user ON $t(user_id);',
      );
    }
  }

  static const List<String> _tables = [
    'manufacturers',
    'flights',
    'favourites',
    'user_details',
    'glossary',
    'unit_prefs',
    'user_profile',
    'chat_messages',
    'selected_aircraft'
  ];

  /* ── CRUD methods ── */

  Future<int> insert(
      String table,
      Map<String, dynamic> values, {
        ConflictAlgorithm algo = ConflictAlgorithm.abort,
      }) async {
    if (kIsWeb) return 0;
    return (await database).insert(table, values, conflictAlgorithm: algo);
  }

  Future<List<Map<String, Object?>>> get(
      String table, {
        String? where,
        List<Object?>? whereArgs,
        String? orderBy,
      }) async {
    if (kIsWeb) return [];
    return (await database).query(
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
    if (kIsWeb) return 0;
    return (await database).update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
      String table, {
        required String where,
        required List<Object?> whereArgs,
      }) async {
    if (kIsWeb) return 0;
    return (await database).delete(table, where: where, whereArgs: whereArgs);
  }
}



abstract class BaseModel {
  String? userId;
  String get table;
  String get id;
  Map<String, dynamic> toMap();
}
