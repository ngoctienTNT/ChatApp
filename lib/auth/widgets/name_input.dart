import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up.dart';

class NameInput extends StatefulWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
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
          SignUpController.inst.nameErrorText.value = null;

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
                return SignUpController.inst.nameValidator();
              }
              return null;
            },
            onChanged: SignUpController.inst.name,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              errorText: SignUpController.inst.nameErrorText.value,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              border: const UnderlineInputBorder(),
              label: const Text("Full Name", style: TextStyle(fontSize: 16)),
            ),
            autofillHints: const [AutofillHints.name],
            textCapitalization: TextCapitalization.words,
          ),
        ),
      ),
    );
  }
}
