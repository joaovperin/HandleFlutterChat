import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handle_flutter_chat/core/ui/dialogs/dialogs.service.dart';
import 'package:handle_flutter_chat/core/users/users.service.dart';
import 'chat/chat_message.model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.page.dart';

class HomePageState extends State<HomePage> {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () => _onPressedLogout(context),
          )
        ],
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

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _dbChatRef.orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
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
    final isHyperlink = _isHyperlink(msg?.message);
    return Dismissible(
      confirmDismiss: (direction) async {
        if (widget.uid != msg.authoruuid) {
          DialogsService.errorText(context,
              message: "You can't delete other's person's message!");
          return false;
        }
        return true;
      },
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
        title: isHyperlink
            ? InkWell(
                child: Text(msg.message, style: TextStyle(color: Colors.blue)),
                onTap: () => launch(msg.message))
            : Text(msg.message),
        subtitle: Text(
          msg.author + ' (' + msg.fmtTime() + ')',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  TextField _buildMessageField() {
    final _placeAMessage = 'Place a message...';
    return TextField(
      controller: _messageCtrl,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      onEditingComplete: () => _onSubmitMessageField(),
      decoration: InputDecoration(
        labelText: _placeAMessage,
        hintText: _placeAMessage,
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

  void _onSubmitMessageField() {
    if (_messageCtrl.text.trim().isNotEmpty) {
      setState(() {
        _dbChatRef.add({
          'author': widget.dname ?? 'XXXX',
          'authoruuid': widget.uid,
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

  void _onPressedLogout(context) {
    DialogsService.confirmText(
      context,
      'Hey',
      'Do you really want to logout?',
    ).then((confirm) {
      if (confirm) {
        UserService.logout().then((_) {
          Navigator.pushReplacementNamed(context, "/login");
        });
      }
    });
  }

  bool _isHyperlink(String text) {
    return RegExp(r'http|\w+\.\w+').hasMatch(text);
  }
}
