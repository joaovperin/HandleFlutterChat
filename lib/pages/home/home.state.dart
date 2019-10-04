import 'package:flutter/material.dart';
import 'chat/chat_message.model.dart';

import 'home.page.dart';

class HomePageState extends State<HomePage> {
  static const AUTHOR = "Perin";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _messageCtrl = TextEditingController();
  final _scrollController = new ScrollController();

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSubmitMessageField() {
    if (_messageCtrl.text.trim().isNotEmpty) {
      setState(() {
        widget.messages
            .add(ChatMessageModel(_messageCtrl.text, AUTHOR, DateTime.now()));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _messageCtrl.clear();
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        key: _formKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.fromLTRB(2, 6, 2, 6),
              child: ListView(
                controller: _scrollController,
                children: ListTile.divideTiles(
                    context: context,
                    tiles: widget.messages.map((msg) => Dismissible(
                          key: Key(msg.createKey()),
                          onDismissed: (direction) {
                            setState(() => widget.messages.remove(msg));
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Button moved to separate widget'),
                              duration: Duration(seconds: 3),
                            ));
                          },
                          background: Container(color: Colors.grey),
                          child: ListTile(
                            title: Text(msg.message),
                            subtitle: Text(
                              msg.author + ' (' + msg.fmtTime() + ')',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ))).toList(),
              ),
            ),
          ),
          Container(
            child: TextField(
              controller: _messageCtrl,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              onEditingComplete: () => _onSubmitMessageField(),
              decoration: InputDecoration(
                labelText: 'Place a message...',
                hintText: 'Place a message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _onSubmitMessageField(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
