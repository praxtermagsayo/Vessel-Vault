import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/features/authentication/login.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import '../../utilities/functions/reusable.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailCon = TextEditingController();

  Future<void> resetPassword() async {
    VLoaders.showLoading(context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailCon.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
        Get.to(const Login());
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Forgot Password',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                mySize(20, 0, null),
                Text(
                    'Enter your email address below, and we\'ll send you instructions to reset your password.',
                    style: Theme.of(context).textTheme.labelMedium),
                mySize(20, 0, null),
                myText(
                  context: context,
                  label: 'Email',
                  hint: 'Enter your email address',
                  controller: emailCon,
                  inputType: TextInputType.emailAddress,
                  action: TextInputAction.done,
                ),
                mySize(20, 0, null),
                myButton(
                  context: context,
                  isPrimary: true,
                  onTap: resetPassword,
                  label: 'Send Reset Link',
                ),
                mySize(10, 0, null),
                myButton(
                  context: context,
                  isPrimary: false,
                  onTap: () {
                    Get.to(const Login());
                  },
                  label: 'Sign in',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCon.dispose();
    super.dispose();
  }
}
