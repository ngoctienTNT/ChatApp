import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowFileMessage extends StatelessWidget {
  const ShowFileMessage({Key? key, required this.check, required this.messages})
      : super(key: key);

  final bool check;
  final Messages messages;

  @override
  Widget build(BuildContext context) {
    String fileName = messages.content.file!;
    fileName = fileName.split("/").last;
    fileName = fileName.split("%2F").last;
    fileName = fileName.split("?").first;
    return MessageWidget(
      messages: messages,
      check: check,
      child: Container(
        alignment: check ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          color: Colors.blue.shade400,
          child: SizedBox(
            height: 50,
            width: Get.width * (2 / 3 - 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
