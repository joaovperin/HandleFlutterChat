import 'package:flutter/material.dart';
import 'package:handle_flutter_chat/pages/home/chat/chat_message.model.dart';

import 'home.state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}
