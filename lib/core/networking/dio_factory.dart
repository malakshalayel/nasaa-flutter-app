import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final Dio _dio;
  Dio get dio => _dio;
  DioFactory() : _dio = Dio() {
    _dio.options
      ..connectTimeout = Duration(seconds: 10)
      ..receiveTimeout = Duration(seconds: 10)
      ..baseUrl = "https://dev.justnasaa.com/api/"
      ..sendTimeout = Duration(seconds: 10);

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
    // Interceptor للـ Token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // هنا راح نضيف الـ token تلقائياً
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // لو الـ token منتهي (401)
          if (error.response?.statusCode == 401) {
            // هنا ممكن تعمل refresh للـ token
            print('Token expired - 401 Unauthorized');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    // هذي راح نعدلها لاحقاً
    return null;
  }
}
