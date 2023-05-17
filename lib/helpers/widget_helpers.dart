import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetHelper {
  static Widget fancyButton(
      String text, Color color, Future<void> Function() action) {
    return ElevatedButton(
        onPressed: () async {
          await action();
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(text));
  }

  static List<Widget> getActionButtons(BuildContext context, String ok,
      String cancel, Color color, Future<void> Function() action) {
    return [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(primary: color),
          child: Text(cancel)),
      fancyButton(ok, color, action),
    ];
  }

  static Future<void> confirmDialog(
      BuildContext context,
      String title,
      String body,
      String confirmButton,
      String cancelButton,
      Color color,
      Future<void> Function() action) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: WidgetHelper.getActionButtons(
                context, confirmButton, cancelButton, color, action),
          );
        });
  }
}
