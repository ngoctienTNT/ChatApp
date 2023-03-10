import 'dart:io';
import 'package:chat_app/chat/controllers/firebase_controllers.dart';
import 'package:chat_app/chat/models/chat_room.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/services/chat.dart';
import 'package:chat_app/chat/widgets/icon_creation.dart';
import 'package:chat_app/chat/widgets/list_contacts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BottomSheetFile extends StatelessWidget {
  const BottomSheetFile({Key? key, required this.chatRoom}) : super(key: key);
  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      width: Get.size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    Icons.insert_drive_file,
                    Colors.indigo,
                    "Document",
                    () async {
                      Get.back();
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);

                      if (result != null) {
                        List<File> files =
                            result.paths.map((path) => File(path!)).toList();
                        if (files.isNotEmpty) {
                          for (File file in files) {
                            String link = await uploadFile(
                                file,
                                "chats/${chatRoom.id}/file/${DateFormat("yyyyMMddhhmmss").format(DateTime.now())}",
                                file.path.split('/').last);
                            sendMessages(
                              chatRoom,
                              ContentMessages(activity: 1, file: link),
                            );
                          }
                        }
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  iconCreation(
                    Icons.camera_alt,
                    Colors.pink,
                    "Camera",
                    () async {
                      Get.back();
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image != null) {
                          List<String> link = [];
                          link.add(await uploadFile(
                              File(image.path),
                              "chats/${chatRoom.id}/image",
                              "${DateFormat("yyyyMMddhhmmss").format(DateTime.now())}.${image.path.split('.').last}"));
                          sendMessages(
                            chatRoom,
                            ContentMessages(activity: 2, image: link),
                          );
                        }
                      } on PlatformException catch (_) {}
                    },
                  ),
                  const SizedBox(width: 40),
                  iconCreation(
                    Icons.insert_photo,
                    Colors.purple,
                    "Gallery",
                    () async {
                      Get.back();
                      try {
                        List<XFile>? images =
                            await ImagePicker().pickMultiImage();
                        List<String> link = [];
                        if (images.isNotEmpty) {
                          for (XFile image in images) {
                            link.add(await uploadFile(
                                File(image.path),
                                "chats/${chatRoom.id}/image",
                                "${DateFormat("yyyyMMddhhmmss").format(DateTime.now())}.${image.path.split('.').last}"));
                          }
                          sendMessages(
                            chatRoom,
                            ContentMessages(activity: 2, image: link),
                          );
                        }
                      } catch (_) {}
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    Icons.headset,
                    Colors.orange,
                    "Audio",
                    () async {
                      Get.back();
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'wav', 'aac'],
                      );

                      if (result != null) {
                        List<File> files =
                            result.paths.map((path) => File(path!)).toList();
                        for (File file in files) {
                          String link = await uploadFile(
                              file,
                              "chats/${chatRoom.id}/recording",
                              "${DateFormat("yyyyMMddhhmmss").format(DateTime.now())}.${file.path.split('.').last}");
                          sendMessages(
                            chatRoom,
                            ContentMessages(activity: 3, recording: link),
                          );
                        }
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  iconCreation(
                    Icons.location_pin,
                    Colors.teal,
                    "Location",
                    () {},
                  ),
                  const SizedBox(width: 40),
                  iconCreation(
                    Icons.person,
                    Colors.blue,
                    "Contact",
                    () {
                      Get.back();
                      Get.to(ListContact(chatRoom: chatRoom));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
