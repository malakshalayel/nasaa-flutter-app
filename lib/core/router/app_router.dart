import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/app_start_decider.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/home/presentation/cubit/home_cubit.dart';
import 'package:nasaa/features/home/presentation/screens/activities_screen.dart';
import 'package:nasaa/features/home/presentation/screens/coach_detailes_screen.dart';
import 'package:nasaa/features/home/presentation/screens/coaches_by_activity_screen.dart';
import 'package:nasaa/features/home/presentation/screens/favorite_coaches_screen.dart';
import 'package:nasaa/features/home/presentation/screens/home_screen.dart';
import 'package:nasaa/features/login/data/models/send_otp_request.dart';
import 'package:nasaa/features/login/data/repositories/user_repository.dart';
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

      case RouterName.favoriteCoachesScreen:
        return MaterialPageRoute(builder: (_) => FavoriteCoachesScreen());

      case RouterName.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
    }
    return null;
  }
}
