import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/core/shared_widgets.dart/custom_elevated_button.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
import 'package:nasaa/features/login/presentation/widgets/gender.dart';
import 'package:nasaa/features/login/presentation/widgets/text_form_field.dart';

class InfoUserLogin extends StatelessWidget {
  InfoUserLogin({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUserRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ User Registered Successfully")),
            );
            Navigator.pushReplacementNamed(context, RouterName.home);
          }
        },

        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Let’s Get to Know You", style: TextStyle(fontSize: 26)),
                  SizedBox(height: 20),
                  Center(
                    child: DottedBorder(
                      options: CircularDottedBorderOptions(
                        padding: const EdgeInsets.all(50),
                        color: Colors.grey,
                        strokeWidth: 2,
                        dashPattern: [10, 5],
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.add_a_photo_sharp, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Profile Photo",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        TextFormFieldUserInfo(
                          controller: nameController,
                          validator: (String? p1) {
                            if (p1!.isEmpty) {
                              return "Please Enter Your Full Name";
                            }
                          },
                          hintText: "Enter Your Full Name",
                          data: "Full Name",
                        ),
                        TextFormFieldUserInfo(
                          controller: emailController,
                          validator: (String? p1) {},
                          hintText: "Enter Your Email Address",
                          data: "Email Address (Optinal)",
                        ),
                        TextFormFieldUserInfo(
                          controller: emailController,
                          validator: (String? p1) {
                            if (p1!.isEmpty) {
                              return "Please Enter Your Date Of Birth";
                            }
                          },
                          hintText: "Date Of Birth",
                          data: "Date Of Birth",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.calendar_month_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GenderSelector(),
                  SizedBox(height: 40),
                  CustomElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context.read<AuthCubit>().rgisterUser(
                          user: UserModelSp(
                            name: nameController.text,
                            email: emailController.text,
                          ),
                        );
                      }
                    },
                    text: "Finish",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
