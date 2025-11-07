import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nasaa/config/locale_services.dart';
import 'package:nasaa/config/theme/app_theme.dart';
import 'package:nasaa/config/theme/theme_services.dart';
import 'package:nasaa/core/router/app_router.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

import 'config/cache_helper.dart';
import 'core/injection.dart';
import 'features/login/presentation/cubit/auth_cubit.dart';
import 'features/login/presentation/screens/info_user_login.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  await injectDependises();
  final themeServices = ThemeServices();
  await themeServices.loadedTheme();
  final localeServices = LocaleServices();
  await localeServices.loadLocale();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeServices>(create: (_) => themeServices),
        ChangeNotifierProvider<LocaleServices>(create: (_) => localeServices),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeServices = Provider.of<ThemeServices>(context);
    final localeServices = Provider.of<LocaleServices>(context);
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          ...PhoneFieldLocalization.delegates,
        ],
        locale: localeServices.locale,
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        initialRoute: RouterName.onBoardingScreen,
        onGenerateRoute: AppRouter.onGenerateRoute,
        darkTheme: AppTheme.dark(),
        theme: AppTheme.light(),
        themeMode: themeServices.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        //home: InfoUserLogin(),
        // home: BlocProvider<AuthCubit>(
        //   create: (context) => AuthCubit(repo: getIt()),
        //   child: InfoUserLogin(),
        // ),
      ),
    );
  }
}
