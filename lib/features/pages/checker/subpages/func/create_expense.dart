import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vessel_vault/utilities/constants/colors.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/features/pages/checker/subpages/func/expense_details.dart';
import '../../../../../controller/data_controllers/fetch_data_controller.dart';

class CreateExpense extends StatelessWidget {
  const CreateExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final fetchController = Get.find<FetchDataController>();

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Select Document'),
      body: myBody(
        context: context,
        children: [
          _buildDocumentSection(context, 'Recent Documents',
              fetchController.fetchRecentDocuments()),
          mySize(24, 0, null),
          _buildDocumentSection(
              context, 'All Documents', fetchController.fetchAllDocuments()),
        ],
      ),
    );
  }

  Widget _buildDocumentSection(
      BuildContext context, String title, Stream<QuerySnapshot> stream) {
    return mySection(
      context,
      title,
      [
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final documents = snapshot.data!.docs;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? VColors.accent
                    : VColors.darkAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  return Card(
                    color: Theme.of(context).cardTheme.color,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: InkWell(
                      onTap: () => Get.to(() => ExpenseDetails(document: doc)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc['area'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    DateFormat('MMMM dd yyyy')
                                        .format(doc['date_time'].toDate()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontWeight: FontWeight.w200),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('h:mm a')
                                      .format(doc['date_time'].toDate()),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
