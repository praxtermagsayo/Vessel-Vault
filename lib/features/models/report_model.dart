import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String uid;
  final String area;
  final String fishType;
  final List<Map<String, dynamic>> customers;
  final List<Map<String, dynamic>> expenses;
  final DateTime dateTime;
  final String filePath;

  ReportModel({
    required this.uid,
    required this.area,
    required this.fishType,
    required this.customers,
    required this.expenses,
    required this.filePath,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'area': area,
      'fishType': fishType,
      'customers': customers,
      'expenses': expenses,
      'date_time': dateTime,
      'filePath': filePath,
    };
  }

  // Create from Firestore document
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      uid: json['uid'],
      area: json['area'],
      fishType: json['fishType'],
      customers: List<Map<String, dynamic>>.from(json['customers']),
      expenses: List<Map<String, dynamic>>.from(json['expenses']),
      dateTime: (json['date_time'] as Timestamp).toDate(),
      filePath: json['filePath'],
    );
  }
} 