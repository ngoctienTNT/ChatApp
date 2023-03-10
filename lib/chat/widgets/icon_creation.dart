import 'package:flutter/material.dart';

Widget iconCreation(
  IconData icons,
  Color color,
  String text,
  Function onPress,
) {
  return InkWell(
    onTap: () => onPress(),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(icons, size: 29, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontSize: 12))
      ],
    ),
  );
}
