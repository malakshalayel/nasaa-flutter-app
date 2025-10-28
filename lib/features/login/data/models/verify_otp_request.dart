// // {
// //   "phone": "strings",
// //   "country": "strin",
// //   "otp": "string"
// // }

// class VerifyOtpRequest {
//   final String phone;
//   final String country;
//   final String otp;

//   VerifyOtpRequest({
//     required this.phone,
//     required this.country,
//     required this.otp,
//   });

//   Map<String, dynamic> toJson() {
//     return {'phone': phone, 'country': country, 'otp': otp};
//   }

//   factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
//     return VerifyOtpRequest(
//       phone: json['phone'] ?? '',
//       country: json['country'] ?? '',
//       otp: json['otp'] ?? '',
//     );
//   }
// }
class VerifyOtpRequest {
  final String phone;
  final String country;
  final String otp;

  VerifyOtpRequest({
    required this.phone,
    required this.country,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'country': country, 'otp': otp};
  }

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequest(
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      otp: json['otp'] ?? '',
    );
  }
}
