import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/app_start_decider.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/activities/presentation/screens/activities_screen.dart';
import 'package:nasaa/features/coaches/presentation/cubits/coach_details/cubit/coach_details_cubit.dart';
import 'package:nasaa/features/coaches/presentation/screens/coach_detailes_screen.dart';
import 'package:nasaa/features/coaches/presentation/screens/coaches_by_activity_screen.dart';
import 'package:nasaa/features/favorites/presentation/screens/favorite_coaches_screen.dart';

import 'package:nasaa/features/home/presentation/screens/home_screen.dart';
import 'package:nasaa/features/login/data/models/send_otp_request.dart';
import 'package:nasaa/features/login/presentation/screens/info_user_login.dart';
import 'package:nasaa/features/login/presentation/screens/login.dart';
import 'package:nasaa/features/login/presentation/screens/login_first_screen.dart';
import 'package:nasaa/features/login/presentation/screens/otp_screen.dart';
import 'package:nasaa/features/onBoarding/on_boarding_screen.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.appStartDecider:
        return MaterialPageRoute(builder: (_) => AppStartDecider());
      case RouterName.loginFirstScreen:
        return MaterialPageRoute(builder: (context) => LoginFirstScreen());
      case RouterName.login:
        return MaterialPageRoute(builder: (_) => Login());
      case RouterName.otpScreen:
        final arguments = settings.arguments as SendOtpRequest;

        return MaterialPageRoute(
          builder: (_) => OtpScreen(otpRequest: arguments),
        );

      case RouterName.infoUserLogin:
        return MaterialPageRoute(builder: (_) => InfoUserLogin());

      case RouterName.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case RouterName.activityScreen:
        return MaterialPageRoute(builder: (_) => ActivitiesScreen());

      case RouterName.coachesByActivityScreen:
        if (settings.name == RouterName.coachesByActivityScreen) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => CoachesByActivityScreen(
              activityId: args['activityId'],
              activityName: args['activityName'],
            ),
          );
        }
      case RouterName.coachDetails:
        final coachId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BlocProvider<CoachDetailsCubit>(
            create: (_) =>
                getIt<CoachDetailsCubit>(param1: coachId)..getCoachDetails(),
            child: CoachDetailsScreen(),
          ),
        );

      case RouterName.favoriteCoachesScreen:
        return MaterialPageRoute(builder: (_) => FavoriteCoachesScreen());

      case RouterName.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
    }
    return null;
  }
}
