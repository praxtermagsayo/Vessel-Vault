import 'package:flutter/material.dart';
import 'package:vessel_vault/utilities/constants/colors.dart';

class VCardTheme {
  VCardTheme._();

  static const lightCardTheme = CardTheme(
    color: VColors.accent,
  );
  static const darkCardTheme = CardTheme(
    color: VColors.darkAccent,
  );
}
