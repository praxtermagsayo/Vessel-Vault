import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/controller/navigation_controllers/main_navigation_controller.dart';
import 'package:vessel_vault/utilities/constants/colors.dart';
import 'package:vessel_vault/utilities/constants/icons.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(MainNavigationController());
    return Scaffold(
      body: Obx(() => navController.screens[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: Colors.transparent,
          height: 100,
          elevation: 0,
          selectedIndex: navController.selectedIndex.value,
          indicatorColor: Theme.of(context).brightness == Brightness.light
              ? VColors.primary
              : VColors.darkAccent,
          onDestinationSelected: (index) =>
              navController.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(VIcons.homeIcon), label: 'Home'),
            NavigationDestination(
                icon: Icon(VIcons.documentsIcon), label: 'Documents'),
            NavigationDestination(
                icon: Icon(VIcons.expensesIcon), label: 'Expenses'),
            NavigationDestination(icon: Icon(VIcons.reports), label: 'Reports'),
          ],
        ),
      ),
    );
  }
}
