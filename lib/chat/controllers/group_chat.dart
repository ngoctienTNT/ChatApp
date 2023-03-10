// import 'dart:async';
// import 'dart:collection';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// import 'user_item.dart';

// // empty chat: listen for currentUser's private_chats[withUser]
// // existing chat: listen for private_chats[chatId]
// class GroupChatController extends GetxController {
//   GroupChatController(this.chatId) {
//     getPreSavedChatDoc().then((doc) {
//       if (doc.exists) {
//         chatId = doc['chat_id'];
//         // listen for private_chats[chatId]
//         getCachedChat().then((_) {
//           listenExistingChat();
//         });
//       } else {
//         // listen for currentUser's private_chats[withUser]
//         listenPreSavedChatDoc();
//       }
//     });
//   }

//   String? chatId;

//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? listener;

//   String get currentUserId => FirebaseAuth.instance.currentUser!.uid;
//   RxMap<String, dynamic> chatContent = <String, dynamic>{}.obs;

//   DocumentReference<Map<String, dynamic>> get existingChatDocRef => FirebaseFirestore.instance.collection('private_chats').doc(chatId);
//   //  open a chat with a user can be with a empty chat content
//   Future<void> getCachedChat() async {
//     return existingChatDocRef.get(const GetOptions(source: Source.cache)).then((doc) {
//       chatContent(doc.data());
//     }).catchError((e) {
//       print(e);
//     }, test: (e) => true);
//   }

//   Future<void> getNewChat() async {
//     return existingChatDocRef.get().then((doc) {
//       chatContent(doc.data());
//     }).catchError((e) {
//       print(e);
//     }, test: (e) => true);
//   }

//   void listenExistingChat() {
//     listener = existingChatDocRef.snapshots().listen((event) {
//       if (event.exists) {
//         chatContent(event.data());
//       } else {
//         chatContent({});
//       }
//     });
//   }

//   void resumeRealtime() {
//     listener?.resume();
//   }

//   void pauseRealtime() {
//     listener?.pause();
//   }
// }

// class PrivateChatControllers {
//   static PrivateChatControllers? _inst;
//   PrivateChatControllers._internal();
//   static PrivateChatControllers get inst {
//     _inst ??= PrivateChatControllers._internal();
//     return _inst!;
//   }

//   HashMap<String, PrivateChatController> controllers = HashMap();
//    PrivateChatController getOrCreate(String uid){
//     var foundController = controllers[uid];

//     if (foundController != null){
//       foundController.resumeRealtime();
//       return foundController;
//     } 

//     controllers[uid] = PrivateChatController(uid);
//     return controllers[uid]!;
//   }

//   void pauseRealtime(String uid){
//     controllers[uid]?.pauseRealtime();
//   }

//   void resumeRealtime(String uid){
//     controllers[uid]?.resumeRealtime();
//   }
// }