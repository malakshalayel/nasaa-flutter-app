import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nasaa/core/networking/dio_factory.dart';
import 'package:nasaa/features/activities/data/repo/activity_repo.dart';
import 'package:nasaa/features/activities/data/services/activity_services.dart';
import 'package:nasaa/features/activities/presentation/cubit/activity_cubit.dart';
import 'package:nasaa/features/coaches/data/repo/coach_repo.dart';
import 'package:nasaa/features/coaches/data/services.dart/coach_services.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_cubit.dart';
import 'package:nasaa/features/coaches/presentation/cubits/cubit_coach_list/coach_list_cubit.dart';
import 'package:nasaa/features/favorites/data/repo/favorite_repo.dart';
import 'package:nasaa/features/favorites/data/services/favorites_services.dart';
import 'package:nasaa/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:nasaa/features/login/data/repositories/user_repository.dart';
import 'package:nasaa/features/login/data/services/auth_services.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/profile/presentation/cubit/profile_cubit.dart';

final GetIt getIt = GetIt.instance;

injectDependises() {
  // Register Dio
  getIt.registerLazySingleton<Dio>(() => DioFactory().dio);

  // Register CacheHelper`

  // Register AuthServices
  getIt.registerLazySingleton<AuthServices>(() => AuthServices(getIt<Dio>()));

  // Register UserRepository////////////
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt<AuthServices>()));

  // Register AuthCubit
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(repo: getIt<AuthRepo>()),
  );

  // register activity services , repo , cubit
  getIt.registerLazySingleton<ActivityServices>(
    () => ActivityServices(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ActivityRepo>(
    () => ActivityRepo(getIt<ActivityServices>()),
  );
  getIt.registerLazySingleton<ActivityCubit>(
    () => ActivityCubit(getIt<ActivityRepo>()),
  );

  // register coach services , repo , cubit
  getIt.registerLazySingleton<CoachServices>(() => CoachServices(getIt<Dio>()));
  getIt.registerLazySingleton<CoachRepo>(
    () => CoachRepo(getIt<CoachServices>()),
  );
  getIt.registerLazySingleton<CoachCubit>(() => CoachCubit(getIt<CoachRepo>()));

  getIt.registerFactoryParam<CoachDetailsCubit, int, void>(
    (int id, _) => CoachDetailsCubit(repo: getIt<CoachRepo>(), coachId: id),
  );

  //register favorite cubit
  getIt.registerLazySingleton<FavoritesServices>(
    () => FavoritesServices(getIt<Dio>()),
  );
  getIt.registerLazySingleton<FavoriteRepo>(
    () => FavoriteRepo(getIt<FavoritesServices>()),
  );
  getIt.registerLazySingleton<FavoriteCubit>(
    (() => FavoriteCubit(getIt<FavoriteRepo>())),
  );

  // Register ProfileCubit
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit());
}
