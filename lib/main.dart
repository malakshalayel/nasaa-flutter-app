import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/injection.dart';
import 'package:nasaa/core/router/app_router.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/screens/info_user_login.dart';

import 'package:nasaa/firebase_options.dart';
import 'package:nasaa/generated/l10n.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  await injectDependises();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...PhoneFieldLocalization.delegates,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: RouterName.loginFirstScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // home: BlocProvider<AuthCubit>(
      //   create: (context) => AuthCubit(repo: getIt()),
      //   child: InfoUserLogin(),
      // ),
    );
  }
}
