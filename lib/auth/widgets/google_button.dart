import 'package:chat_app/chat/services/user.dart';
import 'package:chat_app/chat/you_are_in.dart';
import 'package:chat_app/auth/services/facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../screens/create_password.dart';
import '../services/google_auth.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.red[400],
        ),
        onPressed: () {
          // with this sign in method, user email will be verified along the way
          GoogleAuth.inst.signIn().then((credentials) async {
            await FbAuth.originalInst
                ?.linkCredentials(credentials.user!.email!);
            if (credentials.additionalUserInfo!.isNewUser) {
              // suggest create a password for primary sign in method
              createNewUserData();
              Get.offAll(() => const CreatePassword());
            } else {
              Get.offAll(() => const YouAreIn());
            }
            updateToken();
          }).catchError((e) {
            //Get.snackbar('Google Sign In Error', e.toString());
          });
        },
        child: Row(
          children: const [
            SizedBox(
                width: 60, child: Center(child: Icon(FontAwesomeIcons.google))),
            VerticalDivider(
              color: Colors.white,
              width: 1,
              endIndent: 7,
              indent: 7,
            ),
            Spacer(),
            Text(
              "Sign In with Google",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
