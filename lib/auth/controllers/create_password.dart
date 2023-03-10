import 'package:chat_app/chat/you_are_in.dart';
import 'package:chat_app/auth/widgets/faded_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'sign_in.dart';

class CreatePasswordController extends GetxController {
  static CreatePasswordController? _inst;
  static CreatePasswordController get inst {
    _inst ??= CreatePasswordController();
    return _inst!;
  }

  var password = ''.obs;
  String? validator() {
    if (!SignInController.inst.passwordRegex.hasMatch(password.value)) {
      return 'Password must be minimum 8 characters, at least one letter and one number';
    }
    return null;
  }

  var error = Rx<String?>(null);

  void validateAndUpdatePassword() {
    // validate
    if (password.isEmpty) {
      FadedOverlay.remove();
      error.value = 'Please enter your password';
      return;
    } else {
      error.value = validator();
      if (error.value != null) {
        FadedOverlay.remove();
        return;
      }
    }

    // update password
    FirebaseAuth.instance.currentUser!.updatePassword(password.value).then((_) {
      FadedOverlay.remove();
      Get.offAll(()=>const YouAreIn());
    }).catchError((e) {
      FadedOverlay.remove();
      Get.snackbar('Error', e.toString());
    });
  }
}
