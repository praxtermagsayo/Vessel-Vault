import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String uid;
  final String category;
  final String amount;

  ExpenseModel({
    required this.uid,
    required this.category,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'category': category,
      'amount': amount,
      'date_time': FieldValue.serverTimestamp(),
    };
  }
}