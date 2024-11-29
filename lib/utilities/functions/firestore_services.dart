import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import 'package:vessel_vault/features/models/user_model.dart';

class FirestoreServices {
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(BuildContext context, UserModel user) async {
    VLoaders.showLoading(context);
    await _db.collection("user").add(user.toJson()).whenComplete(() {
      Navigator.pop(context);
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      Navigator.pop(context);
    });
  }
}
