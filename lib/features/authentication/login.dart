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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
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
                        TextButton(
                          onPressed: () {
                            Get.to(() => const RegisterPage());
                          },
                          child: Text(
                            'Create an account',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    myButton(context, true, () {
                      FireAuthServices.signIn(context, controller.email.text,
                          controller.password.text);
                      controller.clearInputs();
                    }, 'Login'),
                    mySize(10, 0, null),
                    myButton(context, false, () {
                      Get.to(() => const ForgotPassword());
                    }, 'Forgot Password'),
                    mySize(40, 0, null),
                    myButton(context, false, () {
                      Get.to(() => const RegisterPage());
                    }, 'Login with Gmail'),
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
