import 'dart:io';
import 'package:chat_app/chat/controllers/firebase_controllers.dart';
import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/services/chat.dart';
import 'package:chat_app/chat/widgets/bottom_sheet_file.dart';
import 'package:chat_app/chat/widgets/select_emoji.dart';
import 'package:chat_app/chat/widgets/show_messages.dart';
import 'package:chat_app/chat/widgets/title_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.chatRoom}) : super(key: key);
  final ChatRoom chatRoom;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool show = false;
  bool sendButton = false;
  File? audio;
  late FlutterSoundRecorder recorder = FlutterSoundRecorder();

  @override
  void initState() {
    initRecorder();
    super.initState();
    var collect = FirebaseFirestore.instance
        .collection("private_chats")
        .doc(widget.chatRoom.id)
        .collection("chats");
    collect.orderBy("timestamp", descending: true).limit(1).get().then((value) {
      Messages messages = Messages.fromFirebase(value.docs[0]);
      if (messages.sender != FirebaseAuth.instance.currentUser!.uid &&
          !messages.seen) {
        collect.doc(value.docs[0].id).update({"seen": true});
      }
    });

    _controller.addListener(() {
      setState(() {
        if (_controller.text.isNotEmpty) {
          sendButton = true;
        } else {
          sendButton = false;
        }
      });
    });
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'error';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    audio = File(path!);
    setState(() {});
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
    setState(() {});
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TitleChat(chatRoom: widget.chatRoom),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (show) {
            setState(() => show = false);
          } else {
            Get.back();
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(child: ShowMessages(id: widget.chatRoom.id)),
            const SizedBox(height: 10),
            bottomInput(),
            Expanded(
              flex: show ? 1 : 0,
              child: show ? emojiSelect(_controller) : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomInput() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: Get.width - 60,
                child: Card(
                  margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    focusNode: focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLength: null,
                    maxLines: null,
                    onTap: () {
                      if (show) {
                        setState(() => show = !show);
                      }
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() => sendButton = true);
                      } else {
                        setState(() => sendButton = false);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: IconButton(
                        icon: Icon(
                          show ? Icons.keyboard : Icons.emoji_emotions_outlined,
                        ),
                        onPressed: () {
                          if (!show) {
                            focusNode.unfocus();
                            focusNode.canRequestFocus = false;
                          } else {
                            focusNode.requestFocus();
                          }
                          setState(() => show = !show);
                        },
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (builder) => BottomSheetFile(
                                  chatRoom: widget.chatRoom,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              try {
                                final image = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (image != null) {
                                  List<String> link = [];
                                  link.add(await uploadFile(
                                      File(image.path),
                                      "chats/${widget.chatRoom.id}/image",
                                      "${DateFormat("yyyyMMddhhmmss").format(DateTime.now())}.${image.path.split('.').last}"));
                                  sendMessages(
                                    widget.chatRoom,
                                    ContentMessages(activity: 2, image: link),
                                  );
                                }
                              } on PlatformException catch (_) {}
                            },
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  right: 2,
                  left: 2,
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF128C7E),
                  child: IconButton(
                    icon: Icon(
                      sendButton
                          ? Icons.send
                          : (recorder.isRecording ? Icons.stop : Icons.mic),
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (sendButton) {
                        sendMessages(
                          widget.chatRoom,
                          ContentMessages(activity: 5, text: _controller.text),
                        );
                        _controller.text = "";
                      } else if (recorder.isRecording) {
                        await stop();
                        String link = await uploadFile(
                            audio!,
                            "chats/${widget.chatRoom.id}/recording",
                            "${DateFormat("yyyyMMddhhmmss").format(DateTime.now())}.mp3");
                        sendMessages(
                          widget.chatRoom,
                          ContentMessages(activity: 3, recording: link),
                        );
                      } else {
                        record();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
