import 'dart:convert';
import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

String baseURL = "https://fcm.googleapis.com/fcm/send";
String serverKey =
    "key=AAAAKDWX1SQ:APA91bGSKguvK1e4NZPyPrhcDPdki4ujqGxBo1tpoydj0LAL7gq4GpRUe16N0-l9BF13bBAZV9nHYqwoStiDnC1zuw4pX7aGbD3ugGUfm8wm8sFWbMavp2SwHqT8AOL3E3mJjSGuQEsz";

Future<String> findExistingPrivateChatId(String uid) async {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatDoc = await FirebaseFirestore.instance
      .collection('users/$currentUserId/chats')
      .doc(uid)
      .get(const GetOptions(source: Source.cache));
  if (chatDoc.exists) {
    return chatDoc['id'];
  } else {
    chatDoc = await FirebaseFirestore.instance
        .collection('users/$currentUserId/chats')
        .doc(uid)
        .get(const GetOptions(source: Source.serverAndCache));
    if (chatDoc.exists) {
      return chatDoc['id'];
    } else {
      throw Exception('Private chat not found with user: $uid');
    }
  }
}

Future initChat(ChatRoom chatRoom) async {
  // init room chat
  FirebaseFirestore.instance
      .collection("private_chats")
      .doc(chatRoom.id)
      .set(chatRoom.toMap());

  // save room chat id
  FirebaseFirestore.instance
      .collection("users")
      .doc(chatRoom.user1.id)
      .collection("private_chats")
      .doc(chatRoom.user2.id)
      .set({"chat_id": chatRoom.id});

  FirebaseFirestore.instance
      .collection("users")
      .doc(chatRoom.user2.id)
      .collection("private_chats")
      .doc(chatRoom.user1.id)
      .set({"chat_id": chatRoom.id});

  //add friend
  FirebaseFirestore.instance
      .collection("users")
      .doc(chatRoom.user1.id)
      .collection("friends")
      .doc(chatRoom.user2.id)
      .set({"chat_id": chatRoom.id});

  FirebaseFirestore.instance
      .collection("users")
      .doc(chatRoom.user2.id)
      .collection("friends")
      .doc(chatRoom.user1.id)
      .set({"chat_id": chatRoom.id});
}

Future sendMessages(
  ChatRoom chatRoom,
  ContentMessages content,
) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  if (!await checkExist(chatRoom.id)) initChat(chatRoom);
  bool check = uid == chatRoom.user1.id;
  String body = contentFCM(content.activity) ?? content.text!;
  if (check ? chatRoom.user2.notify : chatRoom.user1.notify) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(check ? chatRoom.user2.id : chatRoom.user1.id)
        .get()
        .then((value) {
      String token = value.data()!["token"];
      sendPushMessage(
        token: token,
        id: chatRoom.id,
        body: body,
        title: check ? chatRoom.user1.name : chatRoom.user2.name,
        screen: content.activity == 0 ? 'video_call' : 'chat',
      );
    });
  }

  DateTime time = DateTime.now();
  FirebaseFirestore.instance
      .collection("private_chats")
      .doc(chatRoom.id)
      .update({"last_message": time, "text": body});

  await FirebaseFirestore.instance
      .collection("private_chats")
      .doc(chatRoom.id)
      .collection("chats")
      .doc(DateTime.now().microsecondsSinceEpoch.toString())
      .set(Messages(
        sender: uid,
        content: content,
        timestamp: time,
      ).toMap());
}

String? contentFCM(int id) {
  switch (id) {
    case 0:
      return "Đã gọi cho bạn";
    case 1:
      return "Đã gửi tệp tin";
    case 2:
      return "Đã gửi hình ảnh";
    case 3:
      return "Đã gửi hội thoại";
    case 4:
      return "Đã gửi sticker";
    case 6:
      return "Đã gửi liên hệ";
    default:
      return null;
  }
}

Future deleteChat(ChatRoom chatRoom) async {
  final instance = FirebaseFirestore.instance;
  final batch = instance.batch();

  // delete all chat
  var snapshots = await instance
      .collection("private_chats")
      .doc(chatRoom.id)
      .collection("chats")
      .get();
  for (var doc in snapshots.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();
  //delete info room chat
  await instance.collection("private_chats").doc(chatRoom.id).delete();
  // delete id room in user 1
  await instance
      .collection("users")
      .doc(chatRoom.user1.id)
      .collection("private_chats")
      .doc(chatRoom.user2.id)
      .delete();
  // delete id room in user 2
  await instance
      .collection("users")
      .doc(chatRoom.user2.id)
      .collection("private_chats")
      .doc(chatRoom.user1.id)
      .delete();
  // delete all file in chat room
  FirebaseStorage.instance.ref().child(chatRoom.id).delete();
}

Future<bool> checkExist(String id) async {
  var doc = await FirebaseFirestore.instance
      .collection("private_chats")
      .doc(id)
      .get();
  return doc.exists;
}

Future<String?> checkExistPrivateChat(String id1, String id2) async {
  bool check = await checkExist("$id1-$id2");
  if (check) {
    return "$id1-$id2";
  }
  check = await checkExist("$id2-$id1");
  if (check) {
    return "$id2-$id1";
  }
  return null;
}

Future sendPushMessage({
  required String token,
  required String id,
  required String body,
  required String title,
  String status = 'message',
  String myToken = "",
  String screen = 'chat',
}) async {
  try {
    Map<String, String> headerFCM = {
      "Content-Type": "application/json",
      "Authorization": serverKey,
    };

    Map<String, dynamic> bodyFCM = {
      'notification': <String, dynamic>{'body': body, 'title': title},
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': id,
        'status': status,
        'token': myToken,
        'screen': screen,
      },
      "to": token,
    };

    http.post(
      Uri.parse(baseURL),
      headers: headerFCM,
      body: jsonEncode(bodyFCM),
    );
  } catch (_) {}
}

Future changeNotify(ChatRoom chatRoom) async {
  if (FirebaseAuth.instance.currentUser!.uid == chatRoom.user1.id) {
    chatRoom.user1.notify = !chatRoom.user1.notify;
  } else {
    chatRoom.user2.notify = !chatRoom.user2.notify;
  }
  FirebaseFirestore.instance
      .collection("private_chats")
      .doc(chatRoom.id)
      .update(chatRoom.toMap());
}
