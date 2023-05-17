import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:healthlog/helpers/database_helper.dart';
import 'package:healthlog/models/journal_to_tags_model.dart';
import 'package:healthlog/models/tags_model.dart';

const String journalTable = 'journal_table';

const String journalColId = 'id';
const String journalColText = 'text';
const String journalColDate = 'date';

const String encryptionPrefsKey = 'encryptionKey';

class JournalModel {
  int? id;
  String? text;
  DateTime? date;
  List<TagModel>? tags;

  JournalModel({this.text, this.date});

  JournalModel.withId({this.id, this.text, this.date});

  static String createStatement() {
    return 'CREATE TABLE $journalTable ($journalColId INTEGER PRIMARY KEY AUTOINCREMENT,$journalColText TEXT, $journalColDate TEXT)';
  }

  static String getEncryptionKey(SharedPreferences prefs) {
    String k = (prefs.getString(encryptionPrefsKey) ?? "undefined");
    if (k == "undefined") {
      // create random 32 char string
      var r = Random();
      k = String.fromCharCodes(
          List.generate(32, (index) => r.nextInt(33) + 89));
      prefs.setString(encryptionPrefsKey, k);
    }
    return k;
  }

  String get table => journalTable;

  Map<String, dynamic> toMap(String encryptionKey) {
    final key = Key.fromUtf8(encryptionKey);
    final iv = IV.fromBase64('FxIOBAcEEhISHgICCRYhEA==');
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text ?? "", iv: iv);

    final map = <String, dynamic>{};
    map[journalColId] = id;
    map[journalColText] = encrypted.base64;
    map[journalColDate] = date!.toIso8601String();
    return map;
  }

  JournalModel fromMap(Map<String, dynamic> map, String encryptionKey) {
    final key = Key.fromUtf8(encryptionKey);
    final iv = IV.fromBase64('FxIOBAcEEhISHgICCRYhEA==');
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter
        .decrypt(Encrypted(base64.decode(map[journalColText])), iv: iv);

    return JournalModel.withId(
        id: map[journalColId],
        text: decrypted,
        date: DateTime.parse(map[journalColDate]));
  }

  Future<int> insert(Database db, String encryptionKey, List<TagModel> tags) async {
    final int id = await db.insert(table, toMap(encryptionKey));
    tags.forEach((element) async {
      await db.insert(
          journalToTagTable,
          JournalToTagModel(
                  journalId: id,
                  tagId: element.id!,
                  createdAt: DateTime.now(),
                  modifiedAt: DateTime.now())
              .toMap());
    });
    return id;
  }

  Future<int> update(Database db, String encryptionKey, List<TagModel> tags) async {
    final int rowsChanged = await db
        .update(table, toMap(encryptionKey), where: 'id = ?', whereArgs: [id]);
    List<TagModel> existingTags = await getTags(db);

    // remove not changed tags from list
    List<TagModel> tagsInBothLists = [];
    for (var element in tags) {
      if (existingTags.contains(element)) {
        tagsInBothLists.add(element);
      }
    }
    for (var element in tagsInBothLists) {
      tags.remove(element);
      existingTags.remove(element);
    }

    // delete the tags from the database, which only exist in the existingTags list
    existingTags.forEach((element) async {
      await db.delete(journalToTagTable,
          where:
              '$journalToTagColJournalId = ? AND $journalToTagColTagId = ?',
          whereArgs: [id!, element.id!]);
    });

    // insert the tags, which are still in the tags list
    tags.forEach((element) async {
      await db.insert(
          journalToTagTable,
          JournalToTagModel(
                  journalId: id!,
                  tagId: element.id!,
                  createdAt: DateTime.now(),
                  modifiedAt: DateTime.now())
              .toMap());
    });
    return rowsChanged;
  }

  Future<int> delete(Database db) async {
    await db.delete(journalToTagTable, where: '$journalToTagColJournalId = ?', whereArgs: [id]);
    final int result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<TagModel>> getTags(Database db) async {
    final List<TagModel> list = [];
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> mapList = await db.rawQuery(
        'SELECT $tabTable.$tagColId,$tabTable.$tagColName,$tabTable.$tagColColor,$tabTable.$tagColCreatedAt,$tabTable.$tagColModifiedAt '
        'FROM $journalToTagTable LEFT JOIN $tabTable ON $journalToTagTable.$journalToTagColTagId=$tabTable.$tagColId '
        'WHERE $journalToTagTable.$journalToTagColJournalId=$id');
    for (var map in mapList) {
      list.add(TagModel.empty().fromMap(map));
    }
    tags = list;
    return list;
  }

  @override
  String toString() {
    return '$id ($tags)';
  }
}
