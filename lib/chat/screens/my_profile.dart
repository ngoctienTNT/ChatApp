import 'package:chat_app/auth/widgets/sign_out_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/profile_picture.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [Text('hello'.tr),
      ProfilePicture(FirebaseAuth.instance.currentUser!.photoURL),
      TextButton(child: Text('Present lang is ${Get.locale}'),onPressed: (){
        if (Get.locale == const Locale('en', 'US')) {
          Get.updateLocale(const Locale('vi', 'VN'));
        } else {
          Get.updateLocale(const Locale('en', 'US'));
        }
      },),const SignOutButton()
      ],
    ));
  }
}
