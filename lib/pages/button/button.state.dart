import 'package:flutter/material.dart';

import 'button.page.dart';

class ButtonPageState extends State<ButtonPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button '),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('LEFT'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Text('RIGHT')
                ],
              ),
              Text(' many times.')
            ],
          ),
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => setState(() => _counter++),
              tooltip: 'Increment',
              child: Icon(Icons.expand_less),
            ),
            Padding(padding: EdgeInsets.only(bottom: 4)),
            FloatingActionButton(
              onPressed: () =>
                  setState(() => _counter = _counter > 0 ? _counter - 1 : 0),
              tooltip: 'Decrement',
              child: Icon(Icons.expand_more),
            ),
          ],
        ));
  }
}
