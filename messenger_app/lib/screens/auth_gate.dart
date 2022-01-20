import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/data/auth_cubit.dart';
import 'package:messenger_app/screens/home.dart';
import 'package:messenger_app/screens/signin.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return state is SignedInState ? const Home() : const SignIn();
      },
    );
  }
}
