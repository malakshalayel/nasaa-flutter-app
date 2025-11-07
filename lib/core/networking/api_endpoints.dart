import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/features/login/data/repositories/user_repository.dart';

class ApiEndpoints {
  static const baseUrl = 'https://dev.justnasaa.com/api/';
  //auth
  static const sentOtp = 'auth/otp/send';
  static const verifyOtp = 'auth/otp/verify';
  static const refreshToken = 'auth/token/refresh';

  //home
  static const coachFeatured = "coach_featured";
  static const coachsIndex = 'coach';
  static const coachDetails = 'coach/{id}';
  static const activity = 'activity';

  //static const adminLogin = '$baseUrl/auth/admin/login';
}
