import 'package:chat_app/chat/screens/friends_list/friends.dart';
import 'package:chat_app/chat/screens/messages/chat.dart';
import 'package:chat_app/chat/screens/profile/profile.dart';
import 'package:chat_app/chat/screens/messages/list_chat.dart';
import 'package:chat_app/chat/screens/video_call/video_call.dart';
import 'package:chat_app/chat/services/notification_services.dart';
import 'package:chat_app/chat/services/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class YouAreIn extends StatefulWidget {
  const YouAreIn({Key? key}) : super(key: key);

  @override
  State<YouAreIn> createState() => _YouAreInState();
}

class _YouAreInState extends State<YouAreIn> with WidgetsBindingObserver {
  int currentTab = 0;
  List<Widget> screens = [
    const ListChat(),
    const Friends(),
    const Profile(),
  ];

  DateTime? currentBackPressTime;
  final PageStorageBucket bucket = PageStorageBucket();
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // loadUserData(() {
    //   setState(() => _isLoading = false);
    //   // setUserActive();
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      Map<String, dynamic> data = message.data;

      if (data["status"] == "video_call") {
        Get.to(VideoCall(
          id: data["id"],
          yourToken: data["token"],
        ));
      }

      if (data["screen"] == "chat") {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => Chat(chatRoom: chatRoom),
        // ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              VideoCall(id: data["id"], yourToken: data["token"]),
        ));
      }

      if (message.notification != null &&
          data["status"] != "disable_video_call") {
        RemoteNotification notification = message.notification!;
        print('Message also contained a notification: ${message.notification}');
        NotificationServices.showNotification(
          id: data["id"].hashCode,
          title: notification.title!,
          body: notification.body!,
          fln: flutterLocalNotificationsPlugin,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setUserActive();
    } else {
      setUserOffline();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Scaffold(
    //     body: Center(
    //       child: SizedBox(
    //         width: 100,
    //         child: LoadingIndicator(indicatorType: Indicator.ballPulseRise),
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: screens[currentTab],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 5,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() => currentTab = 0);
                },
                child: Icon(
                  currentTab == 0
                      ? FontAwesomeIcons.solidComment
                      : FontAwesomeIcons.comment,
                  color: currentTab == 0 ? Colors.green : Colors.grey,
                  size: 25,
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() => currentTab = 1);
                },
                child: Icon(
                  currentTab == 1
                      ? FontAwesomeIcons.users
                      : FontAwesomeIcons.users,
                  color: currentTab == 1 ? Colors.green : Colors.grey,
                  size: 25,
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() => currentTab = 2);
                },
                child: Icon(
                  currentTab == 2
                      ? FontAwesomeIcons.solidUser
                      : FontAwesomeIcons.user,
                  color: currentTab == 2 ? Colors.green : Colors.grey,
                  size: 25,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
