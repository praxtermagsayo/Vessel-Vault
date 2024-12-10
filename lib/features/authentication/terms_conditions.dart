import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditions {
  static void showTermsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Acceptance of Terms',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        '2. User Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        '3. Privacy Policy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Your privacy is important to us. Any personal information you provide will be handled in accordance with our Privacy Policy.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        '4. User Obligations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'You agree to use the application in compliance with all applicable laws and regulations. You will not use the application for any unlawful purpose.',
                      ),
                      SizedBox(height: 8),
                      Text(
                        '5. Data Security',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'We implement security measures to protect your information. However, no method of transmission over the internet is 100% secure.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}