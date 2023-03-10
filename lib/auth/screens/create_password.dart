import 'package:chat_app/chat/you_are_in.dart';
import 'package:chat_app/auth/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_password.dart';
import '../widgets/faded_overlay.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Create password')),
        body: Column(
          children: const [
            Text('Hello my new friend'),
            Text('do you want to create a password for primary sign in method?'),
            _PasswordInput(),
            _ContinueButton(),
            _SkipButton(),
            Text('Don\'t worry, you can set it up later')
          ],
        ));
  }
}

class _PasswordInput extends PasswordInput {
  const _PasswordInput({Key? key}) : super(key: key);
  @override
  Rx<String?> get errorText => CreatePasswordController.inst.error;

  @override
  String? get hintText => 'Password must be minimum 8 characters, at least one letter and one number';

  @override
  RxString get password => CreatePasswordController.inst.password;

  @override
  String? Function() get validator => CreatePasswordController.inst.validator;
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){
      FadedOverlay.showLoading(context);
      CreatePasswordController.inst.validateAndUpdatePassword();
    }, child: const Text('Continue'));
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Get.offAll(()=>const YouAreIn());
        },
        child: const Text('Skip'));
  }
}
