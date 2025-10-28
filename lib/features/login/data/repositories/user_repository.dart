import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_result.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/login/data/models/send_otp_request.dart';
import 'package:nasaa/features/login/data/models/send_otp_response.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';
import 'package:nasaa/features/login/data/models/verify_otp_request.dart';
import 'package:nasaa/features/login/data/models/verify_otp_response.dart';
import 'package:nasaa/features/login/data/services/auth_services.dart';
import 'dart:developer';

final String nameKey = "nameUser";
final String emailKey = "emailUser";
final String genderKey = "genderUser";
final String birthKey = "birthUser";

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

  final CacheHelper cacheHelper = CacheHelper();
  Future<void> registerUser({required UserModelSp user}) async {
    await cacheHelper.set(key: nameKey, value: user.name);
    await cacheHelper.set(key: emailKey, value: user.email);
    await cacheHelper.set(key: genderKey, value: user.Gender);
    await cacheHelper.set(key: birthKey, value: user.DateOfBirth);
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
}
