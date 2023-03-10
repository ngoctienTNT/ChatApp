// TODO: improve UX
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils.dart';

class SendVerificationLinkButton extends StatefulWidget {
  const SendVerificationLinkButton({Key? key}) : super(key: key);

  @override
  State<SendVerificationLinkButton> createState() => _SendVerificationLinkButtonState();
}

class _SendVerificationLinkButtonState extends State<SendVerificationLinkButton> {
  bool isLoading = false;
  bool enabled = true;
  final int timer = 60;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled
          ? () {
              if (isLoading) return;

              setState(() {
                isLoading = true;
              });
              // TODO: bring user to app after click url
              FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
                setState(() {
                  isLoading = false;
                  enabled = false;
                  counter = timer;
                });

                Timer.periodic(const Duration(seconds: 1), (timer) {
                  setState(() {
                    counter--;
                  });

                  if (counter == 0) {
                    setState(() {
                      enabled = true;
                    });
                  }
                });
              }).catchError((e) {
                showError(e);
                Get.back();
              });
            }
          : null,
      child: enabled
          ? (isLoading ? const CircularProgressIndicator() : const Text('Resend verification link'))
          : Text('Please wait ${counter}s to try again'),
    );
  }
}
