import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class VInputDecoration{
  VInputDecoration._();

  static InputDecorationTheme lightInputDecorationTheme = const InputDecorationTheme(
    labelStyle: TextStyle(
      color: VColors.textPrimary,
    ),
    floatingLabelStyle: TextStyle(
      color: VColors.textPrimary,
    ),
    suffixIconColor: VColors.textPrimary,
    hintStyle: TextStyle(
      color: VColors.textSecondary,
    ),
    fillColor: VColors.accent,
  );

  static InputDecorationTheme darkInputDecorationTheme = const InputDecorationTheme(
    labelStyle: TextStyle(
      color: VColors.textWhite,
    ),
    floatingLabelStyle: TextStyle(
      color: VColors.textWhite,
    ),
    suffixIconColor: VColors.lightBackground,
    hintStyle: TextStyle(
      color: VColors.textWhite,
    ),
    fillColor: VColors.darkBackground,
  );
}