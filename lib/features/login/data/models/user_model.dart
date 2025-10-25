class UserModel {
  String name;
  String email;
  String? Gender;
  String? DateOfBirth;

  UserModel({
    required this.name,
    required this.email,
    this.Gender = '',
    this.DateOfBirth = '',
  });
}
