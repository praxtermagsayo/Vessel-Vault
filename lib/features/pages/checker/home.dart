import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vessel_vault/controller/data_controllers/fetch_data_controller.dart';
import '../../../utilities/functions/reusable.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FetchDataController dataController = Get.put(FetchDataController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Dashboard', action: true),
      body: myBody(
        context: context, 
        children: [
          mySearchBar(
            context, 
            searchController,
            'Search documents, expenses, reports...'
          ),
          myTripleNav(context),
          mySection(
            context, 
            'Recent Documents', 
            [
              dataController.buildDataList(
                context,
                dataController.fetchRecentDocuments(),
                useSection: false,
              ),
            ]
          ),
          mySection(
            context, 
            'Recent Expenses', 
            [
              dataController.buildDataList(
                context,
                dataController.fetchRecentExpenses(),
                useSection: false,
              ),
            ]
          ),
          mySize(10, 0, null)
        ]
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
