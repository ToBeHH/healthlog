import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:healthlog/models/journal_model.dart';
import 'package:healthlog/models/journal_to_tags_model.dart';
import 'package:healthlog/models/tags_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _db;

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/health.db';
    final trixyDb =
        await openDatabase(path, version: 2, onCreate: (db, version) async {
      var batch = db.batch();
      batch.execute(JournalModel.createStatement());
      batch.execute(TagModel.createStatement());
      batch.execute(JournalToTagModel.createStatement());
      await batch.commit();
    }, onUpgrade: (db, oldVersion, newVersion) async {
      var batch = db.batch();
      if (newVersion == 2) {
        batch.execute(TagModel.createStatement());
        batch.execute(JournalToTagModel.createStatement());
      }
      await batch.commit();
    });
    return trixyDb;
  }

  Future<void> dropAll() async {
    Database db = await this.db;
    String path = db.path;
    await db.close();
    File file = File(path);
    await file.delete();
  }

  Future<List<Map<String, dynamic>>> getMapList(String table) async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(table);
    return result;
  }

  Future<List<JournalModel>> getJournalList(String encryptionKey) async {
    final List<JournalModel> list = [];
    for (var map in (await getMapList(journalTable))) {
      list.add(JournalModel().fromMap(map, encryptionKey));
    }
    return list;
  }

  Future<List<JournalModel>> getJournalListWithTags(
      String encryptionKey, List<int> selectedTags) async {
    Database db = await this.db;
    final List<JournalModel> list = [];
    final List<Map<String, dynamic>> listFromDB =
        await getMapList(journalTable);
    for (var map in listFromDB) {
      JournalModel model = JournalModel().fromMap(map, encryptionKey);
      model.tags = await model.getTags(db);
      if (selectedTags.isEmpty ||
          model.tags!.any((tag) => selectedTags.contains(tag.id))) {
        list.add(model);
      }
    }
    list.sort((itemA, itemB) => itemB.date!.compareTo(itemA.date!));
    return list;
  }

  Future<List<TagModel>> getTagList() async {
    final List<TagModel> list = [];
    for (var map in (await getMapList(tabTable))) {
      list.add(TagModel.empty().fromMap(map));
    }
    list.sort((itemA, itemB) => itemA.name.compareTo(itemB.name));
    return list;
  }

  Future<TagModel?> getTag(int id) async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result =
        await db.query(tabTable, where: 'id = ?', whereArgs: [id]);
    if (result.length == 1) {
      return TagModel.empty().fromMap(result[0]);
    } else {
      return null;
    }
  }
}
