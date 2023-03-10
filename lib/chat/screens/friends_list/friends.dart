import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/screens/messages/chat.dart';
import 'package:chat_app/chat/screens/search/search.dart';
import 'package:chat_app/chat/screens/video_call/video_call.dart';
import 'package:chat_app/chat/services/chat.dart';
import 'package:chat_app/chat/widgets/loading_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:chat_app/chat/models/user.dart' as myuser;

class Friends extends StatelessWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [header(), body()]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(26, 157, 196, 1),
                Color.fromRGBO(21, 201, 179, 1)
              ],
            ),
          ),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Friends",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 45,
            width: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              onPressed: () {
                Get.to(const Search());
              },
              child: const Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.black,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget body() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("friends")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> listId = [];
            List<String> listChat = [];
            for (var doc in snapshot.requireData.docs) {
              var data = doc.data() as Map<String, dynamic>;
              listId.add(doc.id);
              listChat.add(data["chat_id"]);
            }
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: listId.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(listId[index])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          myuser.User user =
                              myuser.User.fromFirebase(snapshot.requireData);

                          return itemFriend(listChat[index], user);
                        }

                        return Container();
                      });
                },
              ),
            );
          }

          return Container();
        });
  }

  Widget itemFriend(String chatID, myuser.User user) {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance
            .collection("private_chats")
            .doc(chatID)
            .get()
            .then((value) {
          ChatRoom chatRoom = ChatRoom.fromFirebase(value);
          Get.to(Chat(chatRoom: chatRoom));
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.image!,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => loadingImage(
                      width: 50,
                      height: 50,
                      radius: 90,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                if (user.isActive)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("private_chats")
                    .doc(chatID)
                    .get()
                    .then((value) {
                  ChatRoom chatRoom = ChatRoom.fromFirebase(value);
                  sendMessages(
                    chatRoom,
                    ContentMessages(
                      activity: 0,
                      callDuration: DateTime(2023, 1, 1, 1, 1, 1),
                    ),
                  );
                  Get.to(VideoCall(chatRoom: chatRoom));
                });
              },
              icon: const Icon(
                FontAwesomeIcons.phone,
                color: Color.fromRGBO(77, 189, 204, 1),
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("private_chats")
                    .doc(chatID)
                    .get()
                    .then((value) {
                  ChatRoom chatRoom = ChatRoom.fromFirebase(value);
                  Get.to(Chat(chatRoom: chatRoom));
                });
              },
              icon: const Icon(
                FontAwesomeIcons.comment,
                color: Color.fromRGBO(77, 189, 204, 1),
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
