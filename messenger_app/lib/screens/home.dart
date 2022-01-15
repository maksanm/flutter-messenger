import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:messenger_app/data/auth_service.dart';
import 'package:messenger_app/data/database_service.dart';
import 'package:messenger_app/screens/signin.dart';
=======
>>>>>>> parent of b8943ec (Added themes and other changes)

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  Stream? usersStream;

  searchButtonClick() async {
    usersStream =
        await DatabaseService().getUserByUsername(searchController.text);
    setState(() {
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
        body: CustomScrollView(slivers: [
      SliverAppBar(
        floating: true,
        pinned: true,
        snap: false,
        title: const Text('Home'),
        actions: [
          InkWell(
            onTap: () {
              AuthService().signOut().then((data) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const SignIn()));
              });
            },
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
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).appBarTheme.foregroundColor),
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
                  }
                },
              ),
            ),
          ),
        ),
      ),
      isSearching ? searchList() : chatRooms(),
    ]));
  }

  Widget searchList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SliverList(delegate: SliverChildBuilderDelegate(
                (context, index) {
                  DocumentSnapshot docSnapshot = snapshot.data.docs[index];
                  return searchTile(docSnapshot["name"] + index,
                      docSnapshot["username"], docSnapshot["profilePhotoUrl"]);
                },
              )) /*ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot docSnapshot = snapshot.data.docs[index];
                  return searchTile(docSnapshot["name"],
                      docSnapshot["username"], docSnapshot["profilePhotoUrl"]);
                })*/
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
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(children: [
            const SizedBox(width: 22),
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.network(
                profilePhotoUrl,
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
=======
      appBar: AppBar(title: const Text("Messenger")),
>>>>>>> parent of b8943ec (Added themes and other changes)
    );
  }

  Widget chatRooms() {
    return SliverToBoxAdapter(child: Spacer());
  }
}
