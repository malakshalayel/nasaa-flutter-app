// // {
// //   "status": true,
// //   "message": "string",
// //   "data": {
// //     "user": "string",
// //     "token": "string"
// //   }
// // }

// class VerifyOtpResponse {
//   bool? status;
//   String? message;
//   Data? data;

//   VerifyOtpResponse({this.status, this.message, this.data});

//   VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   String? user;
//   String? token;

//   Data({this.user, this.token});

//   Data.fromJson(Map<String, dynamic> json) {
//     user = json['user'];
//     token = json['token'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user'] = user;
//     data['token'] = token;
//     return data;
//   }
// }
import 'package:nasaa/features/login/data/models/verify_datat.dart';

class VerifyOtpResponse {
  final bool status;
  final String message;
  final VerifyData? data;

  VerifyOtpResponse({required this.status, required this.message, this.data});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {'status': status, 'message': message};
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}
