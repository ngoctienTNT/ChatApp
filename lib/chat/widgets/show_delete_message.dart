import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDeleteMessage extends StatelessWidget {
  const ShowDeleteMessage({Key? key, required this.check}) : super(key: key);
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: check ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 2 / 3),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Đã thu hồi tin nhắn",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
