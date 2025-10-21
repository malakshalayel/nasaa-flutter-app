import 'package:flutter/material.dart';

class TextFieldLogin extends StatelessWidget {
  TextFieldLogin({super.key, required this.emailController});
  TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),

        controller: emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Your email";
          } else if (!(value.contains("@") && value.contains("."))) {
            return "Invaild email";
          }
        },
      ),
    );
  }
}
