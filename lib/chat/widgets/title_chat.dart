import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/screens/video_call/video_call.dart';
import 'package:chat_app/chat/services/chat.dart';
import 'package:chat_app/chat/widgets/option_chat.dart';
import 'package:chat_app/chat/widgets/title_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TitleChat extends StatelessWidget {
  const TitleChat({Key? key, required this.chatRoom}) : super(key: key);
  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("private_chats")
            .doc(chatRoom.id)
            .snapshots(),
        builder: (context, snapshot) {
          return AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 25,
            // titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color.fromRGBO(150, 150, 150, 1),
              ),
              onPressed: () => Get.back(),
            ),
            title: TitleWidget(chatRoom: chatRoom),
            actions: [
              IconButton(
                onPressed: () {
                  sendMessages(
                    chatRoom,
                    ContentMessages(
                      activity: 0,
                      callDuration: DateTime.now(),
                    ),
                  );
                  Get.to(VideoCall(chatRoom: chatRoom));
                },
                icon: const Icon(
                  FontAwesomeIcons.phone,
                  size: 20,
                  color: Color.fromRGBO(34, 184, 190, 1),
                ),
              ),
              IconButton(
                onPressed: () {
                  sendMessages(
                    chatRoom,
                    ContentMessages(
                      activity: 0,
                      callDuration: DateTime.now(),
                    ),
                  );
                  Get.to(VideoCall(chatRoom: chatRoom));
                },
                icon: const Icon(
                  FontAwesomeIcons.video,
                  size: 20,
                  color: Color.fromRGBO(34, 184, 190, 1),
                ),
              ),
              OptionChat(chatRoom: chatRoom),
            ],
          );
        });
  }
}
