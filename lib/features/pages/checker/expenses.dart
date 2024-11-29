import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/controller/data_controllers/fetch_data_controller.dart';
import 'package:vessel_vault/features/pages/checker/subpages/func/create_expense.dart';

import '../../../utilities/functions/reusable.dart';

class Expenses extends StatelessWidget {
  const Expenses({super.key});

  @override
  Widget build(BuildContext context) {
    final dataController = Get.find<FetchDataController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Expenses', action: true),
      body: myBody(
        context: context,
        children: [
          mySearchBar(context, searchController, 'Search expenses...'),
          mySection(
            context,
            'All Expenses',
            [
              dataController.buildDataList(
                context,
                dataController.fetchAllExpenses(),
                useSection: true,
              ),
            ],
          ),
        ],
        child: myButton(context, true,
            () => Get.to(() => const CreateExpense()), 'New Expense'),
      ),
    );
  }
}
