import 'package:flutter/material.dart';

Widget genderWidget(
    {required bool currentGender,
    required bool gender,
    required Function action}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: () {
      action();
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: gender == currentGender ? Colors.white24 : Colors.white,
        border: Border.all(
          color: gender == currentGender ? Colors.black12 : Colors.white,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            gender ? 'Male' : 'Female',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Image.asset(
            gender ? 'assets/images/male.png' : 'assets/images/female.png',
            width: 100,
          ),
        ],
      ),
    ),
  );
}
