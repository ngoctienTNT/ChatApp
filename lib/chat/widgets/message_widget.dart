import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/widgets/show_info_reaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<String> react = ["❤", "😯", "😆", "😢", "😠", "👍"];

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key? key,
    required this.child,
    required this.check,
    required this.messages,
  }) : super(key: key);

  final Widget child;
  final bool check;
  final Messages messages;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    Offset tapPosition = Offset.zero;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return GestureDetector(
      onTapDown: (details) => tapPosition = details.globalPosition,
      onLongPress: () {
        showMenu(
          elevation: 0,
          color: Colors.transparent,
          context: context,
          position: RelativeRect.fromLTRB(
            widget.check ? tapPosition.dx : 0,
            tapPosition.dy + 20,
            widget.check ? 0 : tapPosition.dx,
            0,
          ),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              onTap: null,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(react.length, (index) {
                      return InkWell(
                        onTap: () {
                          Map<String, dynamic> reaction =
                              widget.messages.reaction ?? {};

                          if (!(widget.messages.reaction != null &&
                              widget.messages.reaction![uid] == index)) {
                            reaction[uid] = index;
                          } else {
                            reaction.remove(uid);
                          }
                          FirebaseFirestore.instance
                              .collection("private_chats")
                              .doc(widget.messages.chatID)
                              .collection("chats")
                              .doc(widget.messages.id)
                              .update({"reaction": reaction});
                          Get.back();
                        },
                        child: Text(
                          react[index],
                          style: const TextStyle(fontSize: 30),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            if ([5, 6].contains(widget.messages.content.activity))
              PopupMenuItem(
                onTap: () {
                  if (widget.messages.content.activity == 5) {
                    Clipboard.setData(
                        ClipboardData(text: widget.messages.content.text));
                  } else {
                    Clipboard.setData(ClipboardData(
                      text:
                          "${widget.messages.content.contact!.displayName}/n${widget.messages.content.contact!.phones![0].value}",
                    ));
                  }
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Copy", style: TextStyle(fontSize: 16)),
                        Icon(Icons.copy),
                      ],
                    ),
                  ),
                ),
              ),
            PopupMenuItem(
              onTap: () {
                FirebaseFirestore.instance
                    .collection("private_chats")
                    .doc(widget.messages.chatID)
                    .collection("chats")
                    .doc(widget.messages.id)
                    .update({"delete": true});
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Delete", style: TextStyle(fontSize: 16)),
                      Icon(Icons.delete),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.messages.content.activity == 6)
              PopupMenuItem(
                onTap: () {
                  ContactsService.addContact(widget.messages.content.contact!)
                      .then((value) async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Thêm liên hệ Thành công")));
                  });
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Add contact", style: TextStyle(fontSize: 16)),
                        Icon(Icons.person_add_outlined),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      onTap: () => setState(() => show = !show),
      onDoubleTap: () {
        Map<String, dynamic> reaction = widget.messages.reaction ?? {};

        if (!(widget.messages.reaction != null &&
            widget.messages.reaction![uid] == 0)) {
          reaction[uid] = 0;
        } else {
          reaction.remove(uid);
        }
        FirebaseFirestore.instance
            .collection("private_chats")
            .doc(widget.messages.chatID)
            .collection("chats")
            .doc(widget.messages.id)
            .update({"reaction": reaction});
      },
      child: Column(
        children: [
          if (show) const SizedBox(height: 10),
          if (show)
            Text(DateFormat("dd/MM/yyyy HH:mm")
                .format(widget.messages.timestamp)),
          Row(
            children: [
              if (widget.check) Expanded(child: Container()),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: widget.messages.reaction != null ? 8 : 0),
                    child: widget.child,
                  ),
                  if (widget.messages.reaction != null)
                    Positioned(
                      right: 7,
                      bottom: -5,
                      child: InkWell(
                        onTap: () {
                          bottomSheet();
                        },
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: List.generate(
                                  widget.messages.reaction!.keys.length,
                                  (index) {
                                return Text(
                                  react[widget.messages.reaction!.values
                                      .elementAt(index)],
                                  style: const TextStyle(fontSize: 16),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (!widget.check) Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  void bottomSheet() {
    Get.bottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      ShowInfoReaction(messages: widget.messages),
    );
  }
}
