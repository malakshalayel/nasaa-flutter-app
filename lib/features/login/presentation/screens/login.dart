import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../core/router/router_name.dart';
import '../../../../core/shared_widgets.dart/custom_elevated_button.dart';
import '../../data/models/send_otp_request.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/divider.dart';
import '../widgets/phone_field_view.dart';
import '../widgets/privecy_policy.dart';
import '../widgets/social_button.dart';
import 'otp_screen.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late PhoneController controller;
  CountrySelectorNavigator selectorNavigator =
      const CountrySelectorNavigator.page();
  Locale locale = const Locale('en');
  @override
  void initState() {
    super.initState();
    controller = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.QA, nsn: ''),
    );
    controller.addListener(() => setState(() {}));
    // checkUser();
    //checkLoginApi();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            // if (state is AuthPhoneCodeSent) {
            //   Navigator.pushReplacementNamed(
            //     context,
            //     RouterName.otpScreen,
            //     arguments: controller.value.international,
            //   );
            //   log("on listener${controller.value.international}");
            // }

            // if (state is SendOtpState) {
            //   Navigator.pushReplacementNamed(
            //     context,
            //     RouterName.otpScreen,
            //     arguments: SendOtpRequest(
            //       phone: controller.value.international,
            //       country: controller.value.isoCode.name,
            //       userType: "1",
            //     ),
            //   );
            // }
            if (state is SendOtpState) {
              Navigator.push(
                // Use push instead of pushReplacementNamed
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AuthCubit>(),
                    child: OtpScreen(
                      otpRequest: SendOtpRequest(
                        phone: controller.value.nsn,
                        country: "+${controller.value.countryCode}",
                        userType: "1",
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is VerifyOtpState) {
              Navigator.pushReplacementNamed(context, RouterName.home);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("//////${state.message}")));
            } else if (state is AuthSocialVerified) {
              Navigator.pushReplacementNamed(context, RouterName.infoUserLogin);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your  Phone Number",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "We’ll send a  message text to verify your number",
                      style: TextStyle(color: Color(0xFF676767)),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: key,
                      child: Column(
                        children: [
                          PhoneFieldView(
                            controller: controller,
                            focusNode: FocusNode(),
                            selectorNavigator: selectorNavigator,
                            withLabel: true,
                            outlineBorder: true,
                            isCountryButtonPersistant: true,
                            mobileOnly: true,
                            locale: locale,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    CustomElevatedButton(
                      text: state is AuthLoadingState ? "Sending ..." : "Next",
                      onPressed: state is AuthLoadingState
                          ? null
                          : () {
                              if (key.currentState!.validate()) {
                                final phoneNumber = controller.value;

                                //   context.read<AuthCubit>().sendOtp(phoneNumber);
                                context.read<AuthCubit>().sentOtpApi(
                                  SendOtpRequest(
                                    phone: phoneNumber.nsn,
                                    country: '+${phoneNumber.countryCode}',
                                    userType: "1",
                                  ),
                                );
                                log(phoneNumber.nsn);
                              }
                            },
                      icon: Icons.arrow_right_alt_outlined,
                    ),
                    SizedBox(height: 50),

                    DividerLoginScreen(),
                    SizedBox(height: 30),
                    SocialButton(
                      imgeName: "google",
                      label: "Google",
                      onPressed: () async {
                        await context.read<AuthCubit>().signInWithGoogle();
                      },
                    ),
                    SizedBox(height: 15),
                    SocialButton(
                      imgeName: "apple",
                      label: "Apple",
                      onPressed: () {},
                    ),
                  ],
                ),
                PrivecyPolicy(),
              ],
            );
          },
        ),
      ),
    );
  }

  // checkUser() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   await context.read<AuthCubit>().checkIfLoggedIn();
  // }

  // checkLoginApi() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   if (mounted) {
  //     context.read<AuthCubit>().checkIfLoggedInbyApi();
  //   }
  // }
}
