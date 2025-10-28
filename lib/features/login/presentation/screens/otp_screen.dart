import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/login/data/models/send_otp_request.dart';
import 'package:nasaa/features/login/data/models/verify_otp_request.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final SendOtpRequest otpRequest;
  const OtpScreen({super.key, required this.otpRequest});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController _otpController;
  late Timer _timer;
  int _seconds = 60;
  String? value;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startTimer();
    log("📞 OtpScreen started for ${widget.otpRequest.phone}");
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
            // if (state is AuthPhoneVerified) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("✅ Phone verified successfully")),
            //   );
            //   Navigator.pushReplacementNamed(context, RouterName.infoUserLogin);
            // }
            if (state is VerifyOtpState) {
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
                  'Please enter the 6-digit code sent to ${widget.otpRequest!.phone}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // OTP Field
                Pinput(
                  length: 4,
                  controller: _otpController,
                  keyboardType: TextInputType.number,

                  onCompleted: (value) async {
                    this.value = value;
                    final cubit = context.read<AuthCubit>();
                    cubit.verifyOtpApi(
                      VerifyOtpRequest(
                        phone: widget.otpRequest.phone,
                        country: widget.otpRequest.country,
                        otp: value,
                      ),
                    );

                    // if (!cubit.hasVerificationId) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text("Still sending code, please wait..."),
                    //     ),
                    //   );
                    //   return;
                    // }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Verifying code...")),
                      );
                    }

                    //await cubit.verifyOtp(value);
                  },
                ),
                const SizedBox(height: 30),

                // Resend section
                Center(
                  child: TextButton(
                    onPressed: _seconds == 0
                        ? () {
                            context.read<AuthCubit>().verifyOtpApi(
                              VerifyOtpRequest(
                                phone: widget.otpRequest.phone,
                                country: widget.otpRequest.country,
                                otp: value ?? "",
                              ),
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
