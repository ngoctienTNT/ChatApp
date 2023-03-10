import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/services/chat.dart';
import 'package:chat_app/chat/widgets/item_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class OptionChat extends StatefulWidget {
  const OptionChat({Key? key, required this.chatRoom}) : super(key: key);

  final ChatRoom chatRoom;

  @override
  State<OptionChat> createState() => _OptionChatState();
}

class _OptionChatState extends State<OptionChat> {
  final TextEditingController _name = TextEditingController();
  static const platform = MethodChannel('chat_app.flutter.dev/chatBubble');

  @override
  void initState() {
    super.initState();
    _name.text =
        widget.chatRoom.user1.id == FirebaseAuth.instance.currentUser!.uid
            ? widget.chatRoom.user2.name
            : widget.chatRoom.user1.name;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      onSelected: (value) {
        switch (value) {
          case 0:
            changeNotify(widget.chatRoom);
            break;
          case 1:
            changeNickname();
            break;
          case 2:
            break;
          case 3:
            platform.invokeMethod('showBubbleChat');
            break;
          case 4:
            showDialogDelete(widget.chatRoom);
            break;
          case 5:
            break;
        }
      },
      icon: const Icon(
        FontAwesomeIcons.ellipsisVertical,
        size: 20,
        color: Color.fromRGBO(34, 184, 190, 1),
      ),
      itemBuilder: (context) {
        bool checkUser =
            FirebaseAuth.instance.currentUser!.uid == widget.chatRoom.user1.id;
        bool checkNotify = checkUser
            ? widget.chatRoom.user1.notify
            : widget.chatRoom.user2.notify;
        return [
          itemPopup(
            text: checkNotify ? 'Tắt thông báo' : 'Bật thông báo',
            icon: checkNotify
                ? FontAwesomeIcons.bellSlash
                : FontAwesomeIcons.solidBell,
            color: const Color.fromRGBO(59, 190, 253, 1),
            index: 0,
          ),
          itemPopup(
            text: 'Biệt danh',
            icon: FontAwesomeIcons.penToSquare,
            color: const Color.fromRGBO(59, 190, 253, 1),
            index: 1,
          ),
          itemPopup(
            text: 'Màu sắc',
            icon: FontAwesomeIcons.palette,
            color: const Color.fromRGBO(26, 191, 185, 1),
            index: 2,
          ),
          itemPopup(
            text: 'Bong bóng chat',
            icon: FontAwesomeIcons.circle,
            color: const Color.fromRGBO(26, 191, 185, 1),
            index: 3,
          ),
          itemPopup(
            text: 'Xóa đoạn chat',
            icon: FontAwesomeIcons.trash,
            color: const Color.fromRGBO(255, 113, 150, 1),
            index: 4,
          ),
          itemPopup(
            text: 'Chặn',
            icon: FontAwesomeIcons.ban,
            color: const Color.fromRGBO(252, 177, 188, 1),
            index: 5,
          ),
        ];
      },
    );
  }

  Future changeNickname() async {
    Get.defaultDialog(
      title: "Đổi biệt danh",
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _name,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Hủy",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (widget.chatRoom.user1.id ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      widget.chatRoom.user2.name = _name.text.trim();
                    } else {
                      widget.chatRoom.user1.name = _name.text.trim();
                    }
                    FirebaseFirestore.instance
                        .collection("private_chats")
                        .doc(widget.chatRoom.id)
                        .update(widget.chatRoom.toMap());
                    Get.back();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future showDialogDelete(ChatRoom chatRoom) async {
  Get.defaultDialog(
    title: "Xóa đoạn chat",
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Hủy",
            style: TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            deleteChat(chatRoom);
            Get.back();
          },
          child: const Text(
            "Ok",
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    ),
  );
}
