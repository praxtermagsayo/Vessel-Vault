import 'package:get/get.dart';
import 'package:vessel_vault/features/network/network_connection.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
