import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/utilities/loaders/circular_loader.dart';
import '../../controller/data_controllers/auth_controller.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    
    return const Scaffold(
      body: Center(
        child: VCircularLoader()
      ),
    );
  }
}
