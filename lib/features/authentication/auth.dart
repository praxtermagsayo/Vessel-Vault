import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/utilities/loaders/circular_loader.dart';
import 'login.dart';
import '../pages/checker/main_navigation.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const VCircularLoader();
          }
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(() => const MainNavigation());
            });
            return const SizedBox.shrink();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
