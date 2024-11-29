import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vessel_vault/utilities/constants/images.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _stringMode = 'System Theme';
  String _logo = VImages.lightAppLogo;

  ThemeMode get themeMode => _themeMode;
  String get stringMode => _stringMode;
  String get logo => _logo;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    switch (mode) {
      case ThemeMode.light:
        _stringMode = 'Light Theme';
        _logo = VImages.lightAppLogo;
        break;
      case ThemeMode.dark:
        _stringMode = 'Dark Theme';
        _logo = VImages.darkAppLogo;
        break;
      case ThemeMode.system:
        _stringMode = 'System Theme';
        _logo = _getSystemLogo();
        break;
    }
    await _saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    final themeModeIndex = preferences.getInt('themeMode') ?? 0; // 0 = system (default)
    _themeMode = ThemeMode.values[themeModeIndex];
    
    switch (_themeMode) {
      case ThemeMode.light:
        _stringMode = 'Light Theme';
        _logo = VImages.lightAppLogo;
        break;
      case ThemeMode.dark:
        _stringMode = 'Dark Theme';
        _logo = VImages.darkAppLogo;
        break;
      case ThemeMode.system:
        _stringMode = 'System Theme';
        _logo = _getSystemLogo();
        break;
    }
    notifyListeners();
  }

  String _getSystemLogo() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    return brightness == Brightness.dark
        ? VImages.darkAppLogo
        : VImages.lightAppLogo;
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('themeMode', mode.index);
  }
}
