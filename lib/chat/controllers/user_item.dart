import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/user.dart' as dt;

// auto enable realtime when init
class UserItemController extends GetxController {
  UserItemController(this.uid) {
    getCachedUserData().then((_) => listenForChanges());
    getCachedFriendStatus().then((_) => listenFriendStatus());
    print('user item $uid listening');
  }

  final String uid;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userDatalistener;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      friendStatusListener;

  final isFriend = false.obs;
  RxMap<String, dynamic> userData = dt.emptyUserData().obs;

  DocumentReference<Map<String, dynamic>> get userDocRef =>
      FirebaseFirestore.instance.collection('users').doc(uid);
  DocumentReference<Map<String, dynamic>> get friendDocRef =>
      FirebaseFirestore.instance
          .collection('users/$currentUserId/friends')
          .doc(uid);
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> getCachedUserData() async {
    return userDocRef.get(const GetOptions(source: Source.cache)).then((doc) {
      userData(doc.data());
    }).catchError((e) {}, test: (e) => true);
  }

  Future<void> getCachedFriendStatus() async {
    return friendDocRef.get(const GetOptions(source: Source.cache)).then((doc) {
      isFriend(doc.exists);
    }).catchError((e) {}, test: (e) => true);
  }

  void listenFriendStatus() {
    friendStatusListener = friendDocRef.snapshots().listen((event) {
      isFriend(event.exists);
    });
  }

  void listenForChanges() {
    userDatalistener = userDocRef.snapshots().listen((event) {
      if (event.exists) {
        userData(event.data());
      } else {
        userData(dt.emptyUserData());
      }
    });
  }

  void resumeRealtime() {
    userDatalistener?.resume();
    friendStatusListener?.resume();
  }

  void pauseRealtime() {
    userDatalistener?.pause();
    friendStatusListener?.pause();
  }

  @override
  void dispose() {
    userDatalistener?.cancel();
    friendStatusListener?.cancel();
    super.dispose();
  }
}

class UserItemControllers {
  static UserItemControllers? _inst;
  UserItemControllers._internal();
  static UserItemControllers get inst {
    _inst ??= UserItemControllers._internal();
    return _inst!;
  }

  HashMap<String, UserItemController> controllers = HashMap();

  // enable realtime and return controller
  UserItemController getOrCreate(String uid) {
    var foundController = controllers[uid];

    if (foundController != null) {
      return foundController;
    }

    controllers[uid] = UserItemController(uid);
    return controllers[uid]!;
  }

  void pauseRealtime(String uid) {
    print('user item $uid pause realtime');
    controllers[uid]?.pauseRealtime();
  }

  void resumeRealtime(String uid) {
    print('user item $uid listening');
    controllers[uid]?.resumeRealtime();
  }

  void dispose() {
    controllers.entries.map((item) => item.value.dispose());
  }
}
