import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/font_size.dart';

class VTextTheme{
  VTextTheme._();

  static TextTheme lightTextTheme = const TextTheme(
    titleLarge: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.largeFont,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.mediumFont,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.smallFont,
      fontWeight: FontWeight.w400,
    ),
    displayLarge: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.largeFont,
    ),
    displayMedium: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.mediumFont,
    ),
    displaySmall: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.smallFont,
    ),
    labelLarge: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.largeFont,
    ),
    labelMedium: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.mediumFont,
    ),
    labelSmall: TextStyle(
      color: VColors.textPrimary,
      fontSize: VFontSize.smallFont,
    ),
  );

static TextTheme darkTextTheme = const TextTheme(
  titleLarge: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.largeFont,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.mediumFont,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.smallFont,
      fontWeight: FontWeight.w400,
    ),
    displayLarge: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.largeFont,
    ),
    displayMedium: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.mediumFont,
    ),
    displaySmall: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.smallFont,
    ),
    labelLarge: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.largeFont,
    ),
    labelMedium: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.mediumFont,
    ),
    labelSmall: TextStyle(
      color: VColors.textWhite,
      fontSize: VFontSize.smallFont,
    ),
  );
}