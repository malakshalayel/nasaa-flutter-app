import 'package:dio/dio.dart';

extension DioExtentionExceptioType on DioExceptionType {
  String get description {
    switch (this) {
      case DioExceptionType.cancel:
        return "Request to API server was cancelled";
      case DioExceptionType.connectionTimeout:
        return "Connection timeout with API server";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout in connection with API server";
      case DioExceptionType.sendTimeout:
        return "Send timeout in connection with API server";
      case DioExceptionType.badCertificate:
        return "Bad certificate from API server";
      case DioExceptionType.badResponse:
        return "Received invalid status code: ";
      case DioExceptionType.connectionError:
        return "Connection to API server failed due to internet connection";
      case DioExceptionType.unknown:
        return "Unexpected error occurred";
      case DioExceptionType.badResponse:
        return "Bad response from API server";
    }
  }
}
