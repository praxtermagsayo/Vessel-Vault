import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vessel_vault/bindings/general_bindings.dart';
import 'package:vessel_vault/utilities/providers/theme_provider.dart';
import 'features/authentication/auth.dart';
import 'features/pages/checker/main_navigation.dart';
import 'utilities/theme/themes.dart';

class VesselVault extends StatelessWidget {
  const VesselVault({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GetMaterialApp(
      themeMode: themeProvider.themeMode,
      theme: Vtheme.lightTheme,
      darkTheme: Vtheme.darkTheme,
      initialBinding: GeneralBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Vessel Vault',
      home: const Auth(),
      routes: {
        '/Auth': (context) => const Auth(),
        '/MainNavigation': (context) => const MainNavigation(),
      },
    );
  }
}
