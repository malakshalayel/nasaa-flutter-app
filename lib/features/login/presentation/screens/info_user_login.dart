import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/core/shared_widgets.dart/custom_elevated_button.dart';
import 'package:nasaa/features/login/data/models/user_model.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_state.dart';
import 'package:nasaa/features/login/presentation/widgets/gender.dart';
import 'package:nasaa/features/login/presentation/widgets/text_form_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoUserLogin extends StatefulWidget {
  InfoUserLogin({super.key});

  @override
  State<InfoUserLogin> createState() => _InfoUserLoginState();
}

class _InfoUserLoginState extends State<InfoUserLogin> {
  late final TextEditingController nameController;

  late final TextEditingController emailController;

  late final TextEditingController dateOfBirthController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _profileImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    dateOfBirthController = TextEditingController();
    _loadSaveImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> pickAndSafeImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    // Save the image to the user's profile
    final imageFile = File(picked.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = picked.name;
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    log('Image saved at: ${savedImage.path}');
    String imageKey = 'profile_image';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(imageKey, savedImage.path);

    setState(() {
      _profileImage = savedImage;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Profile Image Saved Successfully")),
    );
  }

  _loadSaveImage() async {
    String imageKey = 'profile_image';
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(imageKey);
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
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
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let’s Get to Know You",
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: _profileImage != null
                          ? Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(_profileImage!),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.brown.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.brown,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          : DottedBorder(
                              options: CircularDottedBorderOptions(
                                padding: const EdgeInsets.all(50),
                                color: Colors.grey,
                                strokeWidth: 2,
                                dashPattern: [10, 5],
                              ),
                              child: GestureDetector(
                                onTap: () => pickAndSafeImage(),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_sharp,
                                      color: Colors.grey,
                                    ),
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
                            validator: (String? p1) {
                              if (p1!.isEmpty) {
                                return "Please Enter Your Email Address";
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(p1)) {
                                return "Please Enter a Valid Email Address";
                              }
                            },
                            hintText: "Enter Your Email Address",
                            data: "Email Address (Optinal)",
                          ),
                          TextFormFieldUserInfo(
                            controller: dateOfBirthController,
                            readOnly: true,
                            onTap: () {
                              _selectBirthDate(context);
                            },
                            validator: (String? p1) {
                              if (p1!.isEmpty) {
                                return "Please Enter Your Date Of Birth";
                              }
                            },
                            hintText: "Date Of Birth",
                            data: "Date Of Birth",
                            suffixIcon: IconButton(
                              onPressed: () {
                                _selectBirthDate(context);
                              },
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
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date shown in the picker
      firstDate: DateTime(1900), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date (e.g., today)
    );

    if (pickedDate != null) {
      dateOfBirthController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      // Handle the selected birth date
      print('Selected birth date: ${pickedDate.toLocal()}');
    }
  }
}
