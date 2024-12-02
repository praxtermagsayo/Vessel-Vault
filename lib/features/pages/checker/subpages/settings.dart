import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/features/pages/checker/subpages/theme_options.dart';
import 'package:vessel_vault/utilities/constants/images.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import '../../../../utilities/functions/reusable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': user.email,
          'name': user.displayName,
          'profileImage': base64Image,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        await user.updatePhotoURL('has_stored_image');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: $e')),
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
                myProfile(
                  context,
                  '${user.displayName}',
                  '${user.email}',
                  getProfileImage(user.uid, VImages.userProfile),
                  150,
                  onImageTap: () => changeProfilePicture(context),
                ),
                mySection(context, 'Preferences', [
                  myNavigationButton(context, () {
                    Get.to(() => const ThemeOptions());
                  }, 'Theme', Icons.palette),
                ]),
              ],
            ),
          ],
          child: myButton(context, false, () {
            logOutDialog(context);
          }, 'Logout')),
    );
  }
}
