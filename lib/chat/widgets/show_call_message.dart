import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/screens/video_call/video_call.dart';
import 'package:chat_app/chat/services/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowCallMessage extends StatelessWidget {
  const ShowCallMessage({Key? key, required this.check, required this.messages})
      : super(key: key);

  final bool check;
  final Messages messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: check ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.red.shade400,
        child: SizedBox(
          height: 60,
          width: Get.width / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection("private_chats")
                      .doc(messages.chatID)
                      .get()
                      .then((value) {
                    ChatRoom chatRoom = ChatRoom.fromFirebase(value);
                    sendMessages(
                        chatRoom,
                        ContentMessages(
                          activity: 0,
                          callDuration: DateTime.now(),
                        ));
                    Get.to(VideoCall(chatRoom: chatRoom));
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: const Icon(Icons.call),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  DateFormat("HH:mm:ss").format(messages.content.callDuration!),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
