import 'package:flutter/material.dart';
import 'package:handle_flutter_chat/pages/home/home.page.dart';

void main() => runApp(HandleChatApp());

class HandleChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handle Chat',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.indigoAccent,
          accentIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.pink),
      home: HomePage(title: 'Handle Chat'),
    );
  }
}
