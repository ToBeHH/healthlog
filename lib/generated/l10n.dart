// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Health log`
  String get title {
    return Intl.message(
      'Health log',
      name: 'title',
      desc: 'Title of the app',
      args: [],
    );
  }

  /// `Journal`
  String get journalTitle {
    return Intl.message(
      'Journal',
      name: 'journalTitle',
      desc: 'Title for the journal scaffold',
      args: [],
    );
  }

  /// `No entries in the journal yet.`
  String get journalEmptyList {
    return Intl.message(
      'No entries in the journal yet.',
      name: 'journalEmptyList',
      desc: 'Empty list state for the journal',
      args: [],
    );
  }

  /// `Press`
  String get journalEmptyListAdd1 {
    return Intl.message(
      'Press',
      name: 'journalEmptyListAdd1',
      desc: 'First part of addition empty state help',
      args: [],
    );
  }

  /// `to create your first journal entry.`
  String get journalEmptyListAdd2 {
    return Intl.message(
      'to create your first journal entry.',
      name: 'journalEmptyListAdd2',
      desc: 'Second part of addition empty state help',
      args: [],
    );
  }

  /// `No entries in the journal for the selected tags.`
  String get journalEmptyListNoTags {
    return Intl.message(
      'No entries in the journal for the selected tags.',
      name: 'journalEmptyListNoTags',
      desc: 'Empty list state for the journal, if there are some tags selected',
      args: [],
    );
  }

  /// `Select tags`
  String get journalEmptyListNoTagsButton {
    return Intl.message(
      'Select tags',
      name: 'journalEmptyListNoTagsButton',
      desc:
          'Button on the empty list state for the journal, if there are some tags selected',
      args: [],
    );
  }

  /// `MMMM dd, yyyy`
  String get journalDateFormat {
    return Intl.message(
      'MMMM dd, yyyy',
      name: 'journalDateFormat',
      desc: 'Date format used in list view',
      args: [],
    );
  }

  /// `Add a new journal entry`
  String get journalAddTitle {
    return Intl.message(
      'Add a new journal entry',
      name: 'journalAddTitle',
      desc: 'Title of the dialog to add a new entry',
      args: [],
    );
  }

  /// `Edit a journal entry`
  String get journalEditTitle {
    return Intl.message(
      'Edit a journal entry',
      name: 'journalEditTitle',
      desc: 'Title of the dialog to edit a new entry',
      args: [],
    );
  }

  /// `How was your day today?`
  String get journalInputHint {
    return Intl.message(
      'How was your day today?',
      name: 'journalInputHint',
      desc: 'Hint for the input dialog for the journal',
      args: [],
    );
  }

  /// `Add`
  String get journalAdd {
    return Intl.message(
      'Add',
      name: 'journalAdd',
      desc: 'Button to add a new journal from the dialog',
      args: [],
    );
  }

  /// `Update`
  String get journalEdit {
    return Intl.message(
      'Update',
      name: 'journalEdit',
      desc: 'Button to edit a new journal from the dialog',
      args: [],
    );
  }

  /// `Cancel`
  String get journalCancel {
    return Intl.message(
      'Cancel',
      name: 'journalCancel',
      desc: 'Button to cancel adding / editing a journal from the dialog',
      args: [],
    );
  }

  /// `Tags`
  String get journalTagsTitle {
    return Intl.message(
      'Tags',
      name: 'journalTagsTitle',
      desc: 'Title for the tags chooser dialog',
      args: [],
    );
  }

  /// `Add new tag`
  String get journalAddTag {
    return Intl.message(
      'Add new tag',
      name: 'journalAddTag',
      desc: 'Text button to add a new tag',
      args: [],
    );
  }

  /// `Ok`
  String get journalAddTagsConfirmButton {
    return Intl.message(
      'Ok',
      name: 'journalAddTagsConfirmButton',
      desc:
          'Button to dismiss the dialog to choose the tags for a journal entry',
      args: [],
    );
  }

  /// `Add new tag`
  String get journalTagsNewTitle {
    return Intl.message(
      'Add new tag',
      name: 'journalTagsNewTitle',
      desc: 'Title of the dialog to add a new tag',
      args: [],
    );
  }

  /// `Edit tag`
  String get journalTagsEditTitle {
    return Intl.message(
      'Edit tag',
      name: 'journalTagsEditTitle',
      desc: 'Title of the dialog to edit an existing tag',
      args: [],
    );
  }

  /// `Color:`
  String get journalTagsNewColor {
    return Intl.message(
      'Color:',
      name: 'journalTagsNewColor',
      desc: 'Color label of the dialog to add a new tag',
      args: [],
    );
  }

  /// `New tag`
  String get journalTagsNewInput {
    return Intl.message(
      'New tag',
      name: 'journalTagsNewInput',
      desc: 'Placeholder text for adding a new tag',
      args: [],
    );
  }

  /// `Tag`
  String get journalTagsEditInput {
    return Intl.message(
      'Tag',
      name: 'journalTagsEditInput',
      desc: 'Placeholder text for editing an existing tag',
      args: [],
    );
  }

  /// `Save`
  String get journalTagsNewConfirmButton {
    return Intl.message(
      'Save',
      name: 'journalTagsNewConfirmButton',
      desc: 'Button to store the new tag',
      args: [],
    );
  }

  /// `Save`
  String get journalTagsEditConfirmButton {
    return Intl.message(
      'Save',
      name: 'journalTagsEditConfirmButton',
      desc: 'Button to store the edited tag',
      args: [],
    );
  }

  /// `Really delete?`
  String get journalConfirmDeleteTitle {
    return Intl.message(
      'Really delete?',
      name: 'journalConfirmDeleteTitle',
      desc: 'Title of the confirmation dialog to delete a message',
      args: [],
    );
  }

  /// `Are you sure you want to delete this journal entry?`
  String get journalConfirmDeleteBody {
    return Intl.message(
      'Are you sure you want to delete this journal entry?',
      name: 'journalConfirmDeleteBody',
      desc: 'Body of the confirmation dialog to delete a message',
      args: [],
    );
  }

  /// `Yes, delete`
  String get journalConfirmButton {
    return Intl.message(
      'Yes, delete',
      name: 'journalConfirmButton',
      desc: 'Button to really delete a journal entry',
      args: [],
    );
  }

  /// `Really delete?`
  String get journalConfirmTagDeleteTitle {
    return Intl.message(
      'Really delete?',
      name: 'journalConfirmTagDeleteTitle',
      desc: 'Title of the dialog to delete a tag',
      args: [],
    );
  }

  /// `Do you really want to delete the tag "{tagname}"? {count,plural,=0{} one{It is used once!} other{It is used {count} times!}}`
  String journalConfirmTagDeleteBody(Object tagname, num count) {
    return Intl.message(
      'Do you really want to delete the tag "$tagname"? ${Intl.plural(count, zero: '', one: 'It is used once!', other: 'It is used $count times!')}',
      name: 'journalConfirmTagDeleteBody',
      desc:
          'Body of the dialog, if tag should be deleted - if the tag is in use.',
      args: [tagname, count],
    );
  }

  /// `Insight`
  String get journalDefaultTagGreen {
    return Intl.message(
      'Insight',
      name: 'journalDefaultTagGreen',
      desc: 'Default tag name for the green color',
      args: [],
    );
  }

  /// `Learned`
  String get journalDefaultTagBlue {
    return Intl.message(
      'Learned',
      name: 'journalDefaultTagBlue',
      desc: 'Default tag name for the blue color',
      args: [],
    );
  }

  /// `Important`
  String get journalDefaultTagOrange {
    return Intl.message(
      'Important',
      name: 'journalDefaultTagOrange',
      desc: 'Default tag name for the orange color',
      args: [],
    );
  }

  /// `⚠ Very important`
  String get journalDefaultTagRed {
    return Intl.message(
      '⚠ Very important',
      name: 'journalDefaultTagRed',
      desc: 'Default tag name for the red color',
      args: [],
    );
  }

  /// `Insight extended`
  String get journalDefaultTagLightBlue {
    return Intl.message(
      'Insight extended',
      name: 'journalDefaultTagLightBlue',
      desc: 'Default tag name for the light blue color',
      args: [],
    );
  }

  /// `Exercise`
  String get journalDefaultTagTeal {
    return Intl.message(
      'Exercise',
      name: 'journalDefaultTagTeal',
      desc: 'Default tag name for the cyan color',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
