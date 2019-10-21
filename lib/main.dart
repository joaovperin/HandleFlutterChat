import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handle_flutter_chat/pages/home/home.page.dart';

import 'pages/login/login.page.dart';
import 'pages/register/register.page.dart';
import 'pages/splash/splash.page.dart';
import 'shared/constants/app.constants.dart';

///
/// Auth examples:
///
///https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675
///
void main() => runApp(HandleChatApp());

class HandleChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: kAppTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.indigoAccent,
            accentIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.pink),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(title: kAppTitle),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}
