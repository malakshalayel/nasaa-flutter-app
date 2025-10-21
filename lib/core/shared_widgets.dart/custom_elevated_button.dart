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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(),
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(width: 5),
          Icon(icon, color: Colors.white, size: 25),
        ],
      ),
    );
  }
}
