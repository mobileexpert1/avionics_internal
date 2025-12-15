import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'auth_storage.dart';   // ❶ new: stores current user id in SharedPreferences
import 'db_helper.dart';

typedef FromMap<T> = T Function(Map<String, dynamic> row);

class GenericMethods<T extends BaseModel> {
  GenericMethods(this._fromMap);

  final FromMap<T> _fromMap;
  final DBHelper _db = DBHelper();

    /* ───────────────── INSERT ───────────────── */
    Future<void> insertAll(
        List<T> items, {
          ConflictAlgorithm algo = ConflictAlgorithm.replace,
        }) async {
      final uid = await AuthStorage.read();
      if (uid == null) throw Exception('No current user id set');

      for (final item in items) {
        item.userId = uid;
        await _db.insert(item.table, item.toMap(), algo: algo);
      }
    }

  /* ───────────────── SELECT ───────────────── */
  Future<List<T>> getAll(String table) async {
    final uid = await AuthStorage.read();
    if (uid == null) return [];               // not logged in yet

    final rows = await _db.get(
      table,
      where: 'user_id = ?',
      whereArgs: [uid],
    );
    return rows.map(_fromMap).toList();
  }

  Future<T?> getById(String table, String id) async {
    final uid = await AuthStorage.read();
    final rows = await _db.get(
      table,
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, uid],
    );
    return rows.isEmpty ? null : _fromMap(rows.first);
  }

  /* ───────────────── UPDATE ───────────────── */
  Future<int> update(T item) async {
    final uid = await AuthStorage.read();
    item.userId = uid;                        // keep row consistent
    return _db.update(
      item.table,
      item.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [item.id, uid],
    );
  }

  /* ───────────────── DELETE ───────────────── */
  Future<int> deleteById(String table, String id) async {
    final uid = await AuthStorage.read();
    return _db.delete(
      table,
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, uid],
    );
  }

  /* ───────────────── CONNECTIVITY ─────────── */
  static Future<bool> hasInternet({
    List<String> lookupHosts = const ['google.com', 'cloudflare.com'],
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    for (final host in lookupHosts) {
      try {
        final lookup = await InternetAddress.lookup(host).timeout(timeout);
        if (lookup.isNotEmpty) return true;
      } catch (_) {/* ignore & try next host */}
    }
    return false;
  }

  Future<List<T>> getBySession(String table, String sessionId) async {
    final uid = await AuthStorage.read();
    if (uid == null) return [];

    final rows = await _db.get(
      table,
      where: 'session_id = ? AND user_id = ?',
      whereArgs: [sessionId, uid],
    );
    return rows.map(_fromMap).toList();
  }

  Future<int> deleteBySessionId(String table, String sessionId) async {
    final uid = await AuthStorage.read();
    return _db.delete(
      table,
      where: 'session_id = ? AND user_id = ?',
      whereArgs: [sessionId, uid],
    );
  }

  Future<void> insertChatMessageSafe(T item) async {
    final uid = await AuthStorage.read();
    if (uid == null) return;

    item.userId = uid;

    await _db.insert(
      item.table,
      item.toMap(),
      algo: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertChatMessagesSafe(List<T> items) async {
    final uid = await AuthStorage.read();
    if (uid == null) return;

    for (final item in items) {
      item.userId = uid;

      await _db.insert(
        item.table,
        item.toMap(),
        algo: ConflictAlgorithm.ignore,
      );
    }
  }

}
