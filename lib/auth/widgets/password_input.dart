import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  RxString get password;
  Rx<String?> get errorText;
  String? Function() get validator;
  String? get hintText;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  // Not focus for default, if widget is settled to be auto focused, this init will make no sense
  bool isOnFocus = false;
  bool _passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: (value) {
        // focus: true
        // not focus on any widget: true
        // focus on other widget: false
        if (value) {
          // reset error text
          widget.errorText.value = null;

          setState(() {
            isOnFocus = !isOnFocus;
          });
        } else {
          setState(() {
            isOnFocus = false;
          });
        }
      },
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Obx(
          () => TextFormField(
            onChanged: widget.password,
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: widget.errorText.value,
              label: const Text(
                "Password",
                style: TextStyle(fontSize: 16),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  _passwordObscure = !_passwordObscure;
                }),
                icon: Icon(
                    _passwordObscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            obscureText: _passwordObscure,
            enableSuggestions: false,
            autocorrect: false,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          ),
        ),
      ),
    );
  }
}
