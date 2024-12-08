import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: myAppBar(context: context, title: 'Reports'),
      body: myBody(
        context: context,
        children: [
          mySection(
            context,
            'Recent Reports',
            [
              dataController.buildDataList(
                context,
                dataController.fetchRecentReports(),
                useSection: true,
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
                      return ListTile(
                        title: Text('Report - ${report['area']}'),
                        subtitle: Text('Fish Type: ${report['fishType']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () => _viewReport(context, report),
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

  Future<void> _viewReport(BuildContext context, QueryDocumentSnapshot report) async {
  try {
    VFullScreenLoader.openLoadingDialog(
      'Opening Report',
      'assets/images/animations/loading.json',
    );
    
    // Use the existing ReportGenerator to view the report
    await ReportGenerator.generateAndOpenReport(report);
    
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
