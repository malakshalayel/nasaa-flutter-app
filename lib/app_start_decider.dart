import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';

class AppStartDecider extends StatefulWidget {
  const AppStartDecider({super.key});

  @override
  State<AppStartDecider> createState() => _AppStartDeciderState();
}

class _AppStartDeciderState extends State<AppStartDecider> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final authCubit = context.read<AuthCubit>();
    final loggedIn = await authCubit.checkIfLoggedInbyApi();

    if (!mounted) return;
    if (loggedIn) {
      Navigator.of(context).pushReplacementNamed(RouterName.home);
    } else {
      Navigator.of(context).pushReplacementNamed(RouterName.onBoardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
