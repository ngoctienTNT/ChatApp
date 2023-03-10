import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/screens/sign_in.dart';
import 'package:chat_app/chat/screens/about.dart';
import 'package:chat_app/chat/screens/profile/edit_profile.dart';
import 'package:chat_app/auth/widgets/custom_button.dart';
import 'package:chat_app/chat/widgets/loading_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:chat_app/chat/models/user.dart' as myuser;
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int language = 0;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    myuser.User user =
                        myuser.User.fromFirebase(snapshot.requireData);
                    return Column(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.image!,
                            width: 150,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => loadingImage(
                              width: 150,
                              height: 150,
                              radius: 90,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 150,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(EditProfile(user: user));
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder>((_) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                );
                              }),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            user.description ?? "Không có mô tả",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Divider(
                          color: Colors.black54,
                          height: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            _showBottomSheet();
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(233, 116, 81, 1),
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.translate_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("Language",
                                  style: TextStyle(fontSize: 18)),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                FontAwesomeIcons.solidMoon,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text("Dark Mode",
                                style: TextStyle(fontSize: 18)),
                            const Spacer(),
                            FlutterSwitch(
                              height: 30,
                              width: 60,
                              value: darkMode,
                              onToggle: (value) {
                                setState(() => darkMode = value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                FontAwesomeIcons.bell,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text("Notification",
                                style: TextStyle(fontSize: 18)),
                            const Spacer(),
                            FlutterSwitch(
                              height: 30,
                              width: 60,
                              value: darkMode,
                              onToggle: (value) {
                                setState(() => darkMode = value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () => Get.to(const About()),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(79, 121, 66, 1),
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  FontAwesomeIcons.circleInfo,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("About",
                                  style: TextStyle(fontSize: 18)),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        CustomButton(
                          onPress: () async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .update({"token": null});
                            await GoogleSignIn().signOut();
                            await FacebookAuth.instance.logOut();
                            await FirebaseAuth.instance.signOut();
                            Get.offAll(const SignIn());
                          },
                          text: "Log out",
                        )
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(left: 20),
          width: double.infinity,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset("assets/images/vietnam.png", width: 70),
                    const Spacer(),
                    const Text(
                      "Tiếng Việt",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: 0,
                      groupValue: language,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset("assets/images/english.png", width: 70),
                    const Spacer(),
                    const Text(
                      "English",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: 1,
                      groupValue: language,
                      onChanged: (value) {},
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
