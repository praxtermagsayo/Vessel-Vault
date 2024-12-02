import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import '../../utilities/functions/fireauth_services.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscure = true.obs;
  final formKey = GlobalKey<FormState>();
  final termsAccepted = false.obs;
  final passwordStrength = ''.obs;
  final passwordColor = Rx<Color>(Colors.grey);

  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength.value = '';
      passwordColor.value = Colors.grey;
      return;
    }

    // Initialize scoring
    int score = 0;

    // Length check
    if (password.length < 4) {
      passwordStrength.value = 'Very Weak';
      passwordColor.value = Colors.red.shade900;
      return;
    } else if (password.length >= 8) {
      score += 2;
    } else {
      score += 1;
    }

    // Uppercase check
    if (password.contains(RegExp(r'[A-Z]'))) {
      score += 1;
    }

    // Lowercase check
    if (password.contains(RegExp(r'[a-z]'))) {
      score += 1;
    }

    // Number check
    if (password.contains(RegExp(r'[0-9]'))) {
      score += 1;
    }

    // Special character check
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score += 1;
    }

    // Assign strength based on score
    switch (score) {
      case 1:
        passwordStrength.value = 'Very Weak';
        passwordColor.value = Colors.red.shade900;
        break;
      case 2:
        passwordStrength.value = 'Weak';
        passwordColor.value = Colors.red;
        break;
      case 3:
        passwordStrength.value = 'Medium';
        passwordColor.value = Colors.yellow;
        break;
      case 4:
        passwordStrength.value = 'Strong';
        passwordColor.value = Colors.green;
        break;
      case 5:
      case 6:
        passwordStrength.value = 'Very Strong';
        passwordColor.value = Colors.green.shade900;
        break;
    }
  }

  void toggleTerms(bool? value) {
    termsAccepted.value = value ?? false;
  }

  void register() {
    final isFormValid = formKey.currentState?.validate() ?? false;

    // Check terms and conditions
    if (!termsAccepted.value) {
      VLoaders.errorSnackBar(
        title: 'Terms and Conditions',
        message: 'You must accept the terms and conditions',
      );
      return;
    }

    // Check password strength
    if (passwordStrength.value == 'Very Weak' ||
        passwordStrength.value == 'Weak') {
      VLoaders.errorSnackBar(
        title: 'Weak Password',
        message: 'Please choose a stronger password',
      );
      return;
    }

    if (isFormValid) {
      // Call the new registration method with OTP
      FireAuthServices.createUserWithEmailAndOTP(
        Get.context!,
        emailController.text,
        passwordController.text,
        firstNameController.text,
        lastNameController.text,
        middleNameController.text,
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
