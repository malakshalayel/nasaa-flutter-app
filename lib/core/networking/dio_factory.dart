import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:nasaa/core/networking/api_endpoints.dart';

class DioFactory {
  final Dio _dio;
  Dio get dio => _dio;

  DioFactory() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      followRedirects: false,
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300; // ✅ CORRECT
      },
      headers: const {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    _dio.interceptors.addAll([
      // Token interceptor FIRST
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await CacheHelper.readSecureStorage(key: 'token');

          if (token != null && token.isNotEmpty) {
            if (!token.startsWith('Bearer ')) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              options.headers['Authorization'] = token;
            }
            log('🔑 Token found and added');
          } else {
            log('⚠️ WARNING: No token found in secure storage!');
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            log('🔒 UNAUTHORIZED: Token invalid or expired');
            CacheHelper.deleteSecureStorage(key: 'token');
            //final refreshToken = await _refreshToken();
            // if (refreshToken != null) {
            //   if (refreshToken.startsWith('Bearer')) {
            //     error.requestOptions.headers['Authorization'] = refreshToken;
            //   } else {
            //     error.requestOptions.headers['Authorization'] =
            //         'Bearer $refreshToken';
            //   }
            // }
          }
          if (error.response?.statusCode == 500) {
            log('🔥 SERVER ERROR: Backend issue');
          }
          return handler.next(error);
        },
      ),
      // PrettyDioLogger LAST - so it logs everything including the token
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false, // Set to false for more detailed output
        maxWidth: 90,
      ),
    ]);
  }
  // Future<String?> _refreshToken() async {
  //   final refreshToken = await CacheHelper.readSecureStorage(
  //     key: CacheKeys.refreshTokenKey,
  //   );
  //   final response = await _dio.post(
  //     ApiEndpoints.refreshToken,
  //     data: {'refresh_token': refreshToken},
  //   );
  //   final accessToken = response.data['access_token'];
  //   return accessToken;
  // }
}
