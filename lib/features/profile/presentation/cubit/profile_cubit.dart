import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/features/profile/presentation/cubit/profile_state.dart';
import '../../../login/data/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  UserModelSp? user;

  Future<void> loadUser() async {
    emit(ProfileLoading());
    final name = await CacheHelper.getString(key: CacheKeys.nameKey);
    final email = await CacheHelper.getString(key: CacheKeys.emailKey);
    final gender = await CacheHelper.getString(key: CacheKeys.genderKey);
    final birth = await CacheHelper.getString(key: CacheKeys.birthKey);
    final image = await CacheHelper.getString(key: CacheKeys.imageKey);

    user = UserModelSp(
      name: name ?? '',
      email: email ?? '',
      Gender: gender ?? 'Male',
      DateOfBirth: birth ?? '',
      profileImage: image,
    );
    emit(ProfileLoaded(user!));
  }

  Future<void> registerUser({required UserModelSp user}) async {
    emit(ProfileLoading());
    await CacheHelper.set(key: CacheKeys.nameKey, value: user.name);
    await CacheHelper.set(key: CacheKeys.emailKey, value: user.email);
    await CacheHelper.set(key: CacheKeys.genderKey, value: user.Gender);
    await CacheHelper.set(key: CacheKeys.birthKey, value: user.DateOfBirth);
    await CacheHelper.set(
      key: CacheKeys.imageKey,
      value: user.profileImage ?? '',
    );
    this.user = user;
    emit(ProfileUpdated(user));
  }

  Future<void> updateField({
    String? name,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? profileImage,
  }) async {
    emit(ProfileLoading());
    if (name != null) CacheHelper.set(key: CacheKeys.nameKey, value: name);
    if (email != null)
      await CacheHelper.set(key: CacheKeys.emailKey, value: email);
    if (dateOfBirth != null)
      await CacheHelper.set(key: CacheKeys.birthKey, value: dateOfBirth);
    if (gender != null)
      await CacheHelper.set(key: CacheKeys.genderKey, value: gender);
    if (profileImage != null)
      await CacheHelper.set(key: CacheKeys.imageKey, value: profileImage);

    await loadUser();
  }
}
