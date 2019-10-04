import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatMessageModel {
  static final timeFormatter = new DateFormat("HH:mm:ss");

  final String author;
  final String message;
  final DateTime timestamp;

  final DocumentReference reference;

  ChatMessageModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['author'] != null),
        assert(map['message'] != null),
        assert(map['timestamp'] != null),
        author = map['author'],
        message = map['message'],
        timestamp = DateTime.parse(map['timestamp']);

  ChatMessageModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String fmtTime() {
    return timeFormatter.format(timestamp);
  }

  String createKey() {
    return author + "@" + timestamp.toIso8601String();
  }
}
