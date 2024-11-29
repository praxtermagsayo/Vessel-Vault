import 'package:flutter/material.dart';
import 'package:vessel_vault/utilities/theme/custom_theme/card_theme.dart';
import 'package:vessel_vault/utilities/theme/custom_theme/text_theme.dart';
import '../../utilities/theme/custom_theme/input_decoration_theme.dart';
import '../constants/colors.dart';
import 'custom_theme/elevated_button_theme.dart';

class Vtheme {
  Vtheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: VColors.primary,
    scaffoldBackgroundColor: VColors.lightBackground,
    textTheme: VTextTheme.lightTextTheme,
    inputDecorationTheme: VInputDecoration.lightInputDecorationTheme,
    elevatedButtonTheme: VElevatedButtonTheme.lightElevatedButtonTheme,
    cardTheme: VCardTheme.lightCardTheme,
    colorScheme: VColors.lightColorScheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: VColors.primary,
    scaffoldBackgroundColor: VColors.darkBackground,
    textTheme: VTextTheme.darkTextTheme,
    inputDecorationTheme: VInputDecoration.darkInputDecorationTheme,
    elevatedButtonTheme: VElevatedButtonTheme.darkElevatedButtonTheme,
    cardTheme: VCardTheme.darkCardTheme,
    colorScheme: VColors.darkColorScheme,
  );
}
