import 'package:intl/intl.dart';

class ChatMessageModel {
  static final timeFormatter = new DateFormat("HH:mm:ss");

  final String message;
  final String author;
  final DateTime timestamp;

  ChatMessageModel(this.message, this.author, this.timestamp);

  String fmtTime() {
    return timeFormatter.format(timestamp);
  }

  String createKey() {
    return author + "@" + timestamp.toIso8601String();
  }
}
