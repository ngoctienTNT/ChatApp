import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class EmailInput extends StatefulWidget {
  RxString get email;
  Rx<String?> get errorText;
  String? Function() get validator;

  const EmailInput({super.key});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  // Not focus for default, if widget is settled to be auto focused, this init will make no sense
  bool isOnFocus = false;
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
            // Cant put setState right here
            // when user not input: no error
            // when user input and then leave the field empty: no error
            // when user input and then leave the field with invalid email: error
            validator: (value) {
              if (!isOnFocus && value!.isNotEmpty) {
                return widget.validator();
              }
              return null;
            },
            onChanged: widget.email,
            decoration: InputDecoration(
              errorText: widget.errorText.value,
              prefixIcon: const Icon(Icons.email),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              border: const UnderlineInputBorder(),
              label: const Text("Email", style: TextStyle(fontSize: 16)),
            ),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          ),
        ),
      ),
    );
  }
}
