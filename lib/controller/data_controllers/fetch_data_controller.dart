import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/utilities/constants/time_stamps.dart';
import 'package:vessel_vault/utilities/loaders/circular_loader.dart';
import '../../features/pages/checker/subpages/func/document_card.dart';
import '../../utilities/functions/reusable.dart';

class FetchDataController extends GetxController {
  // Firebase instances
  final _firestore = FirebaseFirestore.instance;

  // Observable variables
  final RxList<String> areas = <String>[].obs;

  // Fetch Methods
  Stream<QuerySnapshot> fetchRecentDocuments() {
    return _firestore
        .collection('documents')
        .orderBy('date_time', descending: true)
        .where('date_time', isGreaterThanOrEqualTo: VTimeStamps.getDateFrom(1))
        .snapshots();
  }

  Stream<QuerySnapshot> fetchAllDocuments() {
    return _firestore
        .collection('documents')
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

  Widget buildDataList(BuildContext context, Stream<QuerySnapshot> stream,
      {bool useSection = true}) {
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

        if (!useSection) {
          return _buildSimpleList(context, snapshot.data!.docs);
        }

        return _buildSectionedList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildSimpleList(
      BuildContext context, List<QueryDocumentSnapshot> docs) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) => DocumentCard(document: docs[index]),
      ),
    );
  }

  Widget _buildSectionedList(
      BuildContext context, List<QueryDocumentSnapshot> docs) {
    final groupedDocs = _groupDocumentsByArea(docs);
    final areas = groupedDocs.keys.toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height - 350.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final area = areas[index];
          final areaDocs = groupedDocs[area]!;
          return _buildAreaSection(context, area, areaDocs);
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
      BuildContext context, String area, List<QueryDocumentSnapshot> docs) {
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
            itemBuilder: (context, index) =>
                DocumentCard(document: docs[index]),
          ),
        ),
      ],
    );
  }
}
