import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/data/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService})
      : super(authService.isSignedIn
            ? const SignedInState()
            : const SignedOutState());

  final AuthService authService;

  Future<void> signInWithEmail(
    String email,
    String password,
  ) async {
    emit(const SigningInState());

    try {
      final res = await authService.signInWithEmail(email, password);

      switch (res) {
        case SignInResult.success:
          emit(const SignedInState());
          break;
        case SignInResult.emailAlreadyInUse:
          emit(const SignedOutState(
              error: 'This email address is already in use'));
          break;
        case SignInResult.invalidEmail:
          emit(const SignedOutState(error: 'This email address is invalid'));
          break;
        case SignInResult.userDisabled:
          emit(const SignedOutState(error: 'This user has been banned'));
          break;
        case SignInResult.userNotFound:
          emit(const SignedOutState(error: 'User does not exist'));
          break;
        case SignInResult.wrongPassword:
          emit(const SignedOutState(error: 'Invalid credentials'));
          break;
      }
    } catch (_) {
      emit(const SignedOutState(error: 'Unexpected error.'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const SigningInState());

    try {
      final res = await authService.signInWithGoogle();

      if (res) {
        emit(const SignedInState());
      } else {
        emit(const SignedOutState(error: 'Unexpected error.'));
      }
    } catch (_) {
      emit(const SignedOutState(error: 'Unexpected error.'));
    }
  }

  Future<void> signOut() async {
    await authService.signOut();

    emit(const SignedOutState());
  }

  @override
  Future<void> close() async {
    return super.close();
  }

  Future<void> signUpWithEmail(String email, String password, String name,
      String profilePhotoUrl) async {
    emit(const SigningInState());

    try {
      var res = await authService.signUpWithEmail(
          email, password, name, profilePhotoUrl);
      switch (res) {
        case SignInResult.success:
          emit(const SignedInState());
          break;
        case SignInResult.emailAlreadyInUse:
          emit(const SignedOutState(
              error: 'This email address is already in use'));
          break;
        case SignInResult.invalidEmail:
          emit(const SignedOutState(error: 'This email address is invalid'));
          break;
        case SignInResult.userDisabled:
          emit(const SignedOutState(error: 'This user has been banned'));
          break;
        case SignInResult.userNotFound:
          emit(const SignedOutState(error: 'User does not exist'));
          break;
        case SignInResult.wrongPassword:
          emit(const SignedOutState(error: 'Invalid credentials'));
          break;
      }
    } catch (_) {
      emit(const SignedOutState(error: 'Unexpected error'));
    }
  }
}

abstract class AuthState {
  const AuthState();
}

class SignedInState extends AuthState {
  const SignedInState();
}

class SigningInState extends AuthState {
  const SigningInState();
}

class SignedOutState extends AuthState {
  const SignedOutState({
    this.error,
  });

  final String? error;
}
