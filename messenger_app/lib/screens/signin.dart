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
          child: ElevatedButton(
              child: Text("Sign in with Google",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).appBarTheme.backgroundColor)),
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size?>(const Size(250, 40)),
                  backgroundColor: MaterialStateProperty.all<Color?>(
                      Theme.of(context).appBarTheme.foregroundColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          side: BorderSide(
                              width: 3,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .foregroundColor!)))),
              onPressed: () => AuthService().signInWithGoogle(context))),
    );
  }
}
