import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivecyPolicy extends StatelessWidget {
  const PrivecyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terms and Privacy text
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.5,
            ),
            children: [
              const TextSpan(text: '"By Clicking \'Next\', you agree to our '),
              TextSpan(
                text: 'Terms of Use',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Navigate to Terms of Use
                    print('Terms of Use tapped');
                  },
              ),
              const TextSpan(text: ' and\n'),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Navigate to Privacy Policy
                    print('Privacy Policy tapped');
                  },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Home indicator bar
        Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }
}
