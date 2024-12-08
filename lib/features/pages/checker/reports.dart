import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:vessel_vault/controller/data_controllers/fetch_data_controller.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/loaders/circular_loader.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'subpages/func/generate_reports.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final dataController = Get.put(FetchDataController());

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Reports', action: true),
      body: myBody(
        context: context,
        children: [
          mySection(
            context,
            'Recent Reports',
            [
              dataController.buildFilteredList(
                context,
                dataController.fetchRecentReports(),
                useSection: false,
                onTapItem: (report) => _viewReport(context, report),
              ),
            ],
          ),
          mySize(24, 0, null),
          mySection(
            context,
            'Generated Reports',
            [
              StreamBuilder<QuerySnapshot>(
                stream: dataController.fetchAllReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const VCircularLoader();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No reports generated yet'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final report = snapshot.data!.docs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          onTap: () => _viewReport(context, report),
                          leading: const Icon(Icons.description),
                          title: Text(
                            '${report['area']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fish Type: ${report['fishType']}'),
                              Text(
                                  'Date: ${DateFormat('dd/MM/yyyy').format(report['date_time'].toDate())}'),
                            ],
                          ),
                          trailing: const Icon(Icons.check_circle, size: 24),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
        child: myButton(
            context: context,
            isPrimary: true,
            onTap: () {
              Get.to(() => const GenReports());
            },
            label: 'Generate Report'),
      ),
    );
  }

  Future<void> _viewReport(
      BuildContext context, QueryDocumentSnapshot report) async {
    try {
      VFullScreenLoader.openLoadingDialog(
        'Opening Report',
        'assets/images/animations/loading.json',
      );

      await OpenFile.open(report['filePath']);
    } catch (e) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to open report: ${e.toString()}',
      );
    } finally {
      VFullScreenLoader.stopLoading();
    }
  }
}
