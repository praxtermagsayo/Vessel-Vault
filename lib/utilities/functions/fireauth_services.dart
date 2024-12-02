import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vessel_vault/features/authentication/auth.dart';
import 'package:vessel_vault/features/authentication/login.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../../features/authentication/otp.dart';

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

  static Future<void> createUserWithEmailAndOTP(
    BuildContext context,
    String email,
    String password,
    String firstName,
    String lastName,
    String? middleName,
  ) async {
    VFullScreenLoader.openLoadingDialog(
        'Sending OTP', 'assets/images/animations/loading.json');
    try {
      // Generate a 6-digit OTP
      final String otp = (100000 + Random().nextInt(899999)).toString();

      // Store pending registration in Firestore with OTP
      final docRef = FirebaseFirestore.instance.collection('pending_registrations').doc();
      await docRef.set({
        'email': email.trim(),
        'firstName': firstName,
        'lastName': lastName,
        'middleName': middleName,
        'otp': otp,
        'password': password, // Consider encrypting this
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(minutes: 15)),
        ),
      });

      // Send OTP email using Firebase Cloud Functions or your backend

      if (context.mounted) {
        Navigator.pop(context);
        // Navigate to OTP verification screen
        Get.to(() => OTPVerificationScreen(
              email: email,
              registrationId: docRef.id,
            ));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to initiate registration. Please try again.',
        );
      }
    }
  }

  // Verify OTP and complete registration
  static Future<void> verifyOTPAndCreateAccount(
    BuildContext context,
    String registrationId,
    String otp,
  ) async {
    VFullScreenLoader.openLoadingDialog(
        'Verifying', 'assets/images/animations/loading.json');
    try {
      // Get pending registration
      final doc = await FirebaseFirestore.instance
          .collection('pending_registrations')
          .doc(registrationId)
          .get();

      if (!doc.exists) {
        throw 'Registration not found';
      }

      final data = doc.data()!;
      
      if (data['otp'] != otp) {
        throw 'Invalid OTP';
      }

      if ((data['expiresAt'] as Timestamp).toDate().isBefore(DateTime.now())) {
        throw 'OTP expired';
      }

      // Create Firebase Auth account
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data['email'], password: data['password']);

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': data['email'],
        'firstName': data['firstName'],
        'lastName': data['lastName'],
        'middleName': data['middleName'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Delete pending registration
      await doc.reference.delete();

      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.successSnackBar(
          title: 'Account Created',
          message: 'You can now log in with your email and password.',
        );
        Get.to(() => const Login());
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.errorSnackBar(
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }

  static Future<void> resendOTP(BuildContext context, String registrationId) async {
    VFullScreenLoader.openLoadingDialog(
        'Resending OTP', 'assets/images/animations/loading.json');
    try {
      // Generate new OTP
      final String newOtp = (100000 + Random().nextInt(899999)).toString();
      
      // Update the document with new OTP and expiration
      await FirebaseFirestore.instance
          .collection('pending_registrations')
          .doc(registrationId)
          .update({
        'otp': newOtp,
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(minutes: 15)),
        ),
      });

      // Send new OTP email using Firebase Cloud Functions or your backend

      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.successSnackBar(
          title: 'OTP Resent',
          message: 'Please check your email for the new verification code.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        VLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to resend OTP. Please try again.',
        );
      }
    }
  }
}
