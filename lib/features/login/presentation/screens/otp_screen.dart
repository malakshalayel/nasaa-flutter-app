// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nasaa/core/shared_widgets.dart/custom_elevated_button.dart';
// import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
// import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
// import 'package:nasaa/generated/intl/messages_en.dart';
// import 'package:pinput/pinput.dart';

// class OtpScreen extends StatefulWidget {
//   OtpScreen({super.key, this.phoneNumber});
//   String? phoneNumber;

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   late TextEditingController _otpController;
//   int _seconeds = 60;
//   late Timer _timer;
//   String? phoneNumber;

//   @override
//   void initState() {
//     super.initState();
//     phoneNumber = widget.phoneNumber;
//     _otpController = TextEditingController();
//     _stertTimer();
//   }

//   void _stertTimer() {
//     _seconeds = 60;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_seconeds == 0) {
//         timer.cancel();
//       } else {
//         setState(() => _seconeds--);
//       }
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)?.settings.arguments;
//     if (phoneNumber == null && args != null && args is String) {
//       phoneNumber = args;
//       log("📞 Phone number received: $phoneNumber");
//     } else {
//       log("⚠️ No phone number passed to OtpScreen");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: BlocConsumer<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthVerified) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("✅ Phone verified successfully")),
//               );
//               // Navigator.of(context).pushReplacementNamed('/infoLogin');
//             } else if (state is AuthError) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(" ❌ ${state.message}")));
//             }
//           },
//           builder: (context, state) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Enter Verification Code',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 26),
//                   ),
//                   // 📄 Instruction
//                   Text(
//                     'Please enter the 6-digit code sent to ${phoneNumber ?? ""}',
//                     style: const TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                   const SizedBox(height: 40),

//                   // 🔢 OTP Input
//                   Pinput(
//                     length: 6,
//                     controller: _otpController,
//                     keyboardType: TextInputType.number,
//                     defaultPinTheme: PinTheme(
//                       width: 44,
//                       height: 48,
//                       textStyle: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade400),
//                       ),
//                     ),
//                     focusedPinTheme: PinTheme(
//                       width: 42,
//                       height: 46,
//                       textStyle: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.blueAccent, width: 2),
//                       ),
//                     ),
//                     onCompleted: (value) async {
//                       log("value in onCompleted $value");
//                       await context.read<AuthCubit>().verifyOtp(value);
//                     },
//                   ),

//                   const SizedBox(height: 30),

//                   // 🔁 Resend Code
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: TextButton(
//                           onPressed: _seconeds == 0
//                               ? () {
//                                   log("Resending to: $phoneNumber");
//                                   context.read<AuthCubit>().sendOtp(
//                                     phoneNumber,
//                                   );
//                                   _stertTimer();
//                                 }
//                               : null,
//                           child: Text(
//                             "Resend Code  ${_seconeds > 0 ? _seconeds.toString().padLeft(2, '0') : ""}",
//                             style: TextStyle(
//                               color: _seconeds == 0
//                                   ? Colors.black
//                                   : Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Row(
//                   //   children: [
//                   //     if (_seconeds > 0)
//                   //       Text(
//                   //         "Resend code in 00:${_seconeds.toString().padLeft(2, '0')}",
//                   //         style: const TextStyle(color: Colors.grey),
//                   //       ),

//                   //     TextButton(
//                   //       onPressed: () {
//                   //         final phoneNumber =
//                   //             ModalRoute.of(context)!.settings.arguments
//                   //                 as String;
//                   //         context.read<AuthCubit>().sendOtp(phoneNumber);
//                   //         _stertTimer();
//                   //       },

//                   //       child: Text(
//                   //         "Resend code",
//                   //         style: const TextStyle(color: Colors.black),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController _otpController;
  late Timer _timer;
  int _seconds = 60;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startTimer();
    log("📞 OtpScreen started for ${widget.phoneNumber}");
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Code")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPhoneVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Phone verified successfully")),
              );
              Navigator.pushReplacementNamed(context, RouterName.infoUserLogin);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("❌ ${state.message}")));
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter Verification Code',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please enter the 6-digit code sent to ${widget.phoneNumber}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // OTP Field
                Pinput(
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  // onCompleted: (value) async {
                  //   log("✅ Code entered: $value");
                  //   final authCubit = context.read<AuthCubit>();
                  //   if (authCubit.hasVerificationId) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text(
                  //           "Please wait, code is still sending...",
                  //         ),
                  //       ),
                  //     );
                  //     return;
                  //   }
                  //   await authCubit.verifyOtp(value);
                  // },
                  // onCompleted: (value) async {
                  //   log("✅ Code entered: $value");
                  //   final authCubit = context.read<AuthCubit>();

                  //   // ❗ Only show the message if verificationId is NOT ready
                  //   if (!authCubit.hasVerificationId) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text(
                  //           "Please wait, code is still sending...",
                  //         ),
                  //       ),
                  //     );
                  //     return;
                  //   }

                  //   await authCubit.verifyOtp(value);
                  // },
                  onCompleted: (value) async {
                    final cubit = context.read<AuthCubit>();

                    if (!cubit.hasVerificationId) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Still sending code, please wait..."),
                        ),
                      );
                      return;
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Verifying code...")),
                      );
                    }

                    await cubit.verifyOtp(value);
                  },
                ),
                const SizedBox(height: 30),

                // Resend section
                Center(
                  child: TextButton(
                    onPressed: _seconds == 0
                        ? () {
                            context.read<AuthCubit>().sendOtp(
                              widget.phoneNumber,
                            );
                            _startTimer();
                          }
                        : null,
                    child: Text(
                      _seconds > 0
                          ? "Resend Code in 00:${_seconds.toString().padLeft(2, '0')}"
                          : "Resend Code",
                      style: TextStyle(
                        color: _seconds == 0 ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
