import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowTextMessage extends StatelessWidget {
  const ShowTextMessage({Key? key, required this.check, required this.messages})
      : super(key: key);
  final bool check;
  final Messages messages;

  @override
  Widget build(BuildContext context) {
    return MessageWidget(
      messages: messages,
      check: check,
      child: Container(
        alignment: check ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: Get.width * 2 / 3),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: check ? Colors.blue : Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    messages.content.text!,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
