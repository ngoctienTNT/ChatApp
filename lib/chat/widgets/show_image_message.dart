import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat/models/content_messages.dart';
import 'package:chat_app/chat/models/messages.dart';
import 'package:chat_app/chat/screens/messages/view_image.dart';
import 'package:chat_app/chat/widgets/loading_image.dart';
import 'package:chat_app/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowImageMessage extends StatelessWidget {
  const ShowImageMessage(
      {Key? key, required this.messages, required this.check})
      : super(key: key);

  final bool check;
  final Messages messages;

  @override
  Widget build(BuildContext context) {
    ContentMessages content = messages.content;
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
              padding: const EdgeInsets.all(5),
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                alignment: check ? WrapAlignment.end : WrapAlignment.start,
                children: List.generate(content.image!.length, (index) {
                  return InkWell(
                    onTap: () {
                      Get.to(ViewImage(url: content.image![index]));
                    },
                    child: getImage(content, index),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImage(ContentMessages content, int index) {
    if (content.image!.length > 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: content.image![index],
          width: Get.width * 2 / 9 - 6,
          height: Get.width * 2 / 9 - 6,
          fit: BoxFit.cover,
          placeholder: (context, url) => loadingImage(
            width: Get.width * 2 / 9 - 6,
            height: Get.width * 2 / 9 - 6,
            radius: 5,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    }
    if (content.image!.length == 2) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: content.image![index],
          width: Get.width * 2 / 6 - 6,
          height: Get.width * 2 / 6 - 6,
          fit: BoxFit.cover,
          placeholder: (context, url) => loadingImage(
            width: Get.width * 2 / 6 - 6,
            height: Get.width * 2 / 6 - 6,
            radius: 5,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: content.image![index],
        width: Get.width * 2 / 3,
        fit: BoxFit.cover,
        placeholder: (context, url) => loadingImage(
          width: Get.width * 2 / 3,
          height: Get.width * 2 / 3,
          radius: 5,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
