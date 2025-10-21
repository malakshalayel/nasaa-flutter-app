import 'package:flutter/material.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/presentation/screens/login.dart';
import 'package:nasaa/features/login/presentation/screens/login_first_screen.dart';
import 'package:nasaa/generated/l10n.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.loginFirstScreen:
        return MaterialPageRoute(builder: (context) => LoginFirstScreen());
      case RouterName.login:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }
}
