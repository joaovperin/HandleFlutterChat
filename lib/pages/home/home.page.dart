import 'package:flutter/material.dart';

import 'home.state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid, this.dname}) : super(key: key);

  final String title;
  final String uid;
  final String dname;

  @override
  HomePageState createState() => HomePageState();
}
