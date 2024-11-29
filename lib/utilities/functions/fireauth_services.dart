import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vessel_vault/features/authentication/auth.dart';
import 'package:vessel_vault/features/authentication/login.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';

class FireAuthServices {
  static Future<void> signIn(
      BuildContext context, String email, String password) async {
    VFullScreenLoader.openLoadingDialog(
        'Logging in', 'assets/images/animations/loading.json');
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.successSnackBar(
            title: 'Logged In', message: 'Welcome ${email.trim()}');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.errorSnackBar(
            title: e.code.toString(),
            message: _getReadableErrorMessage(e.code));
        debugPrint(e.code);
      }
    }
  }

  static String _getReadableErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'missing-password':
        return 'Please input the password field';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'The email address is empty or invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      default:
        return 'An error occurred. Please try again.$errorCode';
    }
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    VLoaders.showLoading(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (context.mounted) Navigator.pop(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<void> signOut(BuildContext context) async {
    VLoaders.showLoading(context);
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pop(context);
      }
      Get.to(() => const Auth());
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<void> resetPassword(BuildContext context, String email) async {
    VLoaders.showLoading(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
        Get.to(() => const Login());
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}