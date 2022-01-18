import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/data/auth_cubit.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dorm"),
          centerTitle: true,
        ),
        body: Center(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _EmailAddressTextField(emailController: emailController),
                    const SizedBox(height: 16),
                    _PasswordTextField(passwordController: passwordController),
                    const SizedBox(height: 16),
                    _NameTextField(nameController: nameController),
                    const SizedBox(height: 16),
                    if (state is SignedOutState && state.error != null) ...[
                      Text(state.error!),
                      const SizedBox(height: 16),
                    ] else
                      const SizedBox(height: 32),
                    _SignUpButton(
                        email: emailController,
                        password: passwordController,
                        name: nameController)
                  ],
                ),
              );
            },
          ),
        ));
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).appBarTheme.foregroundColor,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: "Name",
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
      controller: nameController,
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).appBarTheme.foregroundColor,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: "Password",
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
      controller: passwordController,
    );
  }
}

class _EmailAddressTextField extends StatelessWidget {
  const _EmailAddressTextField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).appBarTheme.foregroundColor,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: "Email address",
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
      controller: emailController,
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton(
      {Key? key,
      required this.email,
      required this.password,
      required this.name})
      : super(key: key);

  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          child: Text('Sign up',
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).appBarTheme.backgroundColor)),
          onPressed: state is SignedOutState
              ? () => context
                  .read<AuthCubit>()
                  .signUpWithEmail(email.text, password.text, name.text)
              : null,
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size?>(const Size(250, 40)),
              backgroundColor: MaterialStateProperty.all<Color?>(
                  Theme.of(context).appBarTheme.foregroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      side: BorderSide(
                          width: 3,
                          color: Theme.of(context)
                              .appBarTheme
                              .foregroundColor!)))),
        );
      },
    );
  }
}
