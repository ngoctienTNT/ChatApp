import 'dart:async';

import 'package:chat_app/auth/screens/verify_page.dart';
import 'package:chat_app/chat/services/user.dart';
import 'package:chat_app/chat/you_are_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils.dart';
import '../screens/sign_in.dart';
import '../screens/sign_up.dart';
import '../services/auth.dart';
import '../services/facebook_auth.dart';
import '../widgets/faded_overlay.dart';
import '../widgets/send_verification_link_button.dart';

// TODO
// remember password
// start loading should be placed here
class SignInController extends GetxController {
  static SignInController? _inst;
  static SignInController get inst {
    _inst ??= SignInController();
    return _inst!;
  }

  //var usingEmail = true.obs;

  //#region EMAIL
  final email = ''.obs;

  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  String? emailValidator() {
    if (!emailRegex.hasMatch(email.value)) {
      return 'Please enter a valid email!';
    }

    return null;
  }

  var emailErrorText = Rx<String?>(null);
  //#endregion

  //#region PHONE NUMBER
  // var phoneNumber = ''.obs;
  // RegExp phoneRegex = RegExp(r'^[0-9]{10}');
  // String? phoneNumberValidator() {
  //   if (!phoneRegex.hasMatch(phoneNumber.value)) {
  //     return 'Please enter a 10 digits phone number!';
  //   }

  //   return null;
  // }

  // var phoneNumberErrorText = Rx<String?>(null);
  //#endregion

  //#region PASSWORD
  var password = ''.obs;
  // Minimum eight characters, at least one letter and one number:
  RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  String? passwordValidator() {
    if (!passwordRegex.hasMatch(password.value)) {
      return 'Password must be minimum 8 characters, at least one letter and one number';
    }
    return null;
  }

  var passwordErrorText = Rx<String?>(null);
  //#endregion

  void validateEmailAndSignIn() async {
    var validationSuccess = true;
    var fullInput = true;

    // validate password
    if (password.value.isEmpty) {
      passwordErrorText.value = 'Please enter your password!';
      fullInput = false;
      validationSuccess = false;
    } else if (passwordValidator() != null) {
      validationSuccess = false;
    }

    // validate email
    if (email.isEmpty) {
      emailErrorText.value = 'Please enter your email!';
      fullInput = false;
      validationSuccess = false;
    } else if (emailValidator() != null) {
      validationSuccess = false;
    }

    if (validationSuccess) {
      await _onSuccessValidation();
      return;
    } else {
      FadedOverlay.remove();
      if (fullInput) {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'wrong user id or password',
          textConfirm: 'OK',
          onConfirm: () {
            Get.back();
          },
        );
      }
    }
  }

  void signOut() async {
    // reset email and password
    email('');
    password('');

    await Auth.signOut().then((_) {
      Get.offAll(() => const SignIn());
    }).catchError((e) {
      showError(e);
    });

    FadedOverlay.remove();
  }

  Future<void> _onSuccessValidation() async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      FadedOverlay.remove();
      if (!credentials.user!.emailVerified) {
        Get.off(const VerifyPage());
        // await _promptUserToVerifyEmail(credentials);
        return;
      }

      await FbAuth.originalInst?.linkCredentials(email.value);
      updateToken();

      Get.to(() => const YouAreIn());
    } on FirebaseAuthException catch (e) {
      FadedOverlay.remove();

      switch (e.code) {
        case 'invalid-email':
          emailErrorText.value = 'Invalid email, please try again';
          break;
        case 'user-disabled':
          showError(
              'Your account is disabled, please contract admin for support.');
          break;
        case 'user-not-found':
          Get.defaultDialog(
              title: 'We could not find your account',
              middleText:
                  'Looks like you are new to us, try signing up to our system',
              textConfirm: 'Sign up',
              onConfirm: () {
                Get.offAll(() => const SignUp());
              });
          break;
        case 'wrong-password':
          Get.defaultDialog(
            title: 'Error',
            middleText: 'wrong user id or password',
            textConfirm: 'OK',
            onConfirm: () {
              Get.back();
            },
          );
          break;
      }
    } catch (e) {
      FadedOverlay.remove();
      showError(e);
    }
    return;
  }
}

Future<void> _promptUserToVerifyEmail(UserCredential credential) async {
  await Get.defaultDialog(
      barrierDismissible: false,
      title: 'Verify your email',
      content: Column(children: const [
        Text('Please check your mail box to verify your email'),
        _NeedHelpButton()
      ]),
      textConfirm: 'OK',
      onConfirm: () async {
        // sign out
        await FirebaseAuth.instance.signOut();
        Get.back();
      },
      onWillPop: () async {
        // sign out
        await FirebaseAuth.instance.signOut();
        return true;
      });
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
            // quit this dialog
            Get.back();

            /// show need_help dialog, sign out on pop out
            Get.defaultDialog(
                barrierDismissible: false,
                title: 'Support',
                content: Column(children: const [
                  Text(
                      'You don\'t see the mail? Please check other places such as spam box'),
                  Text('Or'),
                  SendVerificationLinkButton()
                ]),
                onWillPop: () async {
                  // sign out
                  await FirebaseAuth.instance.signOut();
                  return true;
                });
          },
        ));
  }
}
