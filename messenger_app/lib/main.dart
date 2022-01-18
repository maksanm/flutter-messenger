import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/data/auth_service.dart';
import 'package:messenger_app/decorations/theme_provider.dart';
import 'package:messenger_app/screens/home.dart';
import 'package:messenger_app/screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeProvider.lightTheme,
        darkTheme: ThemeProvider.darkTheme,
        home: FutureBuilder(
          future: AuthService().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const SignIn();
            }
          },
        ));
  }
}
