import 'package:chat_app/chat/models/content_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String sender;
  String? id;
  String? chatID;
  ContentMessages content;
  DateTime timestamp;
  bool delete;
  bool seen;
  Map<String, dynamic>? reaction;

  Messages({
    this.id,
    this.chatID,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.delete = false,
    this.seen = false,
    this.reaction,
  });

  factory Messages.fromFirebase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    Timestamp time = data["timestamp"];
    return Messages(
      id: snapshot.id,
      sender: data["sender"],
      content: ContentMessages.fromMap(data["content"]),
      timestamp:
          DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch),
      delete: data["delete"],
      reaction: data["reaction"],
      seen: data["seen"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "content": content.toMap(),
      "timestamp": timestamp,
      "delete": delete,
      "reaction": reaction,
      "seen": seen,
    };
  }
}
