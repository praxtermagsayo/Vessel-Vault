import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vessel_vault/features/authentication/login.dart';
import 'package:vessel_vault/features/pages/checker/main_navigation.dart';
import 'package:vessel_vault/utilities/loaders/circular_loader.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: VCircularLoader());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            
            if (!user.emailVerified) {
              FirebaseAuth.instance.signOut();
              VLoaders.errorSnackBar(
                title: 'Email Not Verified',
                message: 'Please verify your email before logging in.',
              );
              return const Login();
            }
            
            return const MainNavigation();
          }

          return const Login();
        },
      ),
    );
  }
}
