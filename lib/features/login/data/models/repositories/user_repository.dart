import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';

final String nameKey = "nameUser";
final String emailKey = "emailUser";
final String genderKey = "genderUser";
final String birthKey = "birthUser";

class UserRepository {
  UserRepository({required this.cacheHelper});
  final CacheHelper cacheHelper;
  Future<void> registerUser({required UserModel user}) async {
    await cacheHelper.set(key: nameKey, value: user.name);
    await cacheHelper.set(key: emailKey, value: user.email);
    await cacheHelper.set(key: genderKey, value: user.Gender);
    await cacheHelper.set(key: birthKey, value: user.DateOfBirth);
  }
}
