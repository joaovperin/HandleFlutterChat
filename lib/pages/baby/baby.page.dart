import 'package:flutter/material.dart';

import 'baby.state.dart';

class BabyPage extends StatefulWidget {
  BabyPage({Key key}) : super(key: key);

  final dummySnapshot = [
    {"name": "Filip", "votes": 15},
    {"name": "Abraham", "votes": 14},
    {"name": "Richard", "votes": 11},
    {"name": "Ike", "votes": 10},
    {"name": "Justin", "votes": 1},
  ];

  @override
  BabyPageState createState() => BabyPageState();
}
