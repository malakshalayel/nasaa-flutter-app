import 'package:nasaa/features/login/data/models/user_model_api.dart';

class VerifyData {
  final User? user;
  final String? token;

  VerifyData({this.user, this.token});

  factory VerifyData.fromJson(Map<String, dynamic> json) {
    return VerifyData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) map['user'] = user!.toJson();
    map['token'] = token;
    return map;
  }
}
