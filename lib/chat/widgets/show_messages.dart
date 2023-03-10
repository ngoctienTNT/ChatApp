import 'package:chat_app/chat/widgets/show_audio_message.dart';
import 'package:chat_app/chat/widgets/show_call_message.dart';
import 'package:chat_app/chat/widgets/show_contact_message.dart';
import 'package:chat_app/chat/widgets/show_delete_message.dart';
import 'package:chat_app/chat/widgets/show_file_message.dart';
import 'package:chat_app/chat/widgets/show_image_message.dart';
import 'package:chat_app/chat/widgets/show_text_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/messages.dart';

class ShowMessages extends StatelessWidget {
  const ShowMessages({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("private_chats")
            .doc(id)
            .collection("chats")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Messages> messages = [];
            for (var element in snapshot.requireData.docs) {
              messages.add(Messages.fromFirebase(element)..chatID = id);
            }
            return SingleChildScrollView(
              reverse: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool check = messages[index]
                          .sender
                          .compareTo(FirebaseAuth.instance.currentUser!.uid) ==
                      0;
                  if (!messages[index].delete) {
                    switch (messages[index].content.activity) {
                      case 0:
                        return ShowCallMessage(
                          check: check,
                          messages: messages[index],
                        );
                      case 1:
                        return ShowFileMessage(
                          check: check,
                          messages: messages[index],
                        );
                      case 2:
                        return ShowImageMessage(
                          check: check,
                          messages: messages[index],
                        );
                      case 3:
                        return ShowAudioMessage(
                          check: check,
                          messages: messages[index],
                        );
                      case 4:
                        break;
                      case 5:
                        return ShowTextMessage(
                          check: check,
                          messages: messages[index],
                        );
                      case 6:
                        return ShowContactMessage(
                          check: check,
                          messages: messages[index],
                        );
                      default:
                        return Container();
                    }
                  }
                  return ShowDeleteMessage(check: check);
                },
              ),
            );
          }
          return Expanded(child: Container());
        });
  }
}
