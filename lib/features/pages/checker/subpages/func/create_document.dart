import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vessel_vault/features/models/document_model.dart';
import 'package:vessel_vault/controller/data_controllers/store_data_controller.dart';
import 'package:vessel_vault/utilities/constants/colors.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';
import 'package:vessel_vault/utilities/loaders/full_screen_loader.dart';
import 'package:vessel_vault/utilities/popups/loaders.dart';

class CreateDocument extends StatefulWidget {
  const CreateDocument({super.key});

  @override
  State<CreateDocument> createState() => _CreateDocumentState();
}

class _CreateDocumentState extends State<CreateDocument> {
  late final StoreDataController controller;

  @override
  void initState() {
    super.initState();
    controller = StoreDataController();
  }

  Widget _buildAreaSection() {
    return mySection(context, 'Area', [
      myText(
        context: context,
        controller: controller.areaController,
        hint: 'eg. Canubay',
        inputType: TextInputType.text,
        action: TextInputAction.next,
      ),
    ]);
  }

  Widget _buildFishTypeSection() {
    return mySection(context, 'Fish Type', [
      myText(
        context: context,
        controller: controller.fishTypeController,
        hint: 'eg. Regular Mix',
        inputType: TextInputType.text,
        action: TextInputAction.next,
      ),
    ]);
  }

  Widget _buildCustomerListItem(int customerKey, Map<String, dynamic> customer) {
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
          IconButton(
            onPressed: () => controller.deleteCustomer(customerKey),
            icon: const Icon(Iconsax.trash, color: VColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersSection() {
    return Obx(
      () => mySection(
        context,
        'Customers',
        [
          _buildCustomerHeader(),
          _buildCustomerList(),
        ],
      ),
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
            itemCount: controller.tempCustomers.length,
            itemBuilder: (context, index) {
              final customerKey = controller.tempCustomers.keys.toList()[index];
              final customer = controller.tempCustomers[customerKey]!;
              return _buildCustomerListItem(customerKey, customer);
            },
          ),
          myButton(
            context,
            false,
            () => controller.addCustomerDialog(context),
            'Add Customer',
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    try {
      controller.updateCustomersList();
      final document = DocumentModel(
        uid: controller.user.uid,
        area: controller.areaController.text,
        fishType: controller.fishTypeController.text,
        customers: controller.customersLists,
      );
      await controller.storeDocument(document);
      controller.clearInputs();
      VLoaders.successSnackBar(
        title: 'Success',
        message: 'Document uploaded successfully!',
      );
    } catch (e) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to upload document',
      );
    } finally {
      VFullScreenLoader.stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Create Document'),
      body: myBody(
        context: context,
        children: [
          _buildAreaSection(),
          _buildFishTypeSection(),
          _buildCustomersSection(),
        ],
        child: myButton(context, true, _handleSubmit, 'Submit'),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
