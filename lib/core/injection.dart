import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/home/data/repo/home_repo.dart';
import 'package:nasaa/features/home/data/services/home_services.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/login/data/repositories/user_repository.dart';
import 'package:nasaa/features/login/data/services/auth_services.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';

final GetIt getIt = GetIt.instance;

injectDependises() {
  // Register Dio
  getIt.registerLazySingleton<Dio>(() => DioFactory().dio);

  // Register CacheHelper
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());

  // Register AuthServices
  getIt.registerLazySingleton<AuthServices>(() => AuthServices(getIt<Dio>()));

  // Register UserRepository
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt<AuthServices>()));

  // Register AuthCubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(repo: getIt<AuthRepo>()));

  // Register HomeServices
  getIt.registerLazySingleton<HomeServices>(() => HomeServices(getIt<Dio>()));

  //Register HomeRepo
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt<HomeServices>()));

  //  Register HomeCubit
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));
}
