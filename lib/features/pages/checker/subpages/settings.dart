import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vessel_vault/features/pages/checker/subpages/theme_options.dart';
import 'package:vessel_vault/utilities/constants/images.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import '../../../../utilities/functions/reusable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utilities/loaders/circular_loader.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void changeProfilePicture(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (image != null) {
      try {
        final user = FirebaseAuth.instance.currentUser!;

        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'profileImage': base64Image,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await user.updatePhotoURL('has_stored_image');

        VLoaders.successSnackBar(
          title: 'Profile Picture Updated',
          message: 'Your profile picture has been updated successfully.',
        );
      } catch (e) {
        VLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to update profile picture. Please try again.',
        );
      }
    }
  }

  Widget getProfileImage(String userId, String defaultImage) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data.containsKey('profileImage')) {
            final imageBytes = base64Decode(data['profileImage']);
            return Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(defaultImage, fit: BoxFit.cover);
              },
            );
          }
        }
        return Image.asset(defaultImage, fit: BoxFit.cover);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Settings'),
      body: myBody(
          context: context,
          children: [
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: VCircularLoader(),
                      );
                    }
                    if (snapshot.hasData) {
                      String displayName = '';

                      if (user.displayName == null ||
                          user.displayName == '') {
                        displayName =
                            '${snapshot.data?.docs[0]['firstName']} ${snapshot.data?.docs[0]['lastName']}';
                      } else {
                        displayName = user.displayName!;
                      }
                      return myProfile(
                        context,
                        displayName,
                        '${user.email}',
                        getProfileImage(user.uid, VImages.userProfile),
                        150,
                        onImageTap: () => changeProfilePicture(context),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                mySection(context, 'Preferences', [
                  myNavigationButton(context, () {
                    Get.to(() => const ThemeOptions());
                  }, 'Theme', Icons.palette),
                ]),
              ],
            ),
          ],
          child: myButton(
            context: context,
            isPrimary: false,
            onTap: () {
              logOutDialog(context);
            },
            label: 'Logout',
            icon: Iconsax.logout
          )),
    );
  }
}
