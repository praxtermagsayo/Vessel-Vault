import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'terms_conditions.dart';
import '../../utilities/functions/reusable.dart';
import '../../controller/data_controllers/register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Register'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              myText(
                context: context,
                label: 'Email',
                hint: 'Enter your email address',
                controller: controller.emailController,
                inputType: TextInputType.emailAddress,
                action: TextInputAction.next,
                validator: controller.validateEmail,
              ),
              mySize(10, 0, null),
              myText(
                context: context,
                label: 'First Name',
                hint: 'Enter your first name',
                controller: controller.firstNameController,
                action: TextInputAction.next,
                validator: controller.validateFirstName,
              ),
              mySize(10, 0, null),
              myText(
                context: context,
                label: 'Last Name',
                hint: 'Enter your last name',
                controller: controller.lastNameController,
                action: TextInputAction.next,
                validator: controller.validateLastName,
              ),
              mySize(10, 0, null),
              myText(
                context: context,
                label: 'Middle Name (Optional)',
                hint: 'Enter your middle name',
                controller: controller.middleNameController,
                action: TextInputAction.next,
              ),
              mySize(10, 0, null),
              Obx(
                      () => myText(
                          context: context,
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: controller.passwordController,
                          inputType: TextInputType.visiblePassword,
                          obscure: controller.obscure.value,
                          onChanged: controller.checkPasswordStrength,
                          onTap: () {
                            controller.obscure.value =
                                !controller.obscure.value;
                          },
                          suffix: Icon(controller.obscure.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          action: TextInputAction.done,
                          validator: controller.validatePassword),
                    ),
              mySize(10, 0, null),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() => Text(
                  'Password Strength: ${controller.passwordStrength}',
                  style: TextStyle(
                    color: controller.passwordColor.value,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
              mySize(10, 0, null),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: controller.termsAccepted.value,
                        onChanged: controller.toggleTerms,
                      )),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => TermsAndConditions.showTermsDialog(),
                      child: Text(
                        'I accept the terms and conditions',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              mySize(20, 0, null),
              myButton(context: context, isPrimary: true, onTap: controller.register, label: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
