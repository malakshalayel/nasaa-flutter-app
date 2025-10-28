class UserModelSp {
  String name;
  String email;
  String? Gender;
  String? DateOfBirth;

  UserModelSp({
    required this.name,
    required this.email,
    this.Gender = '',
    this.DateOfBirth = '',
  });
}
