// import 'package:chat_app/auth/controllers/sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// // TODO
// // styling widget
// class PhoneNumberInput extends StatefulWidget {
//   const PhoneNumberInput({Key? key}) : super(key: key);

//   @override
//   State<PhoneNumberInput> createState() => _PhoneNumberInputState();
// }

// class _PhoneNumberInputState extends State<PhoneNumberInput> {
//   // Not focus for default, if widget is settled to be auto focused, this init will make no sense
//   bool isOnFocus = false;
//   @override
//   Widget build(BuildContext context) {
//     return FocusScope(
//         onFocusChange: (value) {
//           // focus: true
//           // not focus on any widget: true
//           // focus on other widget: false
//           if (value) {
//             // reset error text
//             SignInController.inst.phoneNumberErrorText.value = null;

//             setState(() {
//               isOnFocus = !isOnFocus;
//             });
//           } else {
//             setState(() {
//               isOnFocus = false;
//             });
//           }
//         },
//         child: Form(
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: Obx(()=>TextFormField(
//               // Cant put setState right here
//               // when user not input: no error
//               // when user input and then leave the field empty: no error
//               // when user input and then leave the field with invalid phone: error
//               validator: (value) {
//                 if (!isOnFocus && value!.isNotEmpty) {
//                   return SignInController.inst.phoneNumberValidator();
//                 }
//                 return null;
//               },
//               onChanged: SignInController.inst.phoneNumber,
//               decoration: InputDecoration(
//                   errorText: SignInController.inst.phoneNumberErrorText.value,
//                   border: const OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.phone_android),
//                   labelText: 'Phone number'),
//               keyboardType: TextInputType.phone,
//               autofillHints: const [AutofillHints.telephoneNumber],
//               // input formatters base on SignInController.inst.validatePhone()
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//             ))));
//   }
// }
