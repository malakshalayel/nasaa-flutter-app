import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nasaa/core/router/router_name.dart';

class LoginFirstScreen extends StatelessWidget {
  const LoginFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Welcome to Nasaa!",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    textAlign: TextAlign.center,
                    "Your journey starts here, whether you’re a Coach or a user. Choose your role and let’s get started!”",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  SizedBox(height: 50),
                  SvgPicture.asset("assets/svg_images/login_img.svg"),
                  SizedBox(height: 90),
                  _customElevatedButton(
                    name: "User",
                    colorText: Colors.black,
                    backGroundColorButton: Color(0xFFEDE9E3),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouterName.login);
                    },
                  ),
                  SizedBox(height: 15),
                  _customElevatedButton(
                    name: "Coach",
                    colorText: Colors.white,
                    backGroundColorButton: Color(0xFF433F40),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customElevatedButton({
    required String name,
    required void Function()? onPressed,
    required Color backGroundColorButton,
    required Color colorText,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: backGroundColorButton,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Continue as a $name",
            style: TextStyle(
              fontSize: 18,
              color: colorText,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(Icons.arrow_right_alt_sharp, color: colorText, size: 35),
        ],
      ),
    );
  }
}
