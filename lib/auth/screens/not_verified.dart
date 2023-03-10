import 'package:chat_app/auth/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth.dart';
import '../widgets/send_verification_link_button.dart';

class NotVerified extends StatelessWidget {
  const NotVerified({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(title: const Text('Not verified user')),
            body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Your account has not been verifed, please check your mail box for verification link'),
              ElevatedButton(
                  onPressed: () async {
                    await _onWillPop();
                  },
                  child: const Text('Get back')),
              const _NeedHelpButton()
            ])));
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
