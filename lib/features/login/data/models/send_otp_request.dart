// {
//   "phone": "strings",
//   "country": "strin",
//   "user_type": "1"
// }

class SendOtpRequest {
  final String phone;
  final String country;
  final String userType;

  SendOtpRequest({
    required this.phone,
    required this.country,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'country': country, 'user_type': userType};
  }

  factory SendOtpRequest.fromMap(Map<String, dynamic> map) {
    return SendOtpRequest(
      phone: map['phone'] ?? '',
      country: map['country'] ?? '',
      userType: map['user_type'] ?? '',
    );
  }
}
