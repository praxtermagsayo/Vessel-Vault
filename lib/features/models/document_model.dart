import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String uid;
  final String area;
  final String fishType;
  final List<dynamic> customers;
  final List<dynamic> expenses;

  DocumentModel({
    required this.uid,
    required this.area,
    required this.fishType,
    required this.customers,
    required this.expenses,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "uid": uid,
      "area": area,
      "fishType": fishType,
      "customers": customers,
      "expenses": expenses,
      "date_time": FieldValue.serverTimestamp(),
    };
    return jsonMap;
  }
}
