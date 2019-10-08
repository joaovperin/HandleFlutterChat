import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat/chat_message.model.dart';

import 'home.page.dart';

class HomePageState extends State<HomePage> {
  static const AUTHOR = "Anonymous user";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _messageCtrl = TextEditingController();
  final _scrollController = new ScrollController();
  static final _dbChatRef = Firestore.instance.collection('chat');

  bool _isSendButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _isSendButtonEnabled = true;
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSubmitMessageField() {
    if (_messageCtrl.text.trim().isNotEmpty) {
      setState(() {
        _dbChatRef.add({
          'author': AUTHOR,
          'message': _messageCtrl.text,
          'timestamp': DateTime.now().toIso8601String()
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _messageCtrl.clear();
          _scrollToEnd();
        });
      });
    }
  }

  void _scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _dbChatRef.orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: ListView(
        controller: _scrollController,
        children: ListTile.divideTiles(
                context: context,
                tiles: snapshot.map((data) => _buildListItem(context, data)))
            .toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final msg = ChatMessageModel.fromSnapshot(data);
    return Dismissible(
      key: Key(msg.createKey()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _dbChatRef.document(data.documentID).delete().then((t) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text('Message deleted!'),
              duration: Duration(seconds: 2),
            ));
        });
      },
      background: Container(color: Colors.grey),
      child: ListTile(
        title: Text(msg.message),
        subtitle: Text(
          msg.author + ' (' + msg.fmtTime() + ')',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _messageCtrl.addListener(() {
      setState(() {
        _isSendButtonEnabled = (_messageCtrl.text.trim().isNotEmpty);
      });
    });
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
              child: _buildBody(context),
            ),
          ),
          Container(
            child: _buildMessageField(),
          )
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
            child: Icon(Icons.arrow_downward), onPressed: _scrollToEnd),
      ),
    );
  }

  TextField _buildMessageField() {
    return TextField(
      controller: _messageCtrl,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      onEditingComplete: () => _onSubmitMessageField(),
      decoration: InputDecoration(
        labelText: 'Place a message...',
        hintText: 'Place a message...',
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed:
              _isSendButtonEnabled ? () => _onSubmitMessageField() : null,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
    );
  }
}
