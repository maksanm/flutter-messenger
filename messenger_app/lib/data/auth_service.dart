import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger_app/data/database_service.dart';
import 'package:messenger_app/data/shared_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SignInResult {
  invalidEmail,
  userDisabled,
  userNotFound,
  emailAlreadyInUse,
  wrongPassword,
  success,
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool get isSignedIn => auth.currentUser != null;
  Stream<bool> get isSignedInStream =>
      auth.userChanges().map((user) => user != null);

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await SharedPreferenceService().saveUserId(user.uid);
        await SharedPreferenceService().saveUserEmail(user.email);
        await SharedPreferenceService().saveUserDisplayName(user.displayName);
        await SharedPreferenceService()
            .saveUsername(user.email!.replaceFirst("@gmail.com", ""));
        await SharedPreferenceService().saveUserProfilePicture(user.photoURL);

        Map<String, dynamic> userInfo = {
          "email": user.email,
          "username": user.email!.replaceFirst("@gmail.com", ""),
          "name": user.displayName,
          "profilePhotoUrl": user.photoURL
        };

        DatabaseService().uploadUserInfoToDatabase(user.uid, userInfo);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    await auth.signOut();
  }

  Future<SignInResult> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      var userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = userCredential.user;
      if (user != null) {
        await SharedPreferenceService().saveUserId(user.uid);
        await SharedPreferenceService().saveUserEmail(user.email);
        await SharedPreferenceService().saveUserDisplayName(user.displayName);
        await SharedPreferenceService()
            .saveUsername(user.email!.replaceFirst("@gmail.com", ""));
        await SharedPreferenceService().saveUserProfilePicture(
            "https://icon-library.com/images/new-user-icon/new-user-icon-15.jpg");
      }

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return SignInResult.invalidEmail;
      } else if (e.code == 'email-already-in-use') {
        return SignInResult.emailAlreadyInUse;
      } else if (e.code == 'user-disabled') {
        return SignInResult.userDisabled;
      } else if (e.code == 'user-not-found') {
        return SignInResult.userNotFound;
      } else if (e.code == 'wrong-password') {
        return SignInResult.wrongPassword;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SignInResult> signUpWithEmail(
      String email, String password, String name) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        user.updateDisplayName(name);
        await SharedPreferenceService().saveUserId(user.uid);
        await SharedPreferenceService().saveUserEmail(user.email);
        await SharedPreferenceService().saveUserDisplayName(name);
        await SharedPreferenceService()
            .saveUsername(user.email!.replaceFirst("@gmail.com", ""));
        await SharedPreferenceService().saveUserProfilePicture(
            "https://icon-library.com/images/new-user-icon/new-user-icon-15.jpg");

        Map<String, dynamic> userInfo = {
          "email": user.email,
          "username": user.email!.substring(0, user.email!.indexOf('@')),
          "name": name,
          "profilePhotoUrl":
              "https://icon-library.com/images/new-user-icon/new-user-icon-15.jpg"
        };

        DatabaseService().uploadUserInfoToDatabase(user.uid, userInfo);
      }

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return SignInResult.invalidEmail;
      } else if (e.code == 'email-already-in-use') {
        return SignInResult.emailAlreadyInUse;
      } else if (e.code == 'user-disabled') {
        return SignInResult.userDisabled;
      } else if (e.code == 'user-not-found') {
        return SignInResult.userNotFound;
      } else if (e.code == 'wrong-password') {
        return SignInResult.wrongPassword;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
