import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/controller/data_controllers/fetch_data_controller.dart';
import 'package:vessel_vault/features/pages/checker/subpages/func/create_document.dart';
import '../../../utilities/functions/reusable.dart';

class Documents extends StatelessWidget {
  const Documents({super.key});

  @override
  Widget build(BuildContext context) {
    final dataController = Get.find<FetchDataController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: 'Documents',
        action: true,
      ),
      body: myBody(
        context: context,
        children: [
          mySearchBar(context, searchController, 'Search documents...'),
          mySection(
            context,
            'Recent Documents',
            [
              dataController.buildDataList(
                context, 
                dataController.fetchAllDocuments(),
                useSection: true,
              ),
            ],
          ),
          mySize(24, 0, null),
        ],
        child: myButton(
          context, 
          true, 
          () => Get.to(() => const CreateDocument()), 
          'New Document'
        ),
      ),
    );
  }
}
