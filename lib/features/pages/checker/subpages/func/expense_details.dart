import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:vessel_vault/controller/data_controllers/store_data_controller.dart';
import 'package:vessel_vault/utilities/constants/colors.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';

class ExpenseDetails extends StatefulWidget {
  final QueryDocumentSnapshot document;

  const ExpenseDetails({
    super.key,
    required this.document,
  });

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  final storeController = Get.put(StoreDataController());
  final List<Map<String, dynamic>> expenses = [];
  double total = 0.0;

  void _updateTotal() {
    setState(() {
      total = expenses.fold(
          0,
          (sum, expense) =>
              sum + (double.tryParse(expense['amount'].toString()) ?? 0));
    });
  }

  Future<void> _addExpense() async {
    final categoryController = TextEditingController();
    final amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            myText(
              label: 'Category',
              context: context,
              controller: categoryController,
              hint: 'eg. Fuel, Ice, Food',
              inputType: TextInputType.text,
              action: TextInputAction.next,
            ),
            mySize(10, 0, null),
            myText(
              label: 'Amount',
              context: context,
              controller: amountController,
              hint: 'eg. 1000',
              inputType: TextInputType.number,
              action: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          myButton(
            context,
            false,
            () {
              if (categoryController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                setState(() {
                  expenses.add({
                    'category': categoryController.text,
                    'amount': double.parse(amountController.text),
                  });
                });
                _updateTotal();
                Navigator.pop(context);
              }
            },
            'Add',
          ),
        ],
      ),
    );

    categoryController.dispose();
    amountController.dispose();
  }

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
    _updateTotal();
  }

  Future<void> _handleSubmit() async {
    if (expenses.isEmpty) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Please add at least one expense',
      );
      return;
    }

    try {
      VFullScreenLoader.openLoadingDialog(
        'Creating expense...',
        'assets/images/animations/loading.json'
      );

      await storeController.storeExpense({
        'documentId': widget.document.id,
        'area': widget.document['area'],
        'expenses': expenses,
        'total': total,
        'date_time': DateTime.now(),
        'uid': storeController.user.uid,
      });

      VFullScreenLoader.stopLoading();
      
      VLoaders.successSnackBar(
        title: 'Success',
        message: 'Expense created successfully!',
      );

      // Short delay to allow snackbar to be visible before navigation
      await Future.delayed(const Duration(milliseconds: 800));
      Get.back(); // Return to document selection
      Get.back(); // Return to expenses list
      
    } catch (e) {
      VFullScreenLoader.stopLoading();
      
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to create expense',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: 'Create Expense',
      ),
      body: myBody(
        context: context,
        children: [
          _buildDocumentSection(),
          _buildExpensesSection(),
          _buildTotalSection(),
        ],
        child: myButton(context, true, _handleSubmit, 'Submit'),
      ),
    );
  }

  Widget _buildDocumentSection() {
    return mySection(
      context,
      'Document Details',
      [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? VColors.accent
                : VColors.darkAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Area: ${widget.document['area']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              mySize(8, 0, null),
              Text(
                'Fish Type: ${widget.document['fishType']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              mySize(8, 0, null),
              Text(
                'Date: ${DateFormat('MMMM dd yyyy, h:mm a').format(widget.document['date_time'].toDate())}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesSection() {
    return mySection(
      context,
      'Expenses',
      [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? VColors.accent
                : VColors.darkAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Text(expense['category']),
                        const Spacer(),
                        Text('₱${expense['amount']}'),
                        IconButton(
                          onPressed: () => _deleteExpense(index),
                          icon: const Icon(Iconsax.trash, color: VColors.error),
                        ),
                      ],
                    ),
                  );
                },
              ),
              myButton(
                context,
                false,
                _addExpense,
                'Add Expense',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return mySection(
      context,
      'Total',
      [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? VColors.accent
                : VColors.darkAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '₱$total',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
