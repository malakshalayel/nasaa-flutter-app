import 'package:flutter/material.dart';
import 'package:nasaa/core/shared_widgets.dart/custom_elevated_button.dart';
import 'package:nasaa/features/login/presentation/widgets/text_field_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your  Phone Number",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
              ),
              Text(
                "We’ll send a  message text to verify your number",
                style: TextStyle(color: Color(0xFF676767)),
              ),
              SizedBox(height: 30),
              Form(
                child: TextFieldLogin(emailController: TextEditingController()),
              ),
              SizedBox(height: 30),

              CustomElevatedButton(
                text: "Next",
                onPressed: () {},
                icon: Icons.arrow_right_alt_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
