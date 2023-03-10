import 'package:chat_app/chat/services/user.dart';
import 'package:flutter/material.dart';

import '../controllers/sign_in.dart';
import 'faded_overlay.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          FadedOverlay.showLoading(context);
          SignInController.inst.signOut();
          setUserOffline();
        },
        child: const Text('Sign out'));
  }
}
