import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger_app/data/auth_cubit.dart';
import 'package:messenger_app/data/database_service.dart';
import 'package:messenger_app/data/shared_preference_service.dart';
import 'package:messenger_app/screens/chat.dart';
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';
import 'package:provider/src/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false, isTyping = false;
  TextEditingController searchController = TextEditingController();
  Stream? usersStream;
  Stream? chatsStream;
  String? myUsername;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    await getMyUsername();
    getChats();
  }

  searchButtonClick() async {
    usersStream =
        await DatabaseService().getUserByUsername(searchController.text);
    setState(() {
      isSearching = true;
    });
  }

  getMyUsername() async {
    myUsername = await SharedPreferenceService().getUsername();
  }

  getChats() async {
    chatsStream = await DatabaseService().getChats(myUsername!);
    setState(() {});
  }

  getIdByUsernames(String username1, String username2) {
    if (username1.compareTo(username2) == 1) {
      return "$username1\_$username2";
    } else {
      return "$username2\_$username1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isTyping == true || isSearching == true) {
          FocusScope.of(context).unfocus();
          searchController.clear();
          isSearching = false;
          isTyping = false;
        } else {
          SystemNavigator.pop();
        }
        return Future.value(false);
      },
      child: Scaffold(
          body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: false,
          centerTitle: true,
          title: const Text('Dorm'),
          actions: [
            GestureDetector(
              onTap: context.read<AuthCubit>().signOut,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.logout),
              ),
            )
          ],
          bottom: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Center(
                child: TextField(
                  controller: searchController,
                  cursorColor: Theme.of(context).appBarTheme.foregroundColor,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 16),
                    hintText: 'Search',
                    prefixIcon: GestureDetector(
                      child: Icon(Icons.arrow_back,
                          color: Theme.of(context).appBarTheme.foregroundColor),
                    ),
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.search,
                          color: Theme.of(context).appBarTheme.foregroundColor),
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
                  onSubmitted: (username) {
                    if (searchController.text != "") {
                      searchButtonClick();
                    } else {
                      setState(() {
                        isSearching = false;
                        isTyping = false;
                      });
                    }
                  },
                  onTap: () {
                    isTyping = true;
                  },
                ),
              ),
            ),
          ),
        ),
        isSearching ? searchList() : chatRooms()
      ])),
    );
  }

  Widget searchList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                DocumentSnapshot docSnapshot = snapshot.data.docs[index];
                if (docSnapshot.data().toString().contains("name")) {
                  return searchTile(docSnapshot["name"],
                      docSnapshot["username"], docSnapshot["profilePhotoUrl"]);
                } else {
                  return Container();
                }
              }, childCount: snapshot.data.docs.length))
            : SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                      child: CircularProgressIndicator(
                          color:
                              Theme.of(context).appBarTheme.foregroundColor)),
                ),
              );
      },
    );
  }

  Widget searchTile(String name, String username, String profilePhotoUrl) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).appBarTheme.foregroundColor!,
                  width: 0.3))),
      child: OpenContainer(
        closedColor: Theme.of(context).appBarTheme.backgroundColor!,
        openColor: Theme.of(context).appBarTheme.backgroundColor!,
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 750),
        closedElevation: 0,
        openBuilder: (context, _) {
          String chatId = getIdByUsernames(myUsername!, username);
          Map<String, dynamic> chatInfo = {
            "users": [myUsername, username]
          };
          DatabaseService().createChat(chatId, chatInfo);
          return Chat(username, name, profilePhotoUrl);
        },
        closedBuilder: (context, _) => Column(
          children: [
            const SizedBox(height: 16),
            Row(children: [
              const SizedBox(width: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  profilePhotoUrl,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(width: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(username,
                      style: const TextStyle(fontSize: 16, color: Colors.grey))
                ],
              )
            ]),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }

  Widget chatRooms() {
    return StreamBuilder(
      stream: chatsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                DocumentSnapshot docSnapshot = snapshot.data.docs[index];
                if (docSnapshot.data().toString().contains("lastMessage")) {
                  return ChatTile(
                      docSnapshot.id
                          .replaceFirst("_", "")
                          .replaceFirst(myUsername!, ""),
                      myUsername!,
                      docSnapshot["lastMessage"],
                      docSnapshot["lastMessageTime"],
                      docSnapshot["lastMessageSendBy"] == myUsername);
                } else {
                  return Container();
                }
              }, childCount: snapshot.data.docs.length))
            : SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                      child: CircularProgressIndicator(
                          color:
                              Theme.of(context).appBarTheme.foregroundColor)),
                ),
              );
      },
    );
  }
}

class ChatTile extends StatefulWidget {
  final String username, myUsername, lastMessage;
  final Timestamp lastMessageTime;
  final bool sendByMe;
  // ignore: use_key_in_widget_constructors
  const ChatTile(this.username, this.myUsername, this.lastMessage,
      this.lastMessageTime, this.sendByMe);

  @override
  State<StatefulWidget> createState() {
    return _ChatTileState();
  }
}

class _ChatTileState extends State<ChatTile> {
  String? name = "", profilePhotoUrl;

  @override
  void initState() {
    getUserInfoFromDatabase();
    super.initState();
  }

  getUserInfoFromDatabase() async {
    var user = await DatabaseService().getUserInfoByUsername(widget.username);
    name = "${user.docs[0]["name"]}";
    profilePhotoUrl = "${user.docs[0]["profilePhotoUrl"]}";
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).appBarTheme.foregroundColor!,
                  width: 0.3))),
      child: OpenContainer(
          closedColor: Theme.of(context).appBarTheme.backgroundColor!,
          openColor: Theme.of(context).appBarTheme.backgroundColor!,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 750),
          closedElevation: 0,
          openBuilder: (context, _) =>
              Chat(widget.username, name!, profilePhotoUrl!),
          closedBuilder: (context, _) {
            WidgetsBinding.instance
                ?.addPostFrameCallback((_) => getUserInfoFromDatabase());
            return Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const SizedBox(width: 20),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: profilePhotoUrl != null
                              ? Image.network(
                                  profilePhotoUrl!,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                )
                              : Container(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  width: 60,
                                  height: 60,
                                )),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          widget.sendByMe
                              ? Column(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const SizedBox(height: 2.0),
                                    const Text(
                                      "You:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 2.0)
                                  ],
                                )
                              : const SizedBox(height: 6.0),
                          widget.lastMessage.length > 27
                              ? Text(
                                  widget.lastMessage.substring(0, 27) + "...",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey))
                              : Text(widget.lastMessage,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey))
                        ],
                      ),
                    ]),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          DateFormat.Hm()
                              .format(widget.lastMessageTime.toDate()),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16)
              ],
            );
          }),
    );
  }
}
