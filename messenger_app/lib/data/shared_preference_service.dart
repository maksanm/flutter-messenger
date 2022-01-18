import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String idKey = "IDKEY";
  static const String displayNameKey = "DISPLAYNAMEKEY";
  static const String usernameKey = "USERNAMEKEY";
  static const String profilePictureKey = "PROFILEPICTUREKEY";
  static const String emailKey = "EMAILKEY";

  Future<bool> saveUserId(String userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(idKey, userId);
  }

  Future<bool> saveUserDisplayName(String? userDisplayName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(displayNameKey, userDisplayName!);
  }

  Future<bool> saveUsername(String? username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(usernameKey, username!);
  }

  Future<bool> saveUserEmail(String? userEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(emailKey, userEmail!);
  }

  Future<bool> saveUserProfilePicture(String? userProfilePictureUrl) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(
        profilePictureKey, userProfilePictureUrl!);
  }

  Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(idKey);
  }

  Future<String?> getUserDisplayName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(displayNameKey);
  }

  Future<String?> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(usernameKey);
  }

  Future<String?> getUserProfilePicture() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(profilePictureKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(emailKey);
  }
}
