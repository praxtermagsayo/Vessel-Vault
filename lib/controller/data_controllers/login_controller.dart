import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final obscure = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();

  void clearInputs() {
    email.clear();
    password.clear();
  }
}
