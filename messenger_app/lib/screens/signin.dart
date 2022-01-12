import 'package:flutter/material.dart';
import 'package:messenger_app/data/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Messenger")),
        body: Center(
          child: MaterialButton(
              color: Colors.blue,
              onPressed: () => AuthService().signInWithGoogle(context)),
        ));
  }
}
