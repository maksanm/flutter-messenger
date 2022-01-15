import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future uploadUserInfoToDatabase(
      String userId, Map<String, dynamic> userInfo) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfo);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: username)
        .where("username", isLessThan: username + 'z')
        .snapshots();
  }
}
