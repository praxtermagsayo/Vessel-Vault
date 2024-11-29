import 'package:flutter/material.dart';

class VColors {
  VColors._();

  // Basic
  static const Color primary = Color(0xFF17C6ED);
  static const Color secondary = Color(0xFF208589);
  static const Color darkAccent = Color.fromARGB(255, 45, 45, 45);
  static const Color accent = Color(0xFFEBEDED);

  // Texts
  static const Color textPrimary = Color(0xFF193238);
  static const Color textSecondary = Color(0xFF7E8A8C);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Backgrounds
  static const Color lightBackground = Color(0xFFF6F8F9);
  static const Color darkBackground = Color.fromARGB(255, 33, 31, 31);

  static const Color whiteBackground = Color(0xFFFAF9F6);
  static const Color blackBackground = Color(0x000000ff);

  // Indicators

  static const Color error = Color(0xFFBB2124);
  static const Color success = Color(0xFF22BB33);
  static const Color warning = Color(0xFFF0AD4E);

  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: lightBackground,
  );
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: darkBackground,
  );
}
