import 'package:firebase_auth/firebase_auth.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthPhoneCodeSent extends AuthState {
  final String verificationId;
  AuthPhoneCodeSent(this.verificationId);
}

class AuthPhoneVerified extends AuthState {
  User user;
  AuthPhoneVerified({required this.user});
}

class AuthError extends AuthState {
  String message;
  AuthError(this.message);
}

class AuthUserRegistered extends AuthState {
  UserModel user;
  AuthUserRegistered({required this.user});
}

class AuthSocialVerified extends AuthState {
  User user;
  AuthSocialVerified(this.user);
}
