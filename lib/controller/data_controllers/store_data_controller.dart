import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import '../../features/models/document_model.dart';

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

  // Observable variables
  final RxMap<int, Map<String, dynamic>> tempCustomers =
      <int, Map<String, dynamic>>{}.obs;
  final RxMap<String, dynamic> customersFinal = <String, dynamic>{}.obs;
  RxInt customerId = 0.obs;
  final List<Map<String, String>> customersLists = [];

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
    areaController.clear();
    fishTypeController.clear();
  }

  void clearCustomerInputs() {
    customerNameController.clear();
    customerKiloController.clear();
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
          myButton(context, false, () {
            if (customerNameController.text.isNotEmpty &&
                customerKiloController.text.isNotEmpty) {
              addCustomer(
                  customerNameController.text, customerKiloController.text);
              clearCustomerInputs();
              Navigator.pop(context);
            }
          }, 'Add'),
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

  @override
  void onClose() {
    areaController.dispose();
    fishTypeController.dispose();
    customerNameController.dispose();
    customerKiloController.dispose();
    super.onClose();
  }
}
