import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/features/pages/checker/subpages/theme_options.dart';
import 'package:vessel_vault/utilities/constants/images.dart';
import '../../../../utilities/functions/reusable.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Settings'),
      body: myBody(
          context: context,
          children: [
            Column(
              children: [
                myProfile(context, '${user.displayName}', '${user.email}',
                    VImages.userProfile, 150),
                mySection(context, 'Preferences', [
                  myNavigationButton(context, () {
                    Get.to(() => const ThemeOptions());
                  }, 'Theme', Icons.palette),
                ]),
              ],
            ),
          ],
          child: myButton(context, false, () {
            logOutDialog(context);
          }, 'Logout')),
    );
  }
}
