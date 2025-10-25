import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/data/models/repositories/user_repository.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/screens/info_user_login.dart';
import 'package:nasaa/features/login/presentation/screens/login.dart';
import 'package:nasaa/features/login/presentation/screens/login_first_screen.dart';
import 'package:nasaa/features/login/presentation/screens/otp_screen.dart';
import 'package:nasaa/generated/l10n.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.loginFirstScreen:
        return MaterialPageRoute(builder: (context) => LoginFirstScreen());
      case RouterName.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: Login(),
          ),
        );
      case RouterName.otpScreen:
        final phoneNumber = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: OtpScreen(phoneNumber: phoneNumber!),
          ),
        );

      case RouterName.infoUserLogin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(repo: getIt()),
            child: InfoUserLogin(),
          ),
        );

      case RouterName.home:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text(CacheHelper.getString(key: nameKey)!)),
          ),
        );
    }
  }
}
