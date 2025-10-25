import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nasaa/features/login/data/models/repositories/user_repository.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nasaa/generated/intl/messages_en.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({this.repo}) : super(AuthInitialState());

  UserRepository? repo;
  String? _verificationId;
  bool get hasVerificationId => _verificationId != null;

  Future<void> checkIfLoggedIn() async {
    User user = FirebaseAuth.instance.currentUser!;

    if (FirebaseAuth.instance.currentUser != null) {
      emit(AuthPhoneVerified(user: user));
      emit(AuthSocialVerified(user));
    }
  }

  Future<void> sendOtp(String? phoneNumber) async {
    final auth = FirebaseAuth.instance;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      emit(AuthError("Phone number is missing"));
      return;
    }

    emit(AuthLoadingState());

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 30),

      verificationCompleted: (PhoneAuthCredential credential) async {
        // Instant verification/autofill cases
        final userCredential = await auth.signInWithCredential(credential);
        emit(AuthPhoneVerified(user: userCredential.user!));
      },

      verificationFailed: (FirebaseAuthException e) {
        final msg = switch (e.code) {
          "invalid-phone-number" => "Invalid phone number format.",
          "too-many-requests" => "Too many attempts. Please try later.",
          "session-expired" => "Session expired. Please resend the code.",
          _ => e.message ?? "Verification failed",
        };
        emit(AuthError(msg));
      },

      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        log("otp sent $verificationId");
        emit(AuthPhoneCodeSent(verificationId));
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId; // still usable
      },
    );
  }

  Future<void> verifyOtp(String smsCode) async {
    if (_verificationId == null) {
      emit(AuthError("Verification ID missing. Please resend the code."));
      return;
    }
    try {
      emit(AuthLoadingState());
      final cred = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        cred,
      );
      emit(AuthPhoneVerified(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Verification failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoadingState());
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      emit(AuthSocialVerified(user.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> rgisterUser({required UserModel user}) async {
    emit(AuthLoadingState());

    await repo!.registerUser(user: user);
    emit(AuthUserRegistered(user: user));
  }
}
