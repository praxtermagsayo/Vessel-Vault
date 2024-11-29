import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportGenerator {
  static Future<void> generateAndOpenReport(QueryDocumentSnapshot document) async {
    // Load the font
    final fontData = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    // Add page to the PDF with the custom font
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

    // Save the PDF
    final output = await getTemporaryDirectory();
    final date = DateFormat('yyyy-MM-dd-HH-mm').format(DateTime.now());
    final filePath = '${output.path}/Report_$date.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF
    await OpenFile.open(filePath);
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

