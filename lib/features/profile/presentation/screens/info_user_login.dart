import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasaa/config/cache_helper.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/shared_widgets.dart/custom_elevated_button.dart';
import '../../../login/data/models/user_model.dart';
import '../../../login/presentation/cubit/auth_cubit.dart';
import '../../../login/presentation/cubit/auth_state.dart';
import '../../../login/presentation/widgets/gender.dart';
import '../../../login/presentation/widgets/text_form_field.dart';

class InfoUserLogin extends StatefulWidget {
  final bool isEditMode;
  const InfoUserLogin({super.key, this.isEditMode = false});

  @override
  State<InfoUserLogin> createState() => _InfoUserLoginState();
}

class _InfoUserLoginState extends State<InfoUserLogin> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  String selectedGender = 'Male';
  File? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (widget.isEditMode) {
      await _loadUserData();
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  /// ✅ Load cached user info
  Future<void> _loadUserData() async {
    final name = CacheHelper.getString(key: CacheKeys.nameKey);
    final email = CacheHelper.getString(key: CacheKeys.emailKey);
    final dateOfBirth = CacheHelper.getString(key: CacheKeys.birthKey);
    final gender = CacheHelper.getString(key: CacheKeys.genderKey);
    final imagePath = CacheHelper.getString(key: CacheKeys.imageKey);

    setState(() {
      nameController.text = name ?? '';
      emailController.text = email ?? '';
      dateOfBirthController.text = dateOfBirth ?? '';
      selectedGender = gender ?? 'Male';
      if (imagePath != null && imagePath.isNotEmpty) {
        _profileImage = File(imagePath);
      }
    });

    log('✅ Loaded cached user data: $name, $email, $gender');
  }

  /// ✅ Pick image and persist it
  Future<void> pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final imageFile = File(picked.path);
    final appDir = await getApplicationDocumentsDirectory();
    final savedImage = await imageFile.copy('${appDir.path}/${picked.name}');

    log('Image saved at: ${savedImage.path}');
    await CacheHelper.set(key: CacheKeys.imageKey, value: savedImage.path);

    setState(() {
      _profileImage = savedImage;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile Image Saved Successfully")),
      );
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (dateOfBirthController.text.isNotEmpty) {
      try {
        final parts = dateOfBirthController.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        log('Error parsing date: $e');
      }
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateOfBirthController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: widget.isEditMode
          ? AppBar(title: const Text("Edit Profile"), centerTitle: true)
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) async {
                if (state is AuthUserRegistered) {
                  // ✅ Save to ProfileCubit (to make sure image + data persist)
                  await context.read<ProfileCubit>().registerUser(
                    user: UserModelSp(
                      name: nameController.text,
                      email: emailController.text,
                      Gender: selectedGender,
                      DateOfBirth: dateOfBirthController.text,
                      profileImage: _profileImage?.path,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.isEditMode
                            ? "✅ Profile Updated Successfully"
                            : "✅ User Registered Successfully",
                      ),
                    ),
                  );

                  if (widget.isEditMode) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouterName.mainNavigationScreen,
                      (route) => false,
                    );
                  }
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 17.0,
                      horizontal: 22,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isEditMode ? "" : "Let's Get to Know You",
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(height: 20),

                          // ✅ Profile Image
                          Center(
                            child: GestureDetector(
                              onTap: pickAndSaveImage,
                              child: _profileImage != null
                                  ? Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 70,
                                          backgroundImage: FileImage(
                                            _profileImage!,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.brown.shade300,
                                              width: 1,
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
                                      options:
                                          const CircularDottedBorderOptions(
                                            padding: EdgeInsets.all(50),
                                            color: Colors.grey,
                                            strokeWidth: 2,
                                            dashPattern: [10, 5],
                                          ),
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.add_a_photo_sharp,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            widget.isEditMode
                                                ? "Add Profile Photo"
                                                : "Profile Photo",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: scheme.onBackground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ✅ Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormFieldUserInfo(
                                  controller: nameController,
                                  validator: (value) => value!.isEmpty
                                      ? "Please Enter Your Full Name"
                                      : null,
                                  hintText: "Enter Your Full Name",
                                  data: "Full Name",
                                ),
                                TextFormFieldUserInfo(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value)) {
                                        return "Please Enter a Valid Email Address";
                                      }
                                    }
                                    return null;
                                  },
                                  hintText: "Enter Your Email Address",
                                  data: "Email Address (Optional)",
                                ),
                                TextFormFieldUserInfo(
                                  controller: dateOfBirthController,
                                  readOnly: true,
                                  onTap: () => _selectBirthDate(context),
                                  validator: (value) => value!.isEmpty
                                      ? "Please Enter Your Date Of Birth"
                                      : null,
                                  hintText: "Date Of Birth",
                                  data: "Date Of Birth",
                                  suffixIcon: IconButton(
                                    onPressed: () => _selectBirthDate(context),
                                    icon: const Icon(
                                      Icons.calendar_month_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ✅ Gender Selector
                          GenderSelector(
                            initialGender: selectedGender,
                            onGenderChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),

                          const SizedBox(height: 40),

                          // ✅ Submit Button
                          CustomElevatedButton(
                            onPressed: state is AuthLoadingState
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final user = UserModelSp(
                                        name: nameController.text,
                                        email: emailController.text,
                                        DateOfBirth: dateOfBirthController.text,
                                        Gender: selectedGender,
                                        profileImage: _profileImage?.path,
                                      );

                                      if (widget.isEditMode) {
                                        await context
                                            .read<ProfileCubit>()
                                            .registerUser(user: user);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "✅ Profile Updated Successfully",
                                            ),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        await context
                                            .read<AuthCubit>()
                                            .rgisterUser(user: user);
                                      }
                                    }
                                  },
                            text: state is AuthLoadingState
                                ? "Please wait..."
                                : (widget.isEditMode
                                      ? "Update Profile"
                                      : "Finish"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
