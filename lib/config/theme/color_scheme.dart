import 'package:flutter/material.dart';

const Color _primaryBrand = Color(0xFFFF6F61); // Coral Red
const Color _secondaryBrand = Color(0xFF03DAC6); // Teal accent

final ColorScheme lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: _primaryBrand,
  onPrimary: Colors.white,
  secondary: _secondaryBrand,
  onSecondary: Colors.white,
  error: Color(0xFFB00020),
  onError: Colors.white,
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF1B1B1B),
  surface: Color(0xFFF5F5F5),
  onSurface: Color(0xFF1B1B1B),
  surfaceVariant: Color(0xFFEDEDED),
  outline: Color(0xFFBDBDBD),
);

final ColorScheme darkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: _primaryBrand,
  onPrimary: Colors.white,
  secondary: _secondaryBrand,
  onSecondary: Colors.black,
  error: Color(0xFFCF6679),
  onError: Colors.black,
  background: Color(0xFF121212),
  onBackground: Color(0xFFEAEAEA),
  surface: Color(0xFF1E1E1E),
  onSurface: Color(0xFFEAEAEA),
  surfaceVariant: Color(0xFF2C2C2C),
  outline: Color(0xFF444444),
);
