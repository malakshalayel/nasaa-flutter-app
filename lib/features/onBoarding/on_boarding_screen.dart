import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/home/presentation/screens/home_screen.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
import 'package:nasaa/features/login/presentation/screens/login_first_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuth();
  }

  _checkAuth() async {
    await Future.delayed(const Duration(seconds: 4));
    context.read<AuthCubit>().checkIfLoggedInbyApi();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerifyOtpState) {
          Navigator.pushReplacementNamed(context, RouterName.home);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F3),
        body: SafeArea(
          child: Stack(
            children: [
              /// === Main pages ===
              IntroductionScreen(
                globalBackgroundColor: const Color(0xFFF9F7F3),

                // ✅ Onboarding Pages
                pages: [
                  PageViewModel(
                    titleWidget: const Text(
                      "Find Your Perfect Coach",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    bodyWidget: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Choose from top-rated specialists in various fields to achieve your fitness goals",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    image: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg_images/Online Personal Trainer-bro 1.svg',
                          height: 280,
                        ),
                      ),
                    ),
                  ),
                  PageViewModel(
                    titleWidget: const Text(
                      "Flexible Schedule",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    bodyWidget: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Pick your preferred time and location, and track your progress with ease",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    image: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg_images/Time management-cuate 1.svg',
                          height: 280,
                        ),
                      ),
                    ),
                  ),
                  PageViewModel(
                    titleWidget: const Text(
                      "Achieve Your Goals",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    bodyWidget: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Take the first step towards a healthier you, and let's build your success story together",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    image: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg_images/Personal goals-amico 1.svg',
                          height: 280,
                        ),
                      ),
                    ),
                  ),
                ],
                showNextButton: true,
                next: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),

                // ✅ Dots style
                dotsDecorator: DotsDecorator(
                  size: const Size(15.0, 6.0),
                  activeSize: const Size(30.0, 6.0),
                  color: Colors.black12,
                  activeColor: Colors.black,
                  spacing: const EdgeInsets.symmetric(horizontal: 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                dotsFlex: 2,
                nextFlex: 2,

                // ✅ onDone callback (works when user finishes)
                onDone: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginFirstScreen()),
                  );
                },
                overrideDone: (context, onPressed) {
                  return TextButton(
                    onPressed:
                        onPressed ??
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginFirstScreen(),
                            ),
                          );
                        },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },

                //done: const Text("Get Started"),
                showDoneButton: true,
                showSkipButton: false,
              ),

              /// === Skip button (top right)
              Positioned(
                top: 40,
                right: 20,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginFirstScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkLoginApi() async {
    await Future.delayed(const Duration(seconds: 3));

    context.read<AuthCubit>().checkIfLoggedInbyApi();
  }
}
