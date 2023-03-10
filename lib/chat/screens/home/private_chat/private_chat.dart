import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_app/chat/controllers/user_item.dart';
import 'package:chat_app/chat/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'bottom_sheet.dart' as bs;
import '../../../../languages/utils.dart';
import '../../../controllers/private_chat.dart';
import '../../../widgets/active_color.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat(this.userId, {this.chatId, Key? key}) : super(key: key);
  final String userId;
  final String? chatId;
  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  late final PrivateChatController chatController;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardShown = false;
  bool isSendButton = false;
  // late FlutterSoundRecorder recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    // initRecorder();
  // TODO: init controller
  }

  // Future initRecorder() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw 'error';
  //   }
  //   await recorder.openRecorder();
  //   recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  // }

  @override
  void dispose() {
    //recorder.closeRecorder();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 25,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromRGBO(150, 150, 150, 1),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: _FriendTitle(chatController.userController),
        actions: [const _CallButton(), const _VideoCallButton(), Obx(() => _FriendOptionButton(chatController.userController.userData['name']))],
      ),
      body: WillPopScope(
        onWillPop: () {
          if (isKeyboardShown) {
            setState(() => isKeyboardShown = false);
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(child: Container()),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: isKeyboardShown ? MediaQuery.of(context).size.height * 0.4 : 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Card(
                            margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              controller: _textController,
                              focusNode: _focusNode,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              onTap: () {
                                if (isKeyboardShown) {
                                  setState(() => isKeyboardShown = !isKeyboardShown);
                                }
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() => isSendButton = true);
                                } else {
                                  setState(() => isSendButton = false);
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: const TextStyle(color: Colors.grey),
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    isKeyboardShown ? Icons.keyboard : Icons.emoji_emotions_outlined,
                                  ),
                                  onPressed: () {
                                    if (!isKeyboardShown) {
                                      _focusNode.unfocus();
                                      _focusNode.canRequestFocus = false;
                                    } else {
                                      _focusNode.requestFocus();
                                    }
                                    setState(() => isKeyboardShown = !isKeyboardShown);
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
                                          builder: (builder) => const bs.BottomSheet()
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.camera_alt),
                                      onPressed: () {},
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
                              icon: const Icon(
                                Icons.send,
                                // isSendButton
                                //     ? Icons.send
                                //     : (recorder.isRecording
                                //         ? Icons.stop
                                //         : Icons.mic),
                                color: Colors.white,
                              ),
                              onPressed: () {
                                print(_textController.text);
                                // else if (recorder.isRecording) {
                                //   stop();
                                // } else {
                                //   record();
                                // }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: isKeyboardShown ? 1 : 0,
                      child: isKeyboardShown ? _EmojiPicker(_textController) : Container(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future stop() async {
  //   final path = await recorder.stopRecorder();
  //   final audio = File(path!);
  //   setState(() {});
  // }

  // Future record() async {
  //   await recorder.startRecorder(toFile: 'audio');
  //   setState(() {});
  // }
}

class _EmojiPicker extends StatelessWidget {
  const _EmojiPicker(this.textController ,{Key? key}) : super(key: key);
final TextEditingController? textController;
  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: textController,
      config: Config(
        columns: 7,
        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        showRecentsTab: true,
        recentsLimit: 28,
        noRecents: const Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ), // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // TODO: CALL FEATURE
      },
      icon: const Icon(
        FontAwesomeIcons.phone,
        size: 20,
        color: Color.fromRGBO(34, 184, 190, 1),
      ),
    );
  }
}

class _VideoCallButton extends StatelessWidget {
  const _VideoCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // TODO: VIDEO CALL FEATURE
      },
      icon: const Icon(
        FontAwesomeIcons.video,
        size: 20,
        color: Color.fromRGBO(34, 184, 190, 1),
      ),
    );
  }
}

class _FriendOptionButton extends StatelessWidget {
  const _FriendOptionButton(this.friendName, {Key? key}) : super(key: key);
  final String friendName;

  PopupMenuItem<int> itemPopup({
    required String text,
    required int index,
    required IconData icon,
    required Color color,
  }) {
    return PopupMenuItem<int>(
      value: index,
      child: Row(
        children: [Icon(icon, color: color), const SizedBox(width: 7), Text(text)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      onSelected: (value) {
        print(value);
      },
      icon: const Icon(
        FontAwesomeIcons.ellipsisVertical,
        size: 20,
        color: Color.fromRGBO(34, 184, 190, 1),
      ),
      itemBuilder: (context) {
        return [
          itemPopup(
            text: 'notifications'.tr,
            icon: FontAwesomeIcons.solidBell,
            color: const Color.fromRGBO(59, 190, 253, 1),
            index: 0,
          ),
          itemPopup(
            text: 'chat_color'.tr,
            icon: FontAwesomeIcons.palette,
            color: const Color.fromRGBO(26, 191, 185, 1),
            index: 1,
          ),
          itemPopup(
            text: 'delete_chat_history'.tr,
            icon: FontAwesomeIcons.trash,
            color: const Color.fromRGBO(255, 113, 150, 1),
            index: 2,
          ),
          itemPopup(
            text: '${'block'.tr} $friendName',
            icon: FontAwesomeIcons.ban,
            color: const Color.fromRGBO(252, 177, 188, 1),
            index: 3,
          ),
        ];
      },
    );
  }
}

class _FriendTitle extends StatelessWidget {
  const _FriendTitle(this.controller, {Key? key}) : super(key: key);
  final UserItemController controller;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max, children: [
      Obx(() => ProfilePicture(controller.userData['profile_picture'])),
      const SizedBox(width: 10),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Obx(() => Text(
                  controller.userData['name'],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                )),
            const SizedBox(height: 5),
            Row(
              children: [
                Obx(() => Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: activeColor(controller.userData['is_active']),
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    )),
                const SizedBox(width: 5),
                Expanded(
                    child: Obx(() => Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(controller.userData['is_active'] ? 'active'.tr : fromLastSeen(controller.userData['last_seen']),
                            style: const TextStyle(color: Colors.grey),
                            presetFontSizes: const [12, 10, 8, 6, 4],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center))))
              ],
            )
          ]))
    ]);
  }
}

