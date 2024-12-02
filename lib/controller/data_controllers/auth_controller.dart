import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/features/authentication/login.dart';
import 'package:vessel_vault/features/pages/checker/main_navigation.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  
  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
    super.onReady();
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const Login());
    } else {
      await user.reload();
      if (!user.emailVerified) {
        await _auth.signOut();
        VLoaders.errorSnackBar(
          title: 'Email Not Verified',
          message: 'Please verify your email before logging in.',
        );
        Get.offAll(() => const Login());
      } else {
        Get.offAll(() => const MainNavigation());
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to sign out. Please try again.',
      );
    }
  }
}