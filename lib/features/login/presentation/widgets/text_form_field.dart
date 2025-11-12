import 'package:flutter/material.dart';

class TextFormFieldUserInfo extends StatelessWidget {
  TextFormFieldUserInfo({
    super.key,
    required this.controller,
    required this.validator,
    this.hintText,
    this.data,
    this.suffixIcon,
    this.readOnly,
    this.onTap,
  });
  TextEditingController controller;
  String? Function(String?)? validator;
  String? hintText;
  IconButton? suffixIcon;
  String? data;
  bool? readOnly;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data ?? "",
          style: TextStyle(color: scheme.onBackground, fontSize: 16),
        ),
        SizedBox(height: 8),
        TextFormField(
          onTap: onTap,
          readOnly: readOnly ?? false,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: TextStyle(color: scheme.onBackground.withOpacity(0.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
