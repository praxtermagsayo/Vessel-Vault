import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/features/pages/checker/reports.dart';
import 'package:vessel_vault/features/pages/checker/subpages/settings.dart';
import 'package:vessel_vault/utilities/constants/colors.dart';
import 'package:vessel_vault/utilities/constants/font_size.dart';
import 'package:vessel_vault/utilities/constants/icons.dart';
import 'package:vessel_vault/utilities/functions/fireauth_services.dart';
import '../../features/pages/checker/subpages/func/create_document.dart';
import '../constants/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

Widget myText({
  required BuildContext context,
  String? label,
  String? hint,
  required TextEditingController controller,
  TextInputType inputType = TextInputType.text,
  bool obscure = false,
  bool enabled = true,
  VoidCallback? onTap,
  Widget? suffix,
  String? prefix,
  TextInputAction action = TextInputAction.done,
  Function(String)? onChanged,
  String? Function(String?)? validator,
}) {
  final isWeb = MediaQuery.of(context).size.width > 600;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null) ...[
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        mySize(8, 0, null),
      ],
      TextFormField(
        validator: validator,
        onChanged: onChanged,
        controller: controller,
        enabled: enabled,
        obscureText: obscure,
        keyboardType: inputType,
        textInputAction: action,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: enabled
                  ? Theme.of(context).textTheme.labelMedium?.color
                  : Theme.of(context).disabledColor,
            ),
        decoration: InputDecoration(
          fillColor: enabled
              ? Theme.of(context).inputDecorationTheme.fillColor
              : Theme.of(context).disabledColor.withOpacity(0.1),
          filled: true,
          hintText: hint,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
                fontSize: VFontSize.smallFont,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white30,
              ),
          prefixText: prefix != null ? '₱ ' : null,
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: enabled ? onTap : null,
                  icon: suffix,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isWeb ? 16 : 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: Theme.of(context).brightness == Brightness.light
                ? BorderSide.none
                : const BorderSide(width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: enabled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).disabledColor.withOpacity(0.5),
            ),
          ),
        ),
      ),
    ],
  );
}

SizedBox mySize(double height, double width, Widget? child) {
  return SizedBox(
    height: height,
    width: width,
    child: child ?? child,
  );
}

TextButton myTextButton(
    BuildContext context, VoidCallback onTap, String label) {
  return TextButton(
    onPressed: onTap,
    child: Text(label, style: Theme.of(context).textTheme.labelMedium),
  );
}

Widget myButton(
  BuildContext context,
  bool isPrimary,
  VoidCallback onTap,
  String label,
) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      maximumSize: const Size(double.infinity, 100),
      padding: const EdgeInsets.symmetric(vertical: 4),
      backgroundColor: isPrimary
          ? Theme.of(context)
              .elevatedButtonTheme
              .style
              ?.backgroundColor
              ?.resolve({})
          : Theme.of(context).brightness == Brightness.light
              ? VColors.accent
              : VColors.darkAccent,
      foregroundColor: isPrimary
          ? Theme.of(context)
              .elevatedButtonTheme
              .style
              ?.foregroundColor
              ?.resolve({})
          : Theme.of(context).brightness == Brightness.light
              ? VColors.textPrimary
              : VColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    child: label != 'Logout'
        ? Text(
            label,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout),
              mySize(0, 10, null),
              Text(
                label,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
                ),
              ),
            ],
          ),
  );
}

AppBar myAppBar({
  required BuildContext context,
  required String title,
  bool action = false,
  bool centerTitle = true,
  IconData? actionIcon,
  VoidCallback? onActionPressed,
  bool autoLeading = false,
}) {
  return AppBar(
    forceMaterialTransparency: true,
    title: Text(title, style: Theme.of(context).textTheme.titleLarge),
    centerTitle: centerTitle,
    elevation: 0,
    automaticallyImplyLeading: autoLeading,
    actions: [
      if (action && actionIcon != null)
        IconButton(
          icon: Icon(actionIcon),
          onPressed: onActionPressed,
        )
      else if (action)
        myImageButton(
            context: context,
            imagePath: VImages.userProfile,
            borderWidth: 1,
            size: 35,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            }),
    ],
  );
}

Widget mySearchBar(
  BuildContext context,
  TextEditingController controller,
  String hint, {
  Function(String)? onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle!.copyWith(
              fontSize: VFontSize.smallFont,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black54
                  : Colors.white30,
            ),
        prefixIcon: const Icon(
          Icons.search,
          size: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      controller: controller,
      onChanged: onChanged,
    ),
  );
}

Widget myDoubleNav(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          myNavigationButton(context, () {
            Get.to(() => const CreateDocument());
          }, 'New Document', VIcons.documentIcon),
          myNavigationButton(context, () {
            Get.to(() => const Reports());
          }, 'Generate Report', VIcons.report),
        ],
      ),
    ),
  );
}

Widget myImageButton({
  required BuildContext context,
  required String imagePath,
  required double size,
  required double borderWidth,
  Color? borderColor,
  required VoidCallback onTap,
}) {
  final user = FirebaseAuth.instance.currentUser;
  
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size / 2),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: borderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && 
                  snapshot.data!.exists && 
                  (snapshot.data!.data() as Map<String, dynamic>)['profileImage'] != null) {
                final imageBytes = base64Decode(
                    (snapshot.data!.data() as Map<String, dynamic>)['profileImage']);
                return Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(imagePath, fit: BoxFit.cover);
                  },
                );
              }
              return Image.asset(imagePath, fit: BoxFit.cover);
            },
          ),
        ),
      ),
    ),
  );
}

Widget myNavigationButton(
    BuildContext context, VoidCallback onTap, String label, IconData icon) {
  return SizedBox(
    height: 60,
    child: Card(
      color: Theme.of(context).cardTheme.color,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: MaterialButton(
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, size: Theme.of(context).textTheme.labelLarge?.fontSize),
            mySize(0, 10, null),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: Theme.of(context).textTheme.labelSmall?.fontSize,
            ),
          ],
        ),
      ),
    ),
  );
}

Column mySection(BuildContext context, String title, List<Widget> children) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    ],
  );
}

Container myBody(
    {required BuildContext context,
    required List<Widget> children,
    Widget? child,
    double space = 0}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
    child: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        ),
      ],
    ),
  );
}

Widget buildAreaSection(BuildContext context, String title, String type) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.description),
                  ),
                  mySize(0, 8, null),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text('Date',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontWeight: FontWeight.w200)),
                    ],
                  ),
                  const Spacer(),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Time'),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget myProfile(BuildContext context, String email, String name, Widget image,
    double size, {VoidCallback? onImageTap}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: size / 2),
        child: InkWell(
          onTap: onImageTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: image,
            ),
          ),
        ),
      ),
      mySize(12.0, 0, null),
      Text(
        email,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      Text(
        name,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    ],
  );
}

Widget displayDetails(
    {required BuildContext context, String? totalKilo, String? totalPrice}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? VColors.accent
          : VColors.darkAccent,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Total Kilos(KG): ',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              totalKilo ?? '',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: VColors.primary),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Total Price(₱): ',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              totalPrice ?? '',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.green),
            ),
          ],
        ),
      ],
    ),
  );
}

logOutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      FireAuthServices.signOut(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.green))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ],
        );
      });
}
