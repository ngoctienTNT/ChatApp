import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/widgets/loading_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/chat/models/user.dart' as myuser;

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.chatRoom}) : super(key: key);
  final ChatRoom chatRoom;

  String getOfflineTime(DateTime dateTime) {
    if (DateTime.now().difference(dateTime).inSeconds < 60) {
      return "${DateTime.now().difference(dateTime).inSeconds.abs()} giây trước";
    }
    if (DateTime.now().difference(dateTime).inMinutes < 60) {
      return "${DateTime.now().difference(dateTime).inMinutes.abs()} phút trước";
    }
    if (DateTime.now().difference(dateTime).inHours < 24) {
      return "${DateTime.now().difference(dateTime).inHours.abs()} giờ trước";
    }
    return "${DateTime.now().difference(dateTime).inDays.abs()} ngày trước";
  }

  @override
  Widget build(BuildContext context) {
    String id = FirebaseAuth.instance.currentUser!.uid == chatRoom.user1.id
        ? chatRoom.user2.id
        : chatRoom.user1.id;
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            myuser.User user = myuser.User.fromFirebase(snapshot.requireData);
            String offline =
                user.isActive ? "" : getOfflineTime(user.lastSeen!);
            return Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.image!,
                    width: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => loadingImage(
                      width: 40,
                      height: 40,
                      radius: 90,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatRoom.user1.id.compareTo(
                                    FirebaseAuth.instance.currentUser!.uid) ==
                                0
                            ? chatRoom.user2.name
                            : chatRoom.user1.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (user.isActive)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                          if (user.isActive) const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              user.isActive
                                  ? "Đang hoạt động"
                                  : "Hoạt động $offline",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }

          return Container();
        });
  }
}
