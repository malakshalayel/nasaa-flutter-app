import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });
  void Function()? onPressed;
  IconData? icon;

  String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.onBackground,
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(color: scheme.background, fontSize: 18)),
          SizedBox(width: 5),
          Icon(icon, color: scheme.onBackground, size: 25),
        ],
      ),
    );
  }
}
