import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

typedef FromMap<T> = T Function(Map<String, dynamic> row);

class GenericMethods<T extends BaseModel> {
  GenericMethods(this._fromMap);

  final FromMap<T> _fromMap;
  final DBHelper _db = DBHelper();

  Future<void> insertAll(
    List<T> items, {
    ConflictAlgorithm algo = ConflictAlgorithm.replace,
  }) async {
    for (final item in items) {
      await _db.insert(item.table, item.toMap(), algo: algo);
    }
  }

  Future<List<T>> getAll(String table) async {
    final rows = await _db.get(table);
    return rows.map(_fromMap).toList();
  }

  Future<T?> getById(String table, String id) async {
    final rows = await _db.get(table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : _fromMap(rows.first);
  }

  Future<int> update(T item) => _db.update(
    item.table,
    item.toMap(),
    where: 'id = ?',
    whereArgs: [item.id],
  );

  Future<int> deleteById(String table, String id) =>
      _db.delete(table, where: 'id = ?', whereArgs: [id]);
}
