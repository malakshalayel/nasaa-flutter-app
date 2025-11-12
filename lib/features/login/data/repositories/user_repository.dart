import 'package:flutter/material.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/check_internet_connection.dart';
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

  AuthRepo(this.authServices);

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

      return await authServices
          .sendOtp(otp)
          .then(
            (data) {
              return ApiResult.success(data);
            },
            onError: (error) {
              return ApiResult.error(ApiErrorHandler.handelError(error));
            },
          );
    } catch (e, stackTrace) {
      final errorModel = ApiErrorHandler.handelError(e);
      log('Error model created: ${errorModel.message}');

      return ApiResult.error(errorModel);
    }
  }

  Future<ApiResult<VerifyOtpResponse>> verifyOtp(VerifyOtpRequest otp) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }

    try {
      final response = await authServices.verifyOtp(otp);
      log(' REPO: OTP verification successful');

      return ApiResult.success(response);
    } catch (e, stackTrace) {
      log(' REPO: OTP verification failed');

      return ApiResult.error(ApiErrorHandler.handelError(e));
    }
  }

  Future<void> logout(BuildContext context) async {
    if (!await checkInternetConnection()) {
      throw Exception("No Internet Connection");
    }
    try {
      await authServices.logout();
      await CacheHelper.deleteSecureStorage(key: CacheKeys.tokenKey);
      await CacheHelper.clear();

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouterName.login, (route) => false);
    } catch (e) {
      throw Exception("somthing wrong");
    }
  }
}
