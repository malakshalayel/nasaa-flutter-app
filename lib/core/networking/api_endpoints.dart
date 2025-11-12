class ApiEndpoints {
  static const baseUrl = 'https://dev.justnasaa.com/api/';
  //auth
  static const sentOtp = 'auth/otp/send';
  static const verifyOtp = 'auth/otp/verify';
  static const refreshToken = 'auth/token/refresh';
  static const logout = 'auth/logout';

  //home
  static const coachFeatured = "coach_featured";
  static const coachsIndex = 'coach';
  static const coachDetails = 'coach/{id}';
  static const activity = 'activity';
  static const favorite = 'favorite';

  //static const adminLogin = '$baseUrl/auth/admin/login';
}
