// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(tagname, count) =>
      "Do you really want to delete the tag \"${tagname}\"? ${Intl.plural(count, zero: '', one: 'It is used once!', other: 'It is used ${count} times!')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "journalAdd": MessageLookupByLibrary.simpleMessage("Add"),
        "journalAddTag": MessageLookupByLibrary.simpleMessage("Add new tag"),
        "journalAddTagsConfirmButton":
            MessageLookupByLibrary.simpleMessage("Ok"),
        "journalAddTitle":
            MessageLookupByLibrary.simpleMessage("Add a new journal entry"),
        "journalCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "journalConfirmButton":
            MessageLookupByLibrary.simpleMessage("Yes, delete"),
        "journalConfirmDeleteBody": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this journal entry?"),
        "journalConfirmDeleteTitle":
            MessageLookupByLibrary.simpleMessage("Really delete?"),
        "journalConfirmTagDeleteBody": m0,
        "journalConfirmTagDeleteTitle":
            MessageLookupByLibrary.simpleMessage("Really delete?"),
        "journalDateFormat":
            MessageLookupByLibrary.simpleMessage("MMMM dd, yyyy"),
        "journalDefaultTagBlue":
            MessageLookupByLibrary.simpleMessage("Learned"),
        "journalDefaultTagGreen":
            MessageLookupByLibrary.simpleMessage("Insight"),
        "journalDefaultTagLightBlue":
            MessageLookupByLibrary.simpleMessage("Insight extended"),
        "journalDefaultTagOrange":
            MessageLookupByLibrary.simpleMessage("Important"),
        "journalDefaultTagRed":
            MessageLookupByLibrary.simpleMessage("⚠ Very important"),
        "journalDefaultTagTeal":
            MessageLookupByLibrary.simpleMessage("Exercise"),
        "journalEdit": MessageLookupByLibrary.simpleMessage("Update"),
        "journalEditTitle":
            MessageLookupByLibrary.simpleMessage("Edit a journal entry"),
        "journalEmptyList": MessageLookupByLibrary.simpleMessage(
            "No entries in the journal yet."),
        "journalEmptyListAdd1": MessageLookupByLibrary.simpleMessage("Press"),
        "journalEmptyListAdd2": MessageLookupByLibrary.simpleMessage(
            "to create your first journal entry."),
        "journalEmptyListNoTags": MessageLookupByLibrary.simpleMessage(
            "No entries in the journal for the selected tags."),
        "journalEmptyListNoTagsButton":
            MessageLookupByLibrary.simpleMessage("Select tags"),
        "journalInputHint":
            MessageLookupByLibrary.simpleMessage("How was your day today?"),
        "journalTagsEditConfirmButton":
            MessageLookupByLibrary.simpleMessage("Save"),
        "journalTagsEditInput": MessageLookupByLibrary.simpleMessage("Tag"),
        "journalTagsEditTitle":
            MessageLookupByLibrary.simpleMessage("Edit tag"),
        "journalTagsNewColor": MessageLookupByLibrary.simpleMessage("Color:"),
        "journalTagsNewConfirmButton":
            MessageLookupByLibrary.simpleMessage("Save"),
        "journalTagsNewInput": MessageLookupByLibrary.simpleMessage("New tag"),
        "journalTagsNewTitle":
            MessageLookupByLibrary.simpleMessage("Add new tag"),
        "journalTagsTitle": MessageLookupByLibrary.simpleMessage("Tags"),
        "journalTitle": MessageLookupByLibrary.simpleMessage("Journal"),
        "title": MessageLookupByLibrary.simpleMessage("Health log")
      };
}
