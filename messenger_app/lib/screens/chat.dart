import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/data/database_service.dart';
import 'package:messenger_app/data/shared_preference_service.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  final String username, name, profilePhotoUrl;

  const Chat(this.username, this.name, this.profilePhotoUrl);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? chatId, myName, myUsername, myProfilePhotoUrl;
  Stream? messagesStream;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  getInfo() async {
    myUsername = await SharedPreferenceService().getUsername();
    chatId = getIdByUsernames(myUsername!, widget.username);
  }

  getMessages() async {
    messagesStream = await DatabaseService().getChatMessages(chatId!);
    setState(() {});
  }

  getIdByUsernames(String username1, String username2) {
    if (username1.compareTo(username2) == 1) {
      return "$username1\_$username2";
    } else {
      return "$username2\_$username1";
    }
  }

  initialize() async {
    await getInfo();
    getMessages();
  }

  sendMessage() {
    if (messageController.text != "") {
      String message = messageController.text;
      String messageId = randomAlphaNumeric(20);
      messageController.clear();
      DateTime sendTime = DateTime.now();
      Map<String, dynamic> messageInfo = {
        "message": message,
        "sendTime": sendTime,
        "sendBy": myUsername
      };
      Map<String, dynamic> lastMessageInfo = {
        "lastMessage": message,
        "lastMessageTime": sendTime,
        "lastMessageSendBy": myUsername
      };
      DatabaseService()
          .addMessage(chatId!, messageId, messageInfo)
          .then((value) => null);
      DatabaseService().updateLastMessage(chatId!, lastMessageInfo);
    }
  }

  Widget messageTile(String message, Timestamp sendTime, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomRight: sendByMe ? Radius.zero : const Radius.circular(16),
                bottomLeft: sendByMe ? const Radius.circular(16) : Radius.zero),
            color: sendByMe
                ? Theme.of(context).primaryColorDark
                : Theme.of(context).appBarTheme.foregroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LimitedBox(
                maxWidth: 300,
                child: Text(
                  message,
                  maxLines: 10,
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      fontSize: 18),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat.Hm().format(sendTime.toDate()),
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    fontSize: 10),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget messages() {
    return StreamBuilder(
        stream: messagesStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot docSnapshot = snapshot.data.docs[index];
                    return messageTile(
                        docSnapshot["message"],
                        docSnapshot["sendTime"],
                        myUsername == docSnapshot["sendBy"]);
                  },
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                      child: CircularProgressIndicator(
                          color:
                              Theme.of(context).appBarTheme.foregroundColor)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 10,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  widget.profilePhotoUrl,
                  fit: BoxFit.cover,
                  width: 35,
                  height: 35,
                ),
              ),
              const SizedBox(width: 10),
              Text(widget.name),
            ],
          )),
      body: Column(children: [
        Expanded(child: messages()),
        Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.bottomCenter,
          child: TextField(
            style: const TextStyle(fontSize: 18),
            controller: messageController,
            cursorColor: Theme.of(context).appBarTheme.foregroundColor,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16),
              hintText: 'Message',
              suffixIcon: GestureDetector(
                onTap: () {},
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    sendMessage();
                  },
                  child: Icon(Icons.send,
                      color: Theme.of(context).appBarTheme.foregroundColor),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).appBarTheme.foregroundColor!,
                    width: 2.0),
                borderRadius: BorderRadius.circular(16),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).appBarTheme.foregroundColor!,
                    width: 2.0),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onSubmitted: (message) {
              sendMessage();
            },
          ),
        ),
      ]),
    );
  }
}
