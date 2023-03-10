import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> emptyUserData() {
  return {
    'name': 'User name',
    'is_active': true,
    'profile_picture': '',
    'friends': [],
    'last_seen': Timestamp.now(),
    "token": "",
  };
}

String defaultAvatar =
    "https://firebasestorage.googleapis.com/v0/b/chatapp-d4407.appspot.com/o/avatar%2Favatar.jpg?alt=media&token=b7a309ac-0c1d-4650-813e-33dcad44fcfc";

Future<void> createNewUserData({String? name}) async {
  final users = FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userId = currentUser.uid;
  var newData = emptyUserData();
  newData['name'] = name ?? currentUser.displayName;
  newData['profile_picture'] = currentUser.photoURL ?? defaultAvatar;
  await users.doc(userId).set(newData);
}

void loadUserData(Function onGetSuccess) async {
  // create user data if null
  final users = FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final doc = await users.doc(userId).get().catchError((e) {
    Get.snackbar('Error loading user data', 'Please try again');
  });

  if (!doc.exists) {
    //create user data
    createNewUserData().then((value) {
      onGetSuccess();
    }).catchError((e) {
      Get.snackbar('Error creating user data', 'Please try again');
    });
  } else {
    onGetSuccess();
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
  final users = FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return await users.doc(userId).get();
}

Future<void> setUserActive() async {
  final users = FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return await users.doc(userId).update({'is_active': true});
}

Future<void> setUserOffline() async {
  final users = FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return await users
      .doc(userId)
      .update({'is_active': false, 'last_seen': DateTime.now()});
}

Future updateToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"token": value});
  });
}
