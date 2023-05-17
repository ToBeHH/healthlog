import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../generated/l10n.dart';
import '../helpers/database_helper.dart';
import '../helpers/string_helpers.dart';
import '../helpers/widget_helpers.dart';
import '../models/journal_model.dart';
import '../models/tags_model.dart';

class Journal extends StatefulWidget {
  const Journal({Key? key}) : super(key: key);

  final int area = 2;

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  late Future<String> _encryptionKeyFuture;
  late String _encryptionKey = "undefined";
  Future<List<JournalModel>>? _items;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List<TagModel> _tags;
  late List<int> _selectedTags;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _encryptionKeyFuture = _prefs.then((SharedPreferences prefs) {
      _encryptionKey = JournalModel.getEncryptionKey(prefs);
      return _encryptionKey;
    }).then((k) {
      _updateTaskList(k);
      return k;
    });
  }

  _updateTaskList(String encryptionKey) async {
    List<TagModel> tags = await DatabaseHelper.instance.getTagList();
    setState(() {
      _tags = tags;
      _selectedTags = [];
      _items =
          DatabaseHelper.instance.getJournalListWithTags(encryptionKey, []);
    });
  }

  /// Build an item in the journal - containing date, some text and the tags
  Widget _buildItem(JournalModel journal, BuildContext context) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final DateFormat _dateFormatter =
        DateFormat(S.of(context).journalDateFormat, languageCode);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Text(_dateFormatter.format(journal.date!)),
            subtitle: Text(StringHelpers.removeHTML(journal.text ?? ""),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => JournalEdit(
                      model: journal,
                      encryptionKey: _encryptionKey,
                      area: widget.area)));
              _updateTaskList(_encryptionKey);
            },
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                  children: journal.tags!
                      .map((e) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: e.color ?? tagNoColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0))),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 3, 8, 3),
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                        color: useWhiteForeground(
                                                e.color ?? tagNoColor)
                                            ? const Color(0xffffffff)
                                            : const Color(0xff000000)),
                                  )))))
                      .toList())),
          const Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _encryptionKeyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureBuilder<List<JournalModel>>(
              future: _items,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final int itemCount =
                    (snapshot.data as List<JournalModel>).length;

                List<Widget> actions = [];
                if (_tags.isNotEmpty) {
                  actions.add(IconButton(
                      icon: const Icon(Icons.label),
                      onPressed: () async {
                        await _chooseTagsDialog(context);
                        setState(() {
                          _items = DatabaseHelper.instance
                              .getJournalListWithTags(
                                  _encryptionKey, _selectedTags);
                        });
                      }));
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text(S.of(context).journalTitle),
                    automaticallyImplyLeading: true,
                    leadingWidth: 0,
                    actions: actions,
                  ),
                  body: itemCount == 0
                      ? (_selectedTags.isEmpty
                          ? emptyJournal(context)
                          : noJournalEntriesForTheSelectedTags(context))
                      : ListView.builder(
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            return _buildItem(
                                (snapshot.data as List<JournalModel>)[index],
                                context);
                          },
                        ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => JournalEdit(
                              model: null,
                              encryptionKey: _encryptionKey,
                              area: widget.area)));
                      _updateTaskList(_encryptionKey);
                    },
                    tooltip: 'Add Item',
                    child: const Icon(Icons.post_add),
                  ),
                );
              });
        });
  }

  Widget emptyJournal(BuildContext context) {
    overlayEntry?.remove();
    overlayEntry = OverlayEntry(builder: (context) {
      // Align is used to position the highlight overlay
      // relative to the NavigationBar destination.
      return SafeArea(
          child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 80, 80),
            child: Image.asset('assets/hand.png',
                width: MediaQuery.of(context).size.width / 2)),
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
    });

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                S.of(context).journalEmptyList,
                textAlign: TextAlign.center,
                softWrap: true,
              )),
          const SizedBox(height: 10),
          RichText(
              textAlign: TextAlign.center,
              softWrap: true,
              text: TextSpan(children: [
                TextSpan(
                    text: S.of(context).journalEmptyListAdd1,
                    style: TextStyle(color: Colors.black)),
                WidgetSpan(
                    child: Icon(
                  Icons.post_add,
                )),
                TextSpan(
                    text: S.of(context).journalEmptyListAdd2,
                    style: TextStyle(color: Colors.black))
              ]))
        ]));
  }

  Widget noJournalEntriesForTheSelectedTags(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                S.of(context).journalEmptyListNoTags,
                textAlign: TextAlign.center,
                softWrap: true,
              )),
          const SizedBox(height: 10),
          WidgetHelper.fancyButton(
              S.of(context).journalEmptyListNoTagsButton, C.primaryColor,
              () async {
            await _chooseTagsDialog(context);
            setState(() {
              _items = DatabaseHelper.instance
                  .getJournalListWithTags(_encryptionKey, _selectedTags);
            });
          })
        ]));
  }

  Future<void> _chooseTagsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text(S.of(context).journalTagsTitle),
                content: Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                        itemCount: _tags.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              title: Text(_tags[index].name),
                              leading: ClipOval(
                                child: Material(
                                  color: _tags[index].color ?? tagNoColor,
                                  // Button color
                                  child: InkWell(
                                    splashColor: Colors.red, // Splash color
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          titlePadding:
                                              const EdgeInsets.all(0.0),
                                          contentPadding:
                                              const EdgeInsets.all(0.0),
                                          content: SingleChildScrollView(
                                            child: ColorPicker(
                                              pickerColor: _tags[index].color ??
                                                  tagNoColor,
                                              onColorChanged: (color) async {
                                                _tags[index].color = color;
                                                _tags[index].modifiedAt =
                                                    DateTime.now();
                                                await _tags[index].update(
                                                    await DatabaseHelper
                                                        .instance.db);

                                                setState(() {
                                                  _tags[index].color = color;
                                                });
                                              },
                                              colorPickerWidth: 300.0,
                                              pickerAreaHeightPercent: 0.7,
                                              enableAlpha: false,
                                              displayThumbColor: true,
                                              paletteType: PaletteType.hsv,
                                              pickerAreaBorderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(2.0),
                                                topRight: Radius.circular(2.0),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child:
                                            Container(width: 24, height: 24)),
                                  ),
                                ),
                              ),
                              selected:
                                  _selectedTags.contains(_tags[index].id!),
                              onTap: () => setState(() {
                                    if (_selectedTags
                                        .contains(_tags[index].id!)) {
                                      _selectedTags.remove(_tags[index].id!);
                                    } else {
                                      _selectedTags.add(_tags[index].id!);
                                    }
                                  }),
                              trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _AddEditTagDialog(
                                                _tags[index], widget.area));
                                    List<TagModel> tags = await DatabaseHelper
                                        .instance
                                        .getTagList();
                                    setState(() {
                                      _tags = tags;
                                    });
                                  }));
                        })),
                actions: WidgetHelper.getActionButtons(
                    context,
                    S.of(context).journalAddTagsConfirmButton,
                    '',
                    //hide this button S.of(context).journalCancel,
                    C.primaryColor, () async {
                  Navigator.of(context).pop();
                }));
          });
        });
  }
}

