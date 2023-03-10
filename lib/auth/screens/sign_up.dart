import 'package:chat_app/auth/screens/sign_in.dart';
import 'package:chat_app/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up.dart';
import '../widgets/email_input.dart';
import '../widgets/faded_overlay.dart';
import '../widgets/name_input.dart';
import '../widgets/password_input.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onVerticalDragEnd: (DragEndDetails details) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // appBar: AppBar(title: const Text('Sign Up')),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 30),
                  Image.asset("assets/images/chat.png", width: 60),
                  const SizedBox(height: 30),
                  const NameInput(),
                  const SizedBox(height: 20),
                  const _EmailInput(),
                  const SizedBox(height: 20),
                  const _PasswordInput(),
                  const SizedBox(height: 50),
                  const _SignUpButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(const SignIn());
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPress: () {
        FadedOverlay.showLoading(context);
        SignUpController.inst.validateAndSignUp();
      },
      text: "Sign Up",
    );
  }
}

class _EmailInput extends EmailInput {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  RxString get email => SignUpController.inst.email;

  @override
  Rx<String?> get errorText => SignUpController.inst.emailErrorText;

  @override
  String? Function() get validator => SignUpController.inst.emailValidator;
}

class _PasswordInput extends PasswordInput {
  const _PasswordInput({Key? key}) : super(key: key);
  @override
  Rx<String?> get errorText => SignUpController.inst.passwordErrorText;

  @override
  RxString get password => SignUpController.inst.password;

  @override
  String? Function() get validator => SignUpController.inst.passwordValidator;

  @override
  String? get hintText => SignUpController.inst.passwordHint;
}
