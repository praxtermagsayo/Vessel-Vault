import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utilities/loaders/full_screen_loader.dart';
import '../../../../../utilities/popups/loaders.dart';
import '../../../../models/report_model.dart';
import '../../../../../utilities/functions/reusable.dart';
import '../../../../../controller/data_controllers/fetch_data_controller.dart';

class GenReports extends StatelessWidget {
  const GenReports({super.key});

  @override
  Widget build(BuildContext context) {
    final dataController = Get.put(FetchDataController());

    return Scaffold(
      appBar: myAppBar(context: context, title: 'Generate Report', action: true),
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
                onTapItem: (document) => ReportGenerator.generateAndOpenReport(document),
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
                onTapItem: (document) => ReportGenerator.generateAndOpenReport(document),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportGenerator {
  static Future<void> generateAndOpenReport(QueryDocumentSnapshot document) async {
    try {
      VFullScreenLoader.openLoadingDialog(
        'Generating report...',
        'assets/images/animations/loading.json',
      );

      final fontData = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: ttf,
          ),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                pw.SizedBox(height: 20),
                _buildDocumentInfo(document),
                pw.SizedBox(height: 20),
                _buildCustomersTable(document),
                pw.SizedBox(height: 20),
                _buildExpensesTable(document),
              ],
            );
          },
        ),
      );

      // Generate and save PDF
      final output = await getTemporaryDirectory();
      final date = DateFormat('yyyy-MM-dd-HH-mm').format(DateTime.now());
      final filePath = '${output.path}/Report_$date.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Create and store report model
      final report = ReportModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        area: document['area'],
        fishType: document['fishType'],
        customers: List<Map<String, dynamic>>.from(document['customers'] ?? []),
        expenses: List<Map<String, dynamic>>.from(document['expenses'] ?? []),
      );

      await FirebaseFirestore.instance
          .collection('reports')
          .add(report.toJson());

      // Open the generated PDF
      await OpenFile.open(filePath);

      VLoaders.successSnackBar(
        title: 'Success',
        message: 'Report generated and stored successfully!',
      );
    } catch (e) {
      VLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to generate report: ${e.toString()}',
      );
    } finally {
      VFullScreenLoader.stopLoading();
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'Document Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          DateFormat('MMMM dd, yyyy').format(DateTime.now()),
          style: const pw.TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  static pw.Widget _buildDocumentInfo(QueryDocumentSnapshot document) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Document Details',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Area: ${document['area']}'),
        pw.Text('Fish Type: ${document['fishType']}'),
        pw.Text(
          'Date: ${DateFormat('MMMM dd, yyyy h:mm a').format(document['date_time'].toDate())}',
        ),
      ],
    );
  }

  static pw.Widget _buildCustomersTable(QueryDocumentSnapshot document) {
    final customers = List<Map<String, dynamic>>.from(document['customers'] ?? []);
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Customers',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            // Header
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    'Name',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    'Kilo',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
            // Data rows
            ...customers.map(
              (customer) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(customer['name']),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(customer['kilo']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildExpensesTable(QueryDocumentSnapshot document) {
    final expenses = List<Map<String, dynamic>>.from(document['expenses'] ?? []);
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Expenses',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            // Header
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    'Category',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    'Amount',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
            // Data rows
            ...expenses.map(
              (expense) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(expense['category']),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('PHP ${expense['amount']}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