class JournalEdit extends StatefulWidget {
  const JournalEdit(
      {Key? key, this.model, required this.encryptionKey, required this.area})
      : super(key: key);

  final JournalModel? model;
  final String encryptionKey;

  final int area;

  @override
  State<JournalEdit> createState() => _JournalEditState();
}

class _JournalEditState extends State<JournalEdit> {
  HtmlEditorController controller = HtmlEditorController();

  late List<TagModel> tags;
  late List<TagModel> tagsForJournalEntry;
  List<bool> selectedTags = [];

  @override
  void initState() {
    super.initState();
    _initTags();
  }

  Future<void> _initTags() async {
    tags = await DatabaseHelper.instance.getTagList();
    tagsForJournalEntry = widget.model == null
        ? []
        : await widget.model!.getTags(await DatabaseHelper.instance.db);
    setState(() {
      for (var element in tags) {
        bool inUse = tagsForJournalEntry.contains(element);
        selectedTags.add(inUse);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.model != null) {
      actions.add(IconButton(
          onPressed: () async {
            await WidgetHelper.confirmDialog(
                context,
                S.of(context).journalConfirmDeleteTitle,
                S.of(context).journalConfirmDeleteBody,
                S.of(context).journalConfirmButton,
                S.of(context).journalCancel,
                C.primaryColor, (() async {
              widget.model!.delete(await DatabaseHelper.instance.db);
              Navigator.of(context).pop();
            }));
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.delete)));
    }
    actions.add(IconButton(
        icon: const Icon(Icons.label),
        onPressed: () => _showTagsDialog(context)));
    actions.add(IconButton(
        icon: const Icon(Icons.save),
        onPressed: () async {
          await _addJournalItem(await controller.getText(), widget.model);
          Navigator.of(context).pop();
        }));

    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).journalTitle),
          actions: actions,
        ),
        body: HtmlEditor(
          controller: controller, //required
          htmlEditorOptions: HtmlEditorOptions(
            hint: S.of(context).journalInputHint,
            initialText: widget.model?.text ?? "",
          ),
          htmlToolbarOptions: const HtmlToolbarOptions(defaultToolbarButtons: [
            //FontSettingButtons(),
            FontButtons(),
            ColorButtons(),
            ListButtons(ol: false)
          ], toolbarPosition: ToolbarPosition.belowEditor),
        ));
  }

  Future<void> _showTagsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text(S.of(context).journalTagsTitle),
                content: Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: tags.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tags.length) {
                          return TextButton(
                              onPressed: () async {
                                TagModel? addedModel =
                                    await _addNewTag(context);
                                if (addedModel != null) {
                                  setState(() {
                                    tags.add(addedModel);
                                    selectedTags.add(
                                        true); // immediately select newly created tag
                                  });
                                }
                              },
                              child: Text(S.of(context).journalAddTag));
                        } else {
                          return CheckboxListTile(
                              value: selectedTags[index],
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              onChanged: (selected) {
                                setState(() {
                                  selectedTags[index] = selected ?? false;
                                });
                              },
                              title: Row(children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 6, 0),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                          color: tags[index].color,
                                          shape: BoxShape.circle),
                                    )),
                                Text(tags[index].name)
                              ]));
                        }
                      },
                    )),
                actions: WidgetHelper.getActionButtons(
                    context,
                    S.of(context).journalAddTagsConfirmButton,
                    S.of(context).journalCancel,
                    C.primaryColor, () async {
                  Navigator.of(context).pop();
                }));
          });
        });
  }

  Future<TagModel?> _addNewTag(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            _AddEditTagDialog(null, widget.area));
  }

  Future<void> _addJournalItem(String text, JournalModel? model) async {
    List<TagModel> tagsUsed = [];
    for (int i = 0; i < tags.length; i++) {
      if (selectedTags[i]) {
        tagsUsed.add(tags[i]);
      }
    }
    if (model == null) {
      DateTime? _date = DateTime.now();
      await JournalModel(text: text, date: _date).insert(
          await DatabaseHelper.instance.db, widget.encryptionKey, tagsUsed);
    } else {
      await JournalModel.withId(id: model.id, text: text, date: model.date)
          .update(
              await DatabaseHelper.instance.db, widget.encryptionKey, tagsUsed);
    }
  }
}

