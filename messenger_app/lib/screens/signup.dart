import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/data/auth_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  File? profilePhoto;
  String? profilePhotoUrl;
  final picker = ImagePicker();
  final defaultProfilePhotoUrl =
      "https://freesvg.org/img/abstract-user-flat-4.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign up"),
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
                    GestureDetector(
                        onTap: () {
                          showSelectionDialog();
                        },
                        child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: profilePhoto != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(profilePhoto!))
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            defaultProfilePhotoUrl))))),
                    const SizedBox(height: 16),
                    const Text("Select profile photo",
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 18),
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
                      name: nameController,
                      profilePhotoUrl: profilePhotoUrl == null
                          ? defaultProfilePhotoUrl
                          : profilePhotoUrl!,
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

  Future showSelectionDialog() async {
    await showDialog(
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Select photo'),
          actions: <Widget>[
            TextButton(
              child: Text('From gallery',
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor)),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Take a photo',
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor)),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      profilePhoto = File(pickedFile.path);
      profilePhotoUrl = await uploadImageToFirebaseStorage(context);
    }
    setState(() {});
  }

  Future<String> uploadImageToFirebaseStorage(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String photoId = randomAlphaNumeric(20);
    Reference ref = storage.ref().child(photoId);
    await ref.putFile(profilePhoto!);
    return await storage.ref(photoId).getDownloadURL();
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

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).appBarTheme.foregroundColor,
      style: const TextStyle(fontSize: 18),
      obscureText: !passwordVisible,
      decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
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
      controller: widget.passwordController,
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
      required this.name,
      required this.profilePhotoUrl})
      : super(key: key);

  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController name;
  final String profilePhotoUrl;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) =>
          state is SignedInState ? Navigator.pop(context) : null,
      builder: (context, state) {
        return ElevatedButton(
          child: Text('Sign up',
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).appBarTheme.backgroundColor)),
          onPressed: () {
            if (state is SignedOutState) {
              context.read<AuthCubit>().signUpWithEmail(
                  email.text, password.text, name.text, profilePhotoUrl);
            }
          },
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
