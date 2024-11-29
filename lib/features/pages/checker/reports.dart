import 'package:flutter/material.dart';
import 'package:vessel_vault/utilities/functions/reusable.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Reports', action: true),
      body: myBody(
        context: context,
        children: [

        ],
      ),
    );
  }
}
