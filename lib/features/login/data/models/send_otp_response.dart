// {
//   "status": true,
//   "message": "string",
//   "expires_at": "string"
// }
class SendOtpResponse {
  final bool status;
  final String message;
  final String expiresAt;

  SendOtpResponse({
    required this.status,
    required this.message,
    required this.expiresAt,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      expiresAt: json['expires_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'expires_at': expiresAt};
  }
}