class _AddEditTagDialog extends StatefulWidget {
  final TagModel? model;
  final int area;

  const _AddEditTagDialog(this.model, this.area) : super();

  @override
  _AddEditTagDialogState createState() => _AddEditTagDialogState();
}

class _AddEditTagDialogState extends State<_AddEditTagDialog> {
  late TextEditingController _newTagController;
  Color color = tagNoColor;

  @override
  void initState() {
    super.initState();
    _newTagController = TextEditingController();
    if (widget.model != null) {
      _newTagController.text = widget.model!.name;
      setState(() {
        color = widget.model!.color ?? tagNoColor;
      });
    }
  }

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.model != null) {
      actions.add(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          int usage = await widget.model!
                  .usageCount(await DatabaseHelper.instance.db) ??
              0;
          await WidgetHelper.confirmDialog(
              context,
              S.of(context).journalConfirmTagDeleteTitle,
              S
                  .of(context)
                  .journalConfirmTagDeleteBody(widget.model!.name, usage),
              S.of(context).journalConfirmButton,
              S.of(context).journalCancel,
              C.primaryColor, (() async {
            widget.model!.delete(await DatabaseHelper.instance.db);
            Navigator.of(context).pop();
          }));
          Navigator.of(context).pop();
        },
      ));
    }
    actions.addAll(WidgetHelper.getActionButtons(
        context,
        widget.model == null
            ? S.of(context).journalTagsNewConfirmButton
            : S.of(context).journalTagsEditConfirmButton,
        S.of(context).journalCancel,
        C.primaryColor, () async {
      if (widget.model == null) {
        TagModel model = TagModel(
            name: _newTagController.text,
            color: color,
            createdAt: DateTime.now(),
            modifiedAt: DateTime.now());
        model.id = await model.insert(await DatabaseHelper.instance.db);
        Navigator.of(context).pop(model);
      } else {
        widget.model!.name = _newTagController.text;
        widget.model!.color = color;
        widget.model!.modifiedAt = DateTime.now();
        await widget.model!.update(await DatabaseHelper.instance.db);
        Navigator.of(context).pop();
      }
    }));

    return AlertDialog(
        title: Text(widget.model == null
            ? S.of(context).journalTagsNewTitle
            : S.of(context).journalTagsEditTitle),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newTagController,
                maxLength: 255,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.model == null
                      ? S.of(context).journalTagsNewInput
                      : S.of(context).journalTagsEditInput,
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (String value) => Navigator.pop(context, value),
              ),
              Row(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Text(S.of(context).journalTagsNewColor)),
                ClipOval(
                    child: Material(
                        color: color, // Button color
                        child: InkWell(
                            splashColor: color,
                            child: const SizedBox(width: 16, height: 16),
                            // Splash color
                            onTap: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      titlePadding: const EdgeInsets.all(0.0),
                                      contentPadding: const EdgeInsets.all(0.0),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: color,
                                          onColorChanged: (c) async {
                                            setState(() {
                                              color = c;
                                            });
                                          },
                                          colorPickerWidth: 300.0,
                                          pickerAreaHeightPercent: 0.7,
                                          enableAlpha: false,
                                          displayThumbColor: true,
                                          paletteType: PaletteType.hsv,
                                          pickerAreaBorderRadius:
                                              const BorderRadius.only(
                                            topLeft: Radius.circular(2.0),
                                            topRight: Radius.circular(2.0),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )))),
              ])
            ]),
        actions: actions);
  }
}
