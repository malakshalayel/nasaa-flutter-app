// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:nasaa/config/cache_helper.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:nasaa/core/networking/api_endpoints.dart';

// class DioFactory {
//   final Dio _dio;
//   Dio get dio => _dio;

//   DioFactory() : _dio = Dio() {
//     _dio.options = BaseOptions(
//       baseUrl: ApiEndpoints.baseUrl,
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       sendTimeout: const Duration(seconds: 10),
//       followRedirects: false, // 🚫 stop following redirects
//       validateStatus: (status) {
//         // Accept all status codes to handle them manually
//         return status != null && status < 600;
//       },
//       headers: const {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//     );

//     _dio.interceptors.addAll([
//       PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: true,
//         error: true,
//         compact: true,
//       ),
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           String? token = await CacheHelper.readSecureStorage(key: 'token');
//           if (token != null && token.isNotEmpty) {
//             // Add Bearer prefix if not already present
//             if (!token.startsWith('Bearer ')) {
//               options.headers['Authorization'] = 'Bearer $token';
//             } else {
//               options.headers['Authorization'] = token;
//             }
//             log('🔑 Token added to request');
//           } else {
//             log('⚠️ No token found in secure storage');
//           }
//           log('🌐 REQUEST[${options.method}] => URL: ${options.uri}');
//           log('📋 HEADERS: ${options.headers}');
//           log('📦 BODY: ${options.data}');
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           log(
//             '✅ RESPONSE[${response.statusCode}] => URL: ${response.requestOptions.uri}',
//           );
//           log('📥 BODY: ${response.data}');
//           return handler.next(response);
//         },
//         onError: (error, handler) {
//           log(
//             '❌ ERROR[${error.response?.statusCode}] => URL: ${error.requestOptions.uri}',
//           );
//           log('💥 MESSAGE: ${error.message}');
//           if (error.response?.statusCode == 302) {
//             log('🔀 REDIRECT TO: ${error.response?.headers['location']}');
//           }
//           return handler.next(error);
//         },
//       ),
//     ]);
//   }
// }
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
        return status != null && status < 600;
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
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            log('🔒 UNAUTHORIZED: Token invalid or expired');
            CacheHelper.deleteSecureStorage(key: 'token');
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
}
