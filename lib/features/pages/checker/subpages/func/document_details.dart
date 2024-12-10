import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:vessel_vault/controller/data_controllers/store_data_controller.dart';
import '../../../../../utilities/constants/colors.dart';
import '../../../../../utilities/functions/reusable.dart';
import '../../../../../utilities/popups/loaders.dart';

class DocumentDetails extends StatefulWidget {
  final QueryDocumentSnapshot document;

  const DocumentDetails({
    super.key,
    required this.document,
  });

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  late final TextEditingController areaController;
  late final TextEditingController fishTypeController;
  late final StoreDataController storeController;
  late List<Map<String, dynamic>> customers;
  late List<Map<String, dynamic>> expenses;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    storeController = Get.put(StoreDataController());
    areaController = TextEditingController(text: widget.document['area']);
    fishTypeController =
        TextEditingController(text: widget.document['fishType']);
    customers =
        List<Map<String, dynamic>>.from(widget.document['customers'] ?? []);
    expenses = List<Map<String, dynamic>>.from(widget.document['expenses'] ?? []);
  }

  Future<void> _updateDocument() async {
    try {
      final updatedData = {
        'area': areaController.text,
        'fishType': fishTypeController.text,
        'customers': customers,
        'expenses': expenses,
        'date_time': widget.document['date_time'],
      };

      await storeController.updateDocument(
        widget.document.id,
        updatedData,
      );

      setState(() => isEditing = false);

      VLoaders.successSnackBar(
        title: 'Success',
        message: 'Document updated successfully!',
      );
    } catch (e) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to update document',
      );
    }
  }


  Future<void> _addNewCustomer() async {
    final nameController = TextEditingController();
    final kiloController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            myText(
              label: 'Name',
              context: context,
              controller: nameController,
              inputType: TextInputType.name,
              action: TextInputAction.next,
            ),
            mySize(10, 0, null),
            myText(
              label: 'Kilo',
              context: context,
              controller: kiloController,
              inputType: TextInputType.number,
              action: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          myButton(
            context: context,
            isPrimary: false,
            onTap: () {
              if (nameController.text.isNotEmpty &&
                  kiloController.text.isNotEmpty) {
                setState(() {
                  customers.add({
                    'name': nameController.text,
                    'kilo': kiloController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            label: 'Add',
          ),
        ],
      ),
    );

    nameController.dispose();
    kiloController.dispose();
  }

  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
    });
  }


  Future<void> _addNewExpense() async {
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
              inputType: TextInputType.text,
              action: TextInputAction.next,
            ),
            mySize(10, 0, null),
            myText(
              label: 'Amount',
              context: context,
              controller: amountController,
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
              if (categoryController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                setState(() {
                  expenses.add({
                    'category': categoryController.text,
                    'amount': amountController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            label: 'Add',
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
  }

  Widget _buildAreaSection() {
    return mySection(context, 'Area', [
      myText(
        context: context,
        controller: areaController,
        hint: 'eg. Canubay',
        inputType: TextInputType.text,
        action: TextInputAction.next,
        enabled: isEditing,
      ),
    ]);
  }

  Widget _buildFishTypeSection() {
    return mySection(context, 'Fish Type', [
      myText(
        context: context,
        controller: fishTypeController,
        hint: 'eg. Regular Mix',
        inputType: TextInputType.text,
        action: TextInputAction.next,
        enabled: isEditing,
      ),
    ]);
  }

  Widget _buildCustomerListItem(int index, Map<String, dynamic> customer) {
    return ListTile(
      title: Row(
        children: [
          Text(
            customer['name'],
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          Text(
            customer['kilo'],
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (isEditing)
            IconButton(
              onPressed: () => _deleteCustomer(index),
              icon: const Icon(Iconsax.trash, color: VColors.error),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomersSection() {
    return mySection(
      context,
      'Customers',
      [
        _buildCustomerHeader(),
        _buildCustomerList(),
      ],
    );
  }

  Widget _buildCustomerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Name', style: Theme.of(context).textTheme.labelSmall),
        Text('Kilo/s', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildCustomerList() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? VColors.accent
            : VColors.darkAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return _buildCustomerListItem(index, customer);
            },
          ),
          if (isEditing)
            myButton(
              context: context,
              isPrimary: false,
              onTap: _addNewCustomer,
              label: 'Add Customer',
            ),
        ],
      ),
    );
  }

  Widget _buildExpensesSection() {
    return mySection(
      context,
      'Expenses',
      [
        _buildExpenseHeader(),
        _buildExpenseList(),
      ],
    );
  }

  Widget _buildExpenseHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Category', style: Theme.of(context).textTheme.labelSmall),
        Text('Amount', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildExpenseList() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? VColors.accent
            : VColors.darkAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return _buildExpenseListItem(index, expense);
            },
          ),
          if (isEditing)
            myButton(
              context: context,
              isPrimary: false,
              onTap: _addNewExpense,
              label: 'Add Expense',
            ),
        ],
      ),
    );
  }

  Widget _buildExpenseListItem(int index, Map<String, dynamic> expense) {
    return ListTile(
      title: Row(
        children: [
          Text(
            expense['category'],
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          Text(
            '₱${expense['amount']}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (isEditing)
            IconButton(
              onPressed: () => _deleteExpense(index),
              icon: const Icon(Iconsax.trash, color: VColors.error),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEditing) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Changes?'),
              content: const Text(
                  'You have unsaved changes. Are you sure you want to discard them?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: myAppBar(
          autoLeading: true,
          context: context,
          title: 'Document Details',
          action: true,
          actionIcon: isEditing ? Iconsax.slash : Iconsax.edit,
          onActionPressed: () {
            setState(() => isEditing = !isEditing);
          },
        ),
        body: myBody(
          context: context,
          children: [
            _buildAreaSection(),
            _buildFishTypeSection(),
            _buildDateSection(context),
            _buildCustomersSection(),
            _buildExpensesSection(),
            mySize(100, 0, null),
          ],
          child: isEditing
              ? myButton(
                  context: context,
                  isPrimary: true,
                  onTap: _updateDocument,
                  label: 'Update',
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    return mySection(
      context,
      'Date Created',
      [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? VColors.accent
                : VColors.darkAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM dd yyyy').format(widget.document['date_time'].toDate()),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  DateFormat('h:mm a').format(widget.document['date_time'].toDate()),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    areaController.dispose();
    fishTypeController.dispose();
    super.dispose();
  }
}
