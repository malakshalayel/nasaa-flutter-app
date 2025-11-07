import 'package:flutter/material.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/data/models/send_otp_request.dart';
import 'package:nasaa/features/login/data/models/send_otp_response.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';
import 'package:nasaa/features/login/data/models/verify_otp_request.dart';
import 'package:nasaa/features/login/data/models/verify_otp_response.dart';
import 'package:nasaa/features/login/data/services/auth_services.dart';
import 'dart:developer';

class AuthRepo {
  final AuthServices authServices;

  // Constructor injection
  AuthRepo(this.authServices);

  // Factory or initializer if you want to use DioFactory here directly
  factory AuthRepo.create() {
    final dio = DioFactory().dio;
    final services = AuthServices(dio);
    return AuthRepo(services);
  }

  Future<void> registerUser({required UserModelSp user}) async {
    await CacheHelper.set(key: CacheKeys.nameKey, value: user.name);
    await CacheHelper.set(key: CacheKeys.emailKey, value: user.email);
    await CacheHelper.set(key: CacheKeys.genderKey, value: user.Gender);
    await CacheHelper.set(key: CacheKeys.birthKey, value: user.DateOfBirth);
  }

  // Future<ApiResult<SendOtpResponse>> sendOtp(SendOtpRequest otp) async {
  //   try {
  //     final response = await _authServices.sendOtp(otp);
  //     return ApiResult.success(response);
  //   } catch (e) {
  //     return ApiResult.error(ApiErrorHandler.handelError(e));
  //   }
  // }

  Future<ApiResult<SendOtpResponse>> sendOtp(SendOtpRequest otp) async {
    try {
      log('Sending OTP request: ${otp.toJson()}');
      final response = await authServices.sendOtp(otp);
      log('OTP Response received: ${response.toJson()}');
      return ApiResult.success(response);
    } catch (e, stackTrace) {
      log('OTP Error: $e');
      log('Error type: ${e.runtimeType}');
      log('StackTrace: $stackTrace');

      final errorModel = ApiErrorHandler.handelError(e);
      log('Error model created: ${errorModel.message}');

      return ApiResult.error(errorModel);
    }
  }

  Future<ApiResult<VerifyOtpResponse>> verifyOtp(VerifyOtpRequest otp) async {
    try {
      final response = await authServices.verifyOtp(otp);
      log('OTP Response verified: ${response.toJson()}');
      return ApiResult.success(response);
    } catch (e, stackTrace) {
      log('OTP Error: $e');
      log('Error type: ${e.runtimeType}');
      log('StackTrace: $stackTrace');
      final errorModel = ApiErrorHandler.handelError(e);
      log('Error model created: ${errorModel.message}');
      return ApiResult.error(errorModel);
    }
  }

  Future<void> logout(BuildContext context) async {
    await CacheHelper.deleteSecureStorage(key: CacheKeys.tokenKey);
    await CacheHelper.clear();

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouterName.login, (route) => false);
  }
}
