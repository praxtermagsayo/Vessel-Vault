import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vessel_vault/controller/data_controllers/login_controller.dart';
import 'package:vessel_vault/features/authentication/forgot_password.dart';
import '../../utilities/functions/fireauth_services.dart';
import '../../utilities/functions/reusable.dart';
import '../../utilities/providers/theme_provider.dart';
import 'register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mySize(
                      250.0,
                      250.0,
                      Image.asset(
                        themeProvider.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    mySize(20, 0, null),
                    myText(
                        context: context,
                        label: 'Email',
                        hint: 'Enter your email address',
                        controller: controller.email,
                        inputType: TextInputType.emailAddress,
                        action: TextInputAction.next),
                    mySize(10, 0, null),
                    Obx(
                      () => myText(
                          context: context,
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: controller.password,
                          inputType: TextInputType.visiblePassword,
                          obscure: controller.obscure.value,
                          onTap: () {
                            controller.obscure.value =
                                !controller.obscure.value;
                          },
                          suffix: Icon(controller.obscure.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          action: TextInputAction.done),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        mySize(0, 5, null),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            Get.to(() => const RegisterPage());
                          },
                          child: Text(
                            'Create an account',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),
                    myButton(
                        context: context,
                        isPrimary: true,
                        onTap: () async {
                          await FireAuthServices.signIn(context,
                              controller.email.text, controller.password.text);
                          controller.clearInputs();
                        },
                        label: 'Login'),
                    mySize(10, 0, null),
                    myButton(
                        context: context,
                        isPrimary: false,
                        onTap: () {
                          Get.to(() => const ForgotPassword());
                        },
                        label: 'Forgot Password'),
                    mySize(40, 0, null),
                    const Text('OR'),
                    mySize(40, 0, null),
                    myButton(
                        context: context,
                        isPrimary: false,
                        onTap: () async {
                          await FireAuthServices.signInWithGoogle(context);
                        },
                        label: 'Login with Gmail',
                        image: 'assets/icon/google_logo.png'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
