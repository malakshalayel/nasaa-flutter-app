import 'package:dio/dio.dart';
import 'package:nasaa/core/networking/api_error_model.dart';
import 'package:nasaa/core/networking/dio_extention_exceptio_type.dart';
import 'package:nasaa/core/networking/local_status_code.dart';
import 'dart:developer';

class ApiErrorHandler {
  static ApiErrorModel handelError(dynamic e) {
    log(' Error type: ${e.runtimeType}');
    if (e is DioException) {
      final result = e.when(
        connectionError: () {
          log(' Connection Error detected');
          return ApiErrorModel(
            message: "Connection Error. Please check your internet.",
            statusCode: LocalStatusCodes.connectionError,
          );
        },
        connectionTimeout: () {
          log('Connection Timeout detected');
          return ApiErrorModel(
            message: "Connection Timeout. Please try again.",
            statusCode: LocalStatusCodes.connectionTimout,
          );
        },
        sendTimeout: () {
          log('Send Timeout detected');
          return ApiErrorModel(
            message: "Send Timeout. Please try again.",
            statusCode: LocalStatusCodes.sendTimeout,
          );
        },
        receiveTimeout: () {
          log('Receive Timeout detected');
          return ApiErrorModel(
            message: "Receive Timeout. Please try again.",
            statusCode: LocalStatusCodes.receiveTimeout,
          );
        },
        badCertificate: () {
          log('Bad Certificate detected');
          return ApiErrorModel(
            message: "Bad Certificate",
            statusCode: LocalStatusCodes.badCertificate,
          );
        },
        // ✅ Extract message from API response
        badResponse: () {
          log(' Bad Response detected - extracting message...');
          return _extractErrorMessage(e.response);
        },
        cancel: () {
          log('Request Cancelled detected');
          return ApiErrorModel(
            message: "Request Cancelled",
            statusCode: LocalStatusCodes.cancel,
          );
        },
        unknown: () {
          log(' Unknown Error detected');
          return ApiErrorModel(
            message: "Network Error. Please check your connection.",
            statusCode: LocalStatusCodes.unknown,
          );
        },
      );

      log(' Returning error: ${result.message}');
      return result;
    }

    log('Not a DioException');
    return ApiErrorModel(
      message: "Unknown error occurred",
      statusCode: LocalStatusCodes.unknown,
    );
  }

  // ✅ Extract error message from API response
  static ApiErrorModel _extractErrorMessage(Response? response) {
    log(' _extractErrorMessage called');

    if (response == null) {
      log(' Response is null');
      return ApiErrorModel(
        message: "Unknown error occurred",
        statusCode: LocalStatusCodes.badResponse,
      );
    }

    final statusCode = response.statusCode ?? LocalStatusCodes.badResponse;
    final data = response.data;

    String message = "Something went wrong. Please try again.";

    // ✅ Try to extract message from different formats
    if (data is Map<String, dynamic>) {
      log('📋 Data is Map, keys: ${data.keys}');

      // Try multiple possible message keys
      if (data.containsKey('message')) {
        message = data['message'].toString();
        log('✅ Found message key: $message');
      } else if (data.containsKey('error')) {
        message = data['error'].toString();
        log('✅ Found error key: $message');
      } else if (data.containsKey('error_message')) {
        message = data['error_message'].toString();
        log('✅ Found error_message key: $message');
      } else if (data.containsKey('msg')) {
        message = data['msg'].toString();
        log('✅ Found msg key: $message');
      } else {
        log('⚠️ No known message key found in response');
      }
    } else if (data is String) {
      message = data;
      log('✅ String message: $message');
    } else {
      log('⚠️ Unknown data type: ${data.runtimeType}');
    }

    log('🎯 Final extracted message: $message');

    return ApiErrorModel(message: message, statusCode: statusCode);
  }
}
