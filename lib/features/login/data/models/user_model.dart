class UserModelSp {
  final String name;
  final String email;
  final String Gender;
  final String DateOfBirth;
  final String? profileImage;

  UserModelSp({
    required this.name,
    required this.email,
    required this.Gender,
    required this.DateOfBirth,
    this.profileImage,
  });
}
