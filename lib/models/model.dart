import 'package:sqflite/sqflite.dart';

abstract class Model {
  int? id;

  Model();

  Model.withId(this.id);

  String get table;

  Future<int> insert(Database db) async {
    final int newId = await db.insert(table, toMap());
    id = newId;
    return newId;
  }

  Future<int> update(Database db) async {
    final int rowsChanged =
        await db.update(table, toMap(), where: 'id = ?', whereArgs: [id]);
    return rowsChanged;
  }

  Future<int> delete(Database db) async {
    final int result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Map<String, dynamic> toMap();

  Model fromMap(Map<String, dynamic> map);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
