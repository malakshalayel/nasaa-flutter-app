import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nasaa/core/networking/api_endpoints.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/login/data/models/send_otp_request.dart';
import 'package:nasaa/features/login/data/models/send_otp_response.dart';
import 'package:nasaa/features/login/data/models/verify_otp_request.dart';
import 'package:nasaa/features/login/data/models/verify_otp_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_services.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class AuthServices {
  factory AuthServices(Dio dio) = _AuthServices;

  @POST(ApiEndpoints.sentOtp)
  Future<SendOtpResponse> sendOtp(@Body() SendOtpRequest sendOtpRequest);

  @POST(ApiEndpoints.verifyOtp)
  Future<VerifyOtpResponse> verifyOtp(
    @Body() VerifyOtpRequest verifyOtpRequest,
  );

  @POST(ApiEndpoints.logout)
  Future<void> logout();
}
