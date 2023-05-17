import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'journal_to_tags_model.dart';
import 'model.dart';

const String tabTable = 'tags_table';

const String tagColId = 'id';
const String tagColName = 'name';
const String tagColColor = 'color';
const String tagColCreatedAt = 'createdAt';
const String tagColModifiedAt = 'modifiedAt';

const Color tagNoColor = Colors.cyan;

class TagModel extends Model {
  String name;
  Color? color;
  DateTime createdAt;
  DateTime modifiedAt;

  static String createStatement() {
    return 'CREATE TABLE $tabTable ($tagColId INTEGER PRIMARY KEY AUTOINCREMENT,$tagColName TEXT, $tagColColor TEXT, '
    '$tagColCreatedAt TEXT, $tagColModifiedAt TEXT);';
  }

  TagModel({required this.name, this.color, required this.createdAt, required this.modifiedAt});

  TagModel.withId({int? id, required this.name, this.color, required this.createdAt, required this.modifiedAt}) : super.withId(id);

  @override
  String get table => tabTable;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[tagColId] = id;
    map[tagColName] = name;
    map[tagColColor] = color == null ? null : '#${color!.value.toRadixString(16).padLeft(8, '0')}';
    map[tagColCreatedAt] = createdAt.toIso8601String();
    map[tagColModifiedAt] = modifiedAt.toIso8601String();
    return map;
  }

  @override
  TagModel fromMap(Map<String, dynamic> map) {
    return TagModel.withId(
        id: map[tagColId],
        name: map[tagColName],
        color: map[tagColColor] == null
            ? null
            : Color(int.parse(map[tagColColor].substring(1, 9), radix: 16)),
        createdAt: DateTime.parse(map[tagColCreatedAt]),
        modifiedAt: DateTime.parse(map[tagColModifiedAt]));
  }

  factory TagModel.empty() {
    return TagModel(
        name: "", createdAt: DateTime.now(), modifiedAt: DateTime.now());
  }

  Future<int?> usageCount(Database db) async {
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $journalToTagTable WHERE $journalToTagColTagId = $id'));
  }

  @override
  Future<int> delete(Database db) async {
    final int result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    await db.delete(journalToTagTable,
        where: '$journalToTagColTagId = ?', whereArgs: [id]);
    return result;
  }

  @override
  String toString() {
    return '$id - $name';
  }
}
