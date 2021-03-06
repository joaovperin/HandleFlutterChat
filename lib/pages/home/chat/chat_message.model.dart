import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatMessageModel {
  static final timeFormatter = new DateFormat("HH:mm");
  static final dateTimeFormatter = new DateFormat("dd/MM/yyyy - HH:mm");

  final String author;
  final String authoruuid;
  final String message;
  final DateTime serverTimestamp;
  final DateTime timestamp;

  final DocumentReference reference;

  ChatMessageModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['author'] != null),
        assert(map['message'] != null),
        assert(map['timestamp'] != null),
        author = map['author'],
        message = map['message'],
        authoruuid = map['authoruuid'],
        serverTimestamp = map['serverTimestamp']?.toDate(),
        timestamp = map['serverTimestamp']?.toDate() ??
            DateTime.parse(map['timestamp']);

  ChatMessageModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  bool get hasServerTimestamp => serverTimestamp != null;

  String fmtTime() {
    // If same day, omit hours
    if (timestamp.day == DateTime.now().day) {
      return timeFormatter.format(timestamp);
    }
    return dateTimeFormatter.format(timestamp);
  }

  String createKey() {
    return author + "@" + timestamp.toIso8601String();
  }
}
