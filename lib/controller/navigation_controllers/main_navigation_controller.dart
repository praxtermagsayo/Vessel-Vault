import 'package:get/get.dart';
import 'package:vessel_vault/features/pages/checker/documents.dart';
import 'package:vessel_vault/features/pages/checker/home.dart';
import 'package:vessel_vault/features/pages/checker/reports.dart';

class MainNavigationController extends GetxController {
  static MainNavigationController get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Home(),
    const Documents(),
    const Reports(),
  ];
}
