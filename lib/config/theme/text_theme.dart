// lib/config/theme/text_theme.dart
import 'package:flutter/material.dart';

TextTheme buildTextTheme(TextTheme base) {
  return base.copyWith(
    headlineMedium: base.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
      letterSpacing: 0.2,
    ),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
    labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}
