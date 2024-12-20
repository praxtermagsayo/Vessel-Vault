import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/utilities/constants/time_stamps.dart';
import 'package:vessel_vault/utilities/loaders/circular_loader.dart';
import '../../features/pages/checker/subpages/func/document_card.dart';
import '../../utilities/functions/reusable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../utilities/popups/loaders.dart';

class FetchDataController extends GetxController {
  // Firebase instances
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Observable variables
  final RxList<String> areas = <String>[].obs;
  final searchQuery = ''.obs;
  final RxList<QueryDocumentSnapshot> filteredDocuments =
      <QueryDocumentSnapshot>[].obs;
  final RxList<QueryDocumentSnapshot> allDocuments =
      <QueryDocumentSnapshot>[].obs;

  // Fetch Methods
  Stream<QuerySnapshot> fetchRecentDocuments() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('documents')
        .where('uid', isEqualTo: currentUser?.uid)
        .orderBy('date_time', descending: true)
        .where('date_time', isGreaterThanOrEqualTo: VTimeStamps.getDateFrom(1))
        .snapshots();
  }

  Stream<QuerySnapshot> fetchAllDocuments() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('documents')
        .where('uid', isEqualTo: currentUser?.uid)
        .orderBy('date_time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchRecentExpenses() {
    return _firestore
        .collection('expenses')
        .orderBy('date_time', descending: true)
        .where('date_time', isGreaterThanOrEqualTo: VTimeStamps.getDateFrom(1))
        .snapshots();
  }

  Stream<QuerySnapshot> fetchAllExpenses() {
    return _firestore
        .collection('expenses')
        .orderBy('date_time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchRecentReports() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('reports')
        .where('uid', isEqualTo: currentUser?.uid)
        .orderBy('date_time', descending: true)
        .where('date_time', 
            isGreaterThanOrEqualTo: VTimeStamps.getDateFrom(1))
        .snapshots();
  }

  Stream<QuerySnapshot> fetchAllReports() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('reports')
        .where('uid', isEqualTo: currentUser?.uid)
        .orderBy('date_time', descending: true)
        .snapshots();
  }

  Future<void> fetchAreas(CollectionReference collection) async {
    try {
      final querySnapshot = await collection.get();
      final fetchedAreas = querySnapshot.docs
          .map((doc) => doc['area'] as String)
          .toSet()
          .toList();
      areas.assignAll(fetchedAreas);
    } catch (e) {
      debugPrint('Error fetching areas: $e');
    }
  }

  Widget buildDataList(
    BuildContext context,
    Stream<QuerySnapshot> stream, {
    bool useSection = true,
    Function(QueryDocumentSnapshot)? onTapItem,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const VCircularLoader();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data created recently.'));
        }

        // Store all documents
        allDocuments.value = snapshot.data!.docs;

        // Use filtered documents if search is active
        final documents =
            searchQuery.isEmpty ? snapshot.data!.docs : filteredDocuments;

        if (!useSection) {
          return _buildSimpleList(context, documents, onTapItem);
        }

        return _buildSectionedList(context, documents, onTapItem);
      },
    );
  }

  Widget _buildSimpleList(
    BuildContext context,
    List<QueryDocumentSnapshot> docs,
    Function(QueryDocumentSnapshot)? onTapItem,
  ) {
    return SizedBox(
      height:
          docs.length >= MediaQuery.of(context).size.height / 2 ? 500.0 : 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) => DocumentCard(
          document: docs[index],
          onTap: onTapItem != null ? () => onTapItem(docs[index]) : null,
        ),
      ),
    );
  }

  Widget _buildSectionedList(
    BuildContext context,
    List<QueryDocumentSnapshot> docs,
    Function(QueryDocumentSnapshot)? onTapItem,
  ) {
    final groupedDocs = _groupDocumentsByArea(docs);
    final areas = groupedDocs.keys.toList();

    return SizedBox(
      height: areas.length <= 1
          ? 150.0
          : areas.length <= 4
              ? 150
              : areas.length * 150.0 >= 300.0
                  ? 300.0
                  : areas.length * 150.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final area = areas[index];
          final areaDocs = groupedDocs[area]!;
          return _buildAreaSection(context, area, areaDocs, onTapItem);
        },
      ),
    );
  }

  Map<String, List<QueryDocumentSnapshot>> _groupDocumentsByArea(
      List<QueryDocumentSnapshot> docs) {
    final groupedDocs = <String, List<QueryDocumentSnapshot>>{};
    for (var doc in docs) {
      final area = doc['area'] as String? ?? 'Unknown';
      groupedDocs.putIfAbsent(area, () => []).add(doc);
    }
    return groupedDocs;
  }

  Widget _buildAreaSection(
    BuildContext context,
    String area,
    List<QueryDocumentSnapshot> docs,
    Function(QueryDocumentSnapshot)? onTapItem,
  ) {
    return mySection(
      context,
      area,
      [
        SizedBox(
          height: docs.length * 15.0 >= 300 || docs.length * 15.0 <= 150
              ? 150
              : 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (context, index) => DocumentCard(
              document: docs[index],
              onTap: onTapItem != null ? () => onTapItem(docs[index]) : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFilteredList(
    BuildContext context,
    Stream<QuerySnapshot> stream, {
    bool useSection = true,
    Function(QueryDocumentSnapshot)? onTapItem,
  }) {
    return GetBuilder<FetchDataController>(
      init: this,
      builder: (controller) => StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const VCircularLoader();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data created recently.'));
          }

          final docs = snapshot.data!.docs;

          // Filter documents based on search query
          final filteredDocs = searchQuery.isEmpty
              ? docs
              : docs.where((doc) {
                  final area = doc['area'].toString().toLowerCase();
                  return area.contains(controller.searchQuery.toLowerCase());
                }).toList();

          if (!useSection) {
            return _buildSimpleList(context, filteredDocs, onTapItem);
          }
          return _buildSectionedList(context, filteredDocs, onTapItem);
        },
      ),
    );
  }

  void filterDocuments(String query) {
    searchQuery.value = query;
    update(); // This triggers a rebuild of GetBuilder widgets
  }

  Widget buildReportsList(
    BuildContext context,
    Stream<QuerySnapshot> stream,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const VCircularLoader();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reports generated yet.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final report = snapshot.data!.docs[index];
            final createdAt = (report['createdAt'] as Timestamp).toDate();
            
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text('Report - ${report['area']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fish Type: ${report['fishType']}'),
                    Text('Generated: ${DateFormat('MMM dd, yyyy hh:mm a').format(createdAt)}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () => _viewReport(context, report),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteReport(context, report.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteReport(BuildContext context, String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).delete();
      VLoaders.successSnackBar(
        title: 'Success',
        message: 'Report deleted successfully',
      );
    } catch (e) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to delete report: $e',
      );
    }
  }

  Future<void> _viewReport(BuildContext context, QueryDocumentSnapshot report) async {
    // Implement report viewing logic here
    // This could open a detailed view or regenerate the PDF
  }
}
