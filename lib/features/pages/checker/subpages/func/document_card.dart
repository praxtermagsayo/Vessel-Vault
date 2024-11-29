import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../utilities/functions/reusable.dart';
import 'document_details.dart';

class DocumentCard extends StatelessWidget {
  final QueryDocumentSnapshot document;
  
  const DocumentCard({
    super.key,
    required this.document,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentDetails(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      margin: const EdgeInsets.symmetric(vertical: 2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.description),
                ),
                mySize(0, 8, null),
                _buildDocumentInfo(context),
                const Spacer(),
                _buildTimeInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document['area'],
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400
          ),
        ),
        Text(
          DateFormat('MMMM dd yyyy').format(document['date_time'].toDate()),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w200
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('h:mm a').format(document['date_time'].toDate()),
        ),
      ],
    );
  }
}
