import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'baby.page.dart';
import 'baby_record.model.dart';

class BabyPageState extends State<BabyPage> {
  final _nameCtrl = TextEditingController();
  final _scrollController = new ScrollController();
  final _dbRef = Firestore.instance.collection('babies-db');

  @override
  void dispose() {
    super.dispose();
    _nameCtrl.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildBody(context),
          ),
          Container(
            child: _buildTextInput(context),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _dbRef.orderBy('name_insensitive').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = BabyRecordModel.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 4, right: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(record.name.toString()),
              _buildAddRemoveButtons(record),
            ],
          ),
          onTap: () => print(record),
        ),
      ),
    );
  }

  Row _buildAddRemoveButtons(BabyRecordModel record) {
    return Row(
      children: <Widget>[
        Text(record.votes.toString()),
        Padding(padding: EdgeInsets.only(left: 18)),
        Column(
          children: <Widget>[
            GestureDetector(
              child: Text("+"),
              onTap: () =>
                  record.reference.updateData({'votes': record.votes + 1}),
            ),
            GestureDetector(
                child: Text("-"),
                onTap: () => record.votes > 0
                    ? record.reference.updateData({'votes': record.votes - 1})
                    : null),
          ],
        )
      ],
    );
  }

  _buildTextInput(BuildContext context) {
    return TextField(
      controller: _nameCtrl,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      onEditingComplete: () => _onSubmitMessageField(),
      decoration: InputDecoration(
        labelText: 'Place a name...',
        hintText: 'Place a name...',
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
    );
  }

  _onSubmitMessageField() {
    if (_nameCtrl.text.trim().isNotEmpty) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final String name = _nameCtrl.text.trim();
          _dbRef.add({
            "name": name,
            "name_insensitive": name.toUpperCase(),
            "votes": 0
          });
          _nameCtrl.clear();
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    }
  }
}
