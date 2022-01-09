import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger_app/data/shared_preference_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User? user = userCredential.user;
    if (user != null) {
      SharedPreferenceService().saveUserId(user.uid);
      SharedPreferenceService().saveUserEmail(user.email);
      SharedPreferenceService().saveUserDisplayName(user.displayName);
      SharedPreferenceService().saveUserProfilePicture(user.photoURL);
    }
  }
}
