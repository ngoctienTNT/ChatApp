import 'package:chat_app/auth/screens/forgot_password.dart';
import 'package:chat_app/auth/screens/sign_up.dart';
import 'package:chat_app/auth/widgets/custom_button.dart';
import 'package:chat_app/auth/widgets/facebook_button.dart';
import 'package:chat_app/auth/widgets/faded_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_in.dart';
import '../widgets/email_input.dart';
import '../widgets/google_button.dart';
import '../widgets/password_input.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onVerticalDragEnd: (DragEndDetails details) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // appBar: AppBar(title: const Text('Sign In')),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 30),
                  Image.asset("assets/images/chat.png", width: 80),
                  const SizedBox(height: 30),
                  const _EmailInput(),
                  const SizedBox(height: 20),
                  const _PasswordInput(),
                  const _ForgotPassword(),
                  const _SignInButton(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(const SignUp());
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Or'),
                  const SizedBox(height: 10),
                  const GoogleButton(),
                  const SizedBox(height: 10),
                  const FacebookButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPress: () {
        FadedOverlay.showLoading(context);
        SignInController.inst.validateEmailAndSignIn();
      },
      text: 'Sign In',
    );
  }
}

class _EmailInput extends EmailInput {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  RxString get email => SignInController.inst.email;

  @override
  Rx<String?> get errorText => SignInController.inst.emailErrorText;

  @override
  String? Function() get validator => SignInController.inst.emailValidator;
}

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.to(() => const ForgotPassword());
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}

class _PasswordInput extends PasswordInput {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Rx<String?> get errorText => SignInController.inst.passwordErrorText;

  @override
  RxString get password => SignInController.inst.password;

  @override
  String? Function() get validator => SignInController.inst.passwordValidator;

  @override
  String? get hintText => null;
}
