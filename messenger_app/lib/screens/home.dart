import 'package:flutter/material.dart';
import 'package:messenger_app/data/auth_service.dart';
import 'package:messenger_app/screens/signin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          InkWell(
            onTap: () {
              AuthService().signOut().then((data) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
    );
  }
}
