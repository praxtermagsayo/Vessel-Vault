import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/controller/data_controllers/fetch_data_controller.dart';
import 'package:vessel_vault/features/pages/checker/subpages/func/generate_report.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';

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
            'Recent Documents',
            [
              dataController.buildDataList(
                context,
                dataController.fetchRecentDocuments(),
                useSection: true,
                onTapItem: (document) async {
                  try {
                    VFullScreenLoader.openLoadingDialog(
                      'Generating report...',
                      'assets/images/animations/loading.json',
                    );
                    await ReportGenerator.generateAndOpenReport(document);
                    VLoaders.successSnackBar(
                      title: 'Success',
                      message: 'Report generated successfully!',
                    );
                  } catch (e) {
                    VLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to generate report',
                    );
                  } finally {
                    VFullScreenLoader.stopLoading();
                  }
                },
              ),
            ],
          ),
          mySize(24, 0, null),
          mySection(
            context,
            'All Documents',
            [
              dataController.buildDataList(
                context,
                dataController.fetchAllDocuments(),
                useSection: true,
                onTapItem: (document) async {
                  try {
                    VFullScreenLoader.openLoadingDialog(
                      'Generating report...',
                      'assets/images/animations/loading.json',
                    );
                    await ReportGenerator.generateAndOpenReport(document);
                    VLoaders.successSnackBar(
                      title: 'Success',
                      message: 'Report generated successfully!',
                    );
                  } catch (e) {
                    VLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to generate report',
                    );
                  } finally {
                    VFullScreenLoader.stopLoading();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
