import 'package:chat_app/chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String id;
  User user1;
  User user2;
  String theme;
  String mainReaction;

  ChatRoom({
    required this.id,
    required this.user1,
    required this.user2,
    required this.theme,
    required this.mainReaction,
  });

  factory ChatRoom.fromFirebase(DocumentSnapshot snapshot) {
    Map<String, dynamic> mapUser1 = snapshot["user1"];
    Map<String, dynamic> mapUser2 = snapshot["user2"];
    return ChatRoom(
      id: snapshot.id,
      user1: User(
        id: mapUser1["id"],
        name: mapUser1["nick_name"],
        notify: mapUser1["notify"],
      ),
      user2: User(
        id: mapUser2["id"],
        name: mapUser2["nick_name"],
        notify: mapUser2["notify"],
      ),
      theme: snapshot["theme"],
      mainReaction: snapshot["main_reaction"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user1": {
        "id": user1.id,
        "nick_name": user1.name,
        "notify": user1.notify,
      },
      "user2": {
        "id": user2.id,
        "nick_name": user2.name,
        "notify": user2.notify,
      },
      "theme": theme,
      "main_reaction": mainReaction,
    };
  }
}
