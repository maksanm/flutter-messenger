import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future uploadUserInfoToDatabase(
      String userId, Map<String, dynamic> userInfo) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfo);
  }
}
