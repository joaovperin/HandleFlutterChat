import 'dart:async';

import 'package:flutter/material.dart';

class LoadingService {
  ///
  /// Shows a loading app bar
  ///
  static Completer show(BuildContext context) {
    final _loadingCompleter = Completer();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        });

    // Closes the loading dialog when the future completes
    _loadingCompleter.future
      ..then((context) => Navigator.pop(context))
      ..catchError((err) {
        print(err);
        Navigator.pop(context);
      });
    return _loadingCompleter;
  }
}
