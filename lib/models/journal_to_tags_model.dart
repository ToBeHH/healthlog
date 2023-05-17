import 'package:healthlog/models/journal_model.dart';
import 'package:healthlog/models/tags_model.dart';
import 'package:healthlog/models/model.dart';

const String journalToTagTable = 'journal_to_tags_table';

const String journalToTagColId = 'id';
const String journalToTagColJournalId = 'journalId';
const String journalToTagColTagId = 'tagId';
const String journalToTagColCreatedAt = 'createdAt';
const String journalToTagColModifiedAt = 'modifiedAt';

class JournalToTagModel extends Model {
  int journalId;
  int tagId;
  DateTime createdAt;
  DateTime modifiedAt;

  static String createStatement() {
    return 'CREATE TABLE $journalToTagTable ($journalToTagColId INTEGER PRIMARY KEY AUTOINCREMENT, $journalToTagColJournalId INTEGER, $journalToTagColTagId INTEGER, $journalToTagColCreatedAt TEXT, $journalToTagColModifiedAt TEXT, FOREIGN KEY ($journalToTagColJournalId) REFERENCES $journalTable($journalColId), FOREIGN KEY ($journalToTagColTagId) REFERENCES $tabTable($tagColId))';
  }

  JournalToTagModel({required this.journalId, required this.tagId, required this.createdAt, required this.modifiedAt});

  JournalToTagModel.withId({int? id, required this.journalId, required this.tagId, required this.createdAt, required this.modifiedAt}) : super.withId(id);


  @override
  String get table => journalToTagTable;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[journalToTagColId] = id;
    map[journalToTagColJournalId] = journalId;
    map[journalToTagColTagId] = tagId;
    map[journalToTagColCreatedAt] = createdAt.toIso8601String();
    map[journalToTagColModifiedAt] = modifiedAt.toIso8601String();
    return map;
  }

  @override
  JournalToTagModel fromMap(Map<String, dynamic> map) {
    return JournalToTagModel.withId(
        id: map[journalToTagColId],
        journalId: map[journalToTagColJournalId],
        tagId: map[journalToTagColTagId],
        createdAt: DateTime.parse(map[journalToTagColCreatedAt]),
        modifiedAt: DateTime.parse(map[journalToTagColModifiedAt]));
  }
}
