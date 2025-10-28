import 'package:dio/dio.dart';
import 'package:nasaa/core/networking/api_error_model.dart';
import 'package:nasaa/core/networking/dio_extention_exceptio_type.dart';
import 'package:nasaa/core/networking/local_status_code.dart';

class ApiErrorHandler {
  static handelError(e) {
    if (e is Exception) {
      if (e is DioException) {
        return e.when(
          connectionError: () => ApiErrorModel(
            message: "Connection Error",
            statusCode: LocalStatusCodes.connectionError,
          ),
          connectionTimeout: () => ApiErrorModel(
            message: "Connection Timeout",
            statusCode: LocalStatusCodes.connectionTimout,
          ),
          sendTimeout: () => ApiErrorModel(
            message: "Send Timeout",
            statusCode: LocalStatusCodes.sendTimeout,
          ),
          receiveTimeout: () => ApiErrorModel(
            message: "Receive Timeout",
            statusCode: LocalStatusCodes.receiveTimeout,
          ),
          badCertificate: () => ApiErrorModel(
            message: "Bad Certificate",
            statusCode: LocalStatusCodes.badCertificate,
          ),
          badResponse: () => ApiErrorModel(
            message: "Bad Response",
            statusCode: LocalStatusCodes.badResponse,
          ),
          cancel: () => ApiErrorModel(
            message: "Cancel",
            statusCode: LocalStatusCodes.cancel,
          ),
          unknown: () => ApiErrorModel(
            message: "Unknown",
            statusCode: LocalStatusCodes.unknown,
          ),
        );
      }
    } else {
      return ApiErrorModel(
        message: "Unknown errorrr",
        statusCode: LocalStatusCodes.unknown,
      );
    }
  }
}
