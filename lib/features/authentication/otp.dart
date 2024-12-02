import 'package:flutter/material.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/functions/fireauth_services.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String email;
  final String registrationId;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.registrationId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Verify Email'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verification Code',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            mySize(10, 0, null),
            Text(
              'We have sent a verification code to',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            mySize(20, 0, null),
            myText(
              context: context,
              label: 'Enter OTP',
              hint: 'Enter 6-digit code',
              controller: otpController,
              inputType: TextInputType.number,
              action: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the verification code';
                }
                if (value.length != 6) {
                  return 'Please enter a valid 6-digit code';
                }
                return null;
              },
            ),
            mySize(20, 0, null),
            myButton(
              context,
              true,
              () {
                FireAuthServices.verifyOTPAndCreateAccount(
                  context,
                  registrationId,
                  otpController.text,
                );
              },
              'Verify',
            ),
            mySize(20, 0, null),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive the code?"),
                TextButton(
                  onPressed: () {
                    // Add resend OTP logic here
                    FireAuthServices.resendOTP(context, registrationId);
                  },
                  child: const Text('Resend'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}