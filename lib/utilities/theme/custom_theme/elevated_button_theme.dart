import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class VElevatedButtonTheme {
  VElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: VColors.primary,
      foregroundColor: VColors.textWhite,
    ),
  ); 

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: VColors.primary,
      foregroundColor: VColors.textWhite,
    ),
  );
}