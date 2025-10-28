import 'package:firebase_auth/firebase_auth.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthError extends AuthState {
  String message;
  AuthError(this.message);
}
//////// auth state in api ////////////////////

class SendOtpState extends AuthState {}

class VerifyOtpState extends AuthState {}

//////// auth state in firebase /////////////////////////////
class AuthPhoneCodeSent extends AuthState {
  final String verificationId;
  AuthPhoneCodeSent(this.verificationId);
}

class AuthPhoneVerified extends AuthState {
  User user;
  AuthPhoneVerified({required this.user});
}

class AuthUserRegistered extends AuthState {
  UserModelSp user;
  AuthUserRegistered({required this.user});
}

class AuthSocialVerified extends AuthState {
  User user;
  AuthSocialVerified(this.user);
}
