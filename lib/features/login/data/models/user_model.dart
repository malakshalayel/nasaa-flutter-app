import 'dart:io';

class UserModelSp {
  String name;
  String email;
  String? Gender;
  String? DateOfBirth;
  File? profileImage;

  UserModelSp({
    required this.name,
    required this.email,
    this.Gender = '',
    this.DateOfBirth = '',
    this.profileImage,
  });
}
