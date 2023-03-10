import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static GoogleAuth? _inst;
  GoogleAuth._internal();
  static GoogleAuth get inst {
    _inst ??= GoogleAuth._internal();
    return _inst!;
  }

  static GoogleAuth? get originalInst => _inst;

  GoogleSignIn? _googleSignIn;

  GoogleSignInAccount? _googleUser;
  GoogleSignInAuthentication? _googleAuth;
  OAuthCredential? _credential;

  Future<UserCredential> signIn() async {
    _googleSignIn ??= GoogleSignIn(scopes: ['https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile']);

    // Trigger the authentication flow
    _googleUser = await _googleSignIn!.signIn();

    // Obtain the auth details from the request
    _googleAuth = await _googleUser?.authentication;
    // Create a new credential
    _credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth?.accessToken,
      idToken: _googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(_credential!);
  }

  Future<void> signOut() async {
        await _googleSignIn?.disconnect();
    await _googleSignIn?.signOut();
    _googleSignIn = null;
    _googleUser = null;
    _googleAuth = null;
    _credential = null;
  }
}
