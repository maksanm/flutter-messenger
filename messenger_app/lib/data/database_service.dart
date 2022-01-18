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

  Future<QuerySnapshot> getUserInfoByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future createChat(String chatId, Map<String, dynamic> chatInfo) async {
    final snapshot =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
    if (snapshot.exists) {
      return true;
    } else {
      FirebaseFirestore.instance.collection("chats").doc(chatId).set(chatInfo);
    }
  }

  Future updateLastMessage(
      String chatId, Map<String, dynamic> lastMessageInfo) async {
    return await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .update(lastMessageInfo);
  }

  Future addMessage(
      String chatId, String messageId, Map<String, dynamic> messageInfo) async {
    return await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .set(messageInfo);
  }

  Future<Stream<QuerySnapshot>> getChatMessages(String chatId) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("sendTime", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChats(String myUsername) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .orderBy("lastMessageTime", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }
}
