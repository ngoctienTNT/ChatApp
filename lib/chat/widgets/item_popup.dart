import 'package:flutter/material.dart';

PopupMenuItem<int> itemPopup({
  required String text,
  required int index,
  required IconData icon,
  required Color color,
}) {
  return PopupMenuItem<int>(
    value: index,
    child: Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 7),
        Text(text)
      ],
    ),
  );
}
