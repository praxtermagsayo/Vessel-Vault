import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../loaders/animation_loader.dart';

class VFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            color: Theme.of(Get.context!).brightness == Brightness.light
                ? VColors.accent
                : VColors.darkAccent,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                VAnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
