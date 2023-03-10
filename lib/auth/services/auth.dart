import 'package:firebase_auth/firebase_auth.dart';

import 'facebook_auth.dart';
import 'google_auth.dart';

class Auth {
  static Future<void> signOut() async {
    await GoogleAuth.originalInst?.signOut();
    await FbAuth.originalInst?.signOut();
    // sign out
    await FirebaseAuth.instance.signOut();
  }
}
