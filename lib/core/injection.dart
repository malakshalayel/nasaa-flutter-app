import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/login/data/models/repositories/user_repository.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

injectDependises() {
  // Register Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Register CacheHelper
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());

  // Register UserRepository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(cacheHelper: getIt<CacheHelper>()),
  );

  // Register AuthCubit
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(repo: getIt<UserRepository>()),
  );
}
