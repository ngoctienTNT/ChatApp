import 'package:chat_app/auth/screens/create_password.dart';
import 'package:chat_app/auth/screens/sign_in.dart';
import 'package:chat_app/chat/you_are_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth.dart';
import '../widgets/send_verification_link_button.dart';

// get back: sign out
// continue: you are in
class EmailVerification extends StatelessWidget {
  const EmailVerification({Key? key, this.isNewUser = false}) : super(key: key);
  final bool isNewUser;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Email verification'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please check you mail box for verification link'),
                const _NeedHelpButton(),
                ElevatedButton(
                    onPressed: () async {
                      // check if the email is verified
                      await FirebaseAuth.instance.currentUser!.reload();
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        if (isNewUser) {
                          Get.offAll(()=>const CreatePassword());
                        } else {
                          Get.offAll(()=>const YouAreIn());
                        }
                      } else {
                        Get.snackbar('Verification Error', 'Please try again');
                      }
                    },
                    child: const Text('Done, take me in'))
              ],
            )));
  }
}

Future<bool> _onWillPop() async {
  await Auth.signOut();
  Get.offAll(()=>const SignIn());
  return true;
}

class _NeedHelpButton extends StatelessWidget {
  const _NeedHelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text('Need help?'),
        onPressed: () {
          Get.defaultDialog(
            barrierDismissible: false,
            title: 'Support',
            content: Column(children: const [
              Text('You don\'t see the mail? Please check other places such as spam box'),
              Text('Or'),
              SendVerificationLinkButton()
            ]),
          );
        },
      ),
    );
  }
}
