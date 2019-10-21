import 'dart:async';

import 'package:flutter/material.dart';

class DialogsService {
  ///
  /// Shows a confirm dialog with yes/no buttons
  ///
  static Future confirmText(
      BuildContext context, String title, String content) async {
    return confirm(context, Text(title), Text(content));
  }

  ///
  /// Shows a message dialog with Ok button
  ///
  static Future okText(
      BuildContext context, String title, String content) async {
    return ok(context, Text(title), Text(content));
  }

  ///
  /// Shows an error dialog with Ok button for exceptions
  ///
  static Future errorException(BuildContext context,
      {String title: 'Ops!', error}) async {
    return errorText(context,
        title: title,
        message:
            error?.details ?? error?.message ?? "Something bad happened :/");
  }

  ///
  /// Shows an error dialog with Ok button
  ///
  static Future errorText(BuildContext context,
      {String title: 'Ops!', message}) async {
    return ok(
      context,
      Text(title),
      Text(message),
    );
  }

  ///
  /// Shows a confirm dialog with yes/no buttons
  ///
  static Future confirm(
      BuildContext context, Widget title, Widget content) async {
    final completer = Completer();
    _showDialog(context, title, content, <Widget>[
      FlatButton(
        child: Text('No'),
        onPressed: () {
          completer.complete(false);
          Navigator.pop(context);
        },
      ),
      FlatButton(child: Text('Yes'), onPressed: () => completer.complete(true))
    ]);
    return completer.future;
  }

  ///
  /// Shows a dialog with Ok button
  ///
  static Future ok(BuildContext context, Widget title, Widget content) async {
    final completer = Completer();
    _showDialog(context, title, content, <Widget>[
      FlatButton(
        child: Text('Ok'),
        onPressed: () {
          completer.complete();
          Navigator.pop(context);
        },
      )
    ]);
    return completer.future;
  }

  ///
  /// Shows a dialog with Ok button
  ///
  static void _showDialog(BuildContext context, Widget title, Widget content,
      List<Widget> buttons) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: title,
              content: content,
              actions: buttons,
            ));
  }
}
