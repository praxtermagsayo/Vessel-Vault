import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import '../../features/models/document_model.dart';
import 'package:vessel_vault/features/models/report_model.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';

class StoreDataController extends GetxController {
  // Firebase instances
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference _documents =
      FirebaseFirestore.instance.collection('documents');
  final CollectionReference _expenses =
      FirebaseFirestore.instance.collection('expenses');

  // Text Controllers
  final TextEditingController areaController = TextEditingController();
  final TextEditingController fishTypeController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerKiloController = TextEditingController();
  final TextEditingController expenseCategoryController = TextEditingController();
  final TextEditingController expenseAmountController = TextEditingController();
  final String filePath = '';

  // Observable variables
  final RxMap<int, Map<String, dynamic>> tempCustomers =
      <int, Map<String, dynamic>>{}.obs;
  final RxMap<String, dynamic> customersFinal = <String, dynamic>{}.obs;
  RxInt customerId = 0.obs;
  final List<Map<String, String>> customersLists = [];
  final RxMap<int, Map<String, dynamic>> tempExpenses = <int, Map<String, dynamic>>{}.obs;
  RxInt expenseId = 0.obs;
  final List<Map<String, String>> expensesLists = [];

  void addCustomer(String name, String kilo) {
    if (name.isEmpty || kilo.isEmpty) return;
    customerId++;
    tempCustomers[customerId.value] = {
      'uid': user.uid,
      'customerId': customerId.value,
      'name': name,
      'kilo': kilo,
    };
    updateCustomersList();
  }

  void deleteCustomer(int id) {
    tempCustomers.remove(id);
    updateCustomersList();
  }

  void updateCustomersList() {
    customersLists.clear();
    tempCustomers.forEach((_, value) {
      customersLists.add({
        'name': value['name'],
        'kilo': value['kilo'],
      });
    });
  }

  void clearInputs() {
    // Clear text controllers
    areaController.clear();
    fishTypeController.clear();
    customerNameController.clear();
    customerKiloController.clear();
    expenseCategoryController.clear();
    expenseAmountController.clear();

    // Clear temporary maps
    tempCustomers.clear();
    tempExpenses.clear();

    // Reset IDs
    customerId.value = 0;
    expenseId.value = 0;

    // Clear lists
    customersLists.clear();
    expensesLists.clear();
  }

  void clearCustomerInputs() {
    customerNameController.clear();
    customerKiloController.clear();
  }

  void clearExpenseInputs() {
    expenseCategoryController.clear();
    expenseAmountController.clear();
  }

  Future<void> storeDocument(dynamic document) async {
    try {
      VFullScreenLoader.openLoadingDialog(
          'Uploading document...', 'assets/images/animations/loading.json');

      final collectionRef = document is DocumentModel ? _documents : _expenses;
      await collectionRef.add(document.toJson());
    } catch (e) {
      throw Exception('Failed to store document: ${e.toString()}');
    } finally {
      VFullScreenLoader.stopLoading();
    }
  }

  Future<void> addCustomerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            myText(
                label: 'Name',
                context: context,
                controller: customerNameController,
                inputType: TextInputType.name,
                action: TextInputAction.next),
            mySize(10, 0, null),
            myText(
                label: 'Kilo',
                context: context,
                controller: customerKiloController,
                inputType: TextInputType.number,
                action: TextInputAction.done),
          ],
        ),
        actions: [
          myButton(
            context: context,
            isPrimary: false,
            onTap: () {
              if (customerNameController.text.isNotEmpty &&
                  customerKiloController.text.isNotEmpty) {
              addCustomer(
                  customerNameController.text, customerKiloController.text);
              clearCustomerInputs();
              Navigator.pop(context);
              }
            },
            label: 'Add',
          ),
        ],
      ),
    );
  }

  Future<void> updateDocument(
      String documentId, Map<String, dynamic> data) async {
    try {
      VFullScreenLoader.openLoadingDialog(
          'Updating document...', 'assets/images/animations/loading.json');

      await _documents.doc(documentId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    } finally {
      VFullScreenLoader.stopLoading();
    }
  }

  Future<void> storeExpense(Map<String, dynamic> expenseData) async {
    try {
      await _expenses.add(expenseData);
    } catch (e) {
      throw Exception('Failed to store expense: ${e.toString()}');
    }
  }

  void addExpense(String category, String amount) {
    if (category.isEmpty || amount.isEmpty) return;
    expenseId++;
    tempExpenses[expenseId.value] = {
      'uid': user.uid,
      'expenseId': expenseId.value,
      'category': category,
      'amount': amount,
    };
    updateExpensesList();
  }

  void deleteExpense(int id) {
    tempExpenses.remove(id);
    updateExpensesList();
  }

  void updateExpensesList() {
    expensesLists.clear();
    tempExpenses.forEach((_, value) {
      expensesLists.add({
        'category': value['category'],
        'amount': value['amount'],
      });
    });
  }

  Future<void> addExpenseDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            myText(
              label: 'Category',
              context: context,
              controller: expenseCategoryController,
              inputType: TextInputType.text,
              action: TextInputAction.next,
            ),
            mySize(10, 0, null),
            myText(
              label: 'Amount',
              context: context,
              controller: expenseAmountController,
              inputType: TextInputType.number,
              action: TextInputAction.done,
              prefix: '₱',
            ),
          ],
        ),
        actions: [
          myButton(
            context: context,
            isPrimary: false,
            onTap: () {
              if (expenseCategoryController.text.isNotEmpty &&
                  expenseAmountController.text.isNotEmpty) {
                addExpense(
                  expenseCategoryController.text,
                  expenseAmountController.text,
                );
                clearExpenseInputs();
                Navigator.pop(context);
              }
            },
            label: 'Add',
          ),
        ],
      ),
    );
  }

  Future<void> storeReport() async {
    try {
      VFullScreenLoader.openLoadingDialog(
          'Generating Report', 'assets/images/animations/loading.json');

      updateCustomersList();
      updateExpensesList();

      final report = ReportModel(
        uid: user.uid,
        area: areaController.text,
        fishType: fishTypeController.text,
        customers: customersLists,
        expenses: expensesLists,
        filePath: filePath,
      );

      // Store in Firestore
      await FirebaseFirestore.instance
          .collection('reports')
          .add(report.toJson());

      // Clear inputs after successful storage
      clearInputs();

      // Show success message
      VLoaders.successSnackBar(
        title: 'Success',
        message: 'Report generated and stored successfully!',
      );

      // Navigate back
      Get.back();
    } catch (e) {
      // Show error message
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to store report: ${e.toString()}',
      );
    } finally {
      // Hide loading indicator
      VFullScreenLoader.stopLoading();
    }
  }

  @override
  void onClose() {
    areaController.dispose();
    fishTypeController.dispose();
    customerNameController.dispose();
    customerKiloController.dispose();
    expenseCategoryController.dispose();
    expenseAmountController.dispose();
    super.onClose();
  }
}
