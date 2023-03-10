import 'dart:math';
import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowContactMessage extends StatelessWidget {
  const ShowContactMessage(
      {Key? key, required this.check, required this.messages})
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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.blue.shade400,
          child: SizedBox(
            height: 60,
            width: Get.width / 2,
            child: Row(
              children: [
                const Spacer(),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: const Color(0xff262626),
                  ),
                  child: Center(
                    child: Text(
                      messages.content.contact!.displayName![0],
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        messages.content.contact!.displayName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        messages.content.contact!.phones![0].value!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
