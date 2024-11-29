import 'package:flutter/material.dart';
import '../../../utilities/constants/colors.dart';

class VCircularLoader extends StatelessWidget {
  const VCircularLoader({
    super.key,
    this.foregroundColor = VColors.whiteBackground,
    this.backgroundColor = VColors.darkBackground,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      // Circular background
      child: Center(
        child: CircularProgressIndicator(
            color: foregroundColor, backgroundColor: Colors.transparent),
      ),
    );
  }
}
