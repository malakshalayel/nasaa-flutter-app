// import 'package:nasaa/core/networking/api_error_handler.dart';
// import 'package:nasaa/core/networking/api_error_model.dart';

// class ApiResult<T> {
//   ApiResult._();
//   factory ApiResult.success(T data) = ApiSuccess<T>;
//   factory ApiResult.error(String e) = ApiError<T>;
//   R when<R>({
//     required R Function(R data) onSuccess,
//     required R Function(ApiErrorModel error) onError,
//   }) {
//     if (this is ApiSuccess<R>) {
//       return onSuccess((this as ApiSuccess<R>).data);
//     } else {
//       return onError(ApiErrorHandler.handelError((this as ApiError).error));
//     }
//   }
// }

// class ApiSuccess<T> extends ApiResult<T> {
//   final T data;
//   ApiSuccess(this.data) : super._();
// }

// class ApiError<T> extends ApiResult<T> {
//   final String error;
//   ApiError(this.error) : super._();
// }

import 'package:nasaa/core/networking/api_error_handler.dart';
import 'package:nasaa/core/networking/api_error_model.dart';

class ApiResult<T> {
  ApiResult._();
  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.error(ApiErrorModel e) = ApiError<T>;
  when({
    required Function(T data) onSuccess,
    required Function(ApiErrorModel error) onError,
  }) {
    if (this is ApiSuccess<T>) {
      return onSuccess((this as ApiSuccess<T>).data);
    } else {
      return onError((this as ApiError<T>).error);
    }
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;

  ApiSuccess(this.data) : super._();
}

class ApiError<T> extends ApiResult<T> {
  final ApiErrorModel error;

  ApiError(this.error) : super._();
}
