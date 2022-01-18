import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/data/auth_cubit.dart';
import 'package:messenger_app/screens/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dorm"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    _EmailAddressTextField(emailController: emailController),
                    const SizedBox(height: 16),
                    _PasswordTextField(passwordController: passwordController),
                    const SizedBox(height: 16),
                    if (state is SignedOutState && state.error != null) ...[
                      Text(state.error!),
                      const SizedBox(height: 16),
                    ] else
                      const SizedBox(height: 32),
                    _SignInButton(
                      email: emailController,
                      password: passwordController,
                    )
                  ],
                ),
              );
            },
          ),
          const _SignUpButton(),
          const SizedBox(height: 16),
          Text("or",
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).appBarTheme.foregroundColor)),
          const SizedBox(height: 16),
          const _SignInWithGoogleButton(),
        ],
      )),
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
        hintText: 'Password',
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
        hintText: 'Email address',
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
  const _SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text("Sign up",
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).appBarTheme.backgroundColor)),
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size?>(const Size(250, 40)),
            backgroundColor: MaterialStateProperty.all<Color?>(
                Theme.of(context).appBarTheme.foregroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    side: BorderSide(
                        width: 3,
                        color:
                            Theme.of(context).appBarTheme.foregroundColor!)))),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SignUp())));
  }
}

class _SignInWithGoogleButton extends StatelessWidget {
  const _SignInWithGoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return ElevatedButton(
        child: Text("Sign in with Google",
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).appBarTheme.backgroundColor)),
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size?>(const Size(250, 40)),
            backgroundColor: MaterialStateProperty.all<Color?>(
                Theme.of(context).appBarTheme.foregroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    side: BorderSide(
                        width: 3,
                        color:
                            Theme.of(context).appBarTheme.foregroundColor!)))),
        onPressed: state is SignedOutState
            ? () => context.read<AuthCubit>().signInWithGoogle()
            : null,
      );
    });
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  final TextEditingController email;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
            child: Text('Sign in',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).appBarTheme.backgroundColor)),
            onPressed: state is SignedOutState
                ? () => context.read<AuthCubit>().signInWithEmail(
                      email.text,
                      password.text,
                    )
                : null,
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
                                .foregroundColor!)))));
      },
    );
  }
}
