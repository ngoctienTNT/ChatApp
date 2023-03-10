import 'package:chat_app/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Image.asset("assets/images/logo.png", width: 150),
            const SizedBox(height: 15),
            const Text(
              "Chat App",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("version 1.0.0"),
            const SizedBox(height: 5),
            const Text("Developed by Trần Ngọc Tiến"),
            const SizedBox(height: 15),
            const Divider(color: Colors.black45, height: 1),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                var url = 'https://fb.com/ngoctien.TNT';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: SizedBox(
                width: 300,
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.facebook,
                      color: Color.fromRGBO(66, 103, 178, 1),
                      size: 40,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Contact me via Facebook",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                var url = 'https://twitter.com/ngoctienTNT';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(29, 161, 242, 1),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Contact me via Twitter",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                var url = 'https://t.me/ngoctienTNT';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: SizedBox(
                width: 300,
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.telegram,
                      color: Color.fromRGBO(0, 136, 204, 1),
                      size: 40,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Contact me viaTelegram",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                String email = 'ngoctienTNT.vn@gmail.com';
                String subject = 'Spending Manager';
                String body = 'Hello Tran Ngoc Tien';

                String emailUrl = "mailto:$email?subject=$subject&body=$body";

                if (await canLaunchUrlString(emailUrl)) {
                  await launchUrlString(emailUrl);
                }
              },
              child: SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Contact me via Email",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                var url = 'https://me.momo.vn/ngoctienTNT';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child:
                  Image.asset("assets/images/buy-me-a-coffee.png", height: 50),
            ),
            const SizedBox(height: 40),
            CustomButton(
              onPress: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ));
              },
              text: "Next",
            ),
          ],
        ),
      ),
    );
  }
}
