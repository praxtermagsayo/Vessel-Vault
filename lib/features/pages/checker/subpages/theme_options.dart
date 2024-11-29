import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utilities/providers/theme_provider.dart';
import '../../../../utilities/functions/reusable.dart';

class ThemeOptions extends StatelessWidget {
  const ThemeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Themes', centerTitle: false),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return myBody(
            context: context,
            children: [
              Column(
                children: [
                  RadioListTile(
                    title: Text('Light Theme',
                        style: Theme.of(context).textTheme.labelMedium),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile(
                    title: Text('Dark Theme',
                        style: Theme.of(context).textTheme.labelMedium),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile(
                    title: Text('System Theme',
                        style: Theme.of(context).textTheme.labelMedium),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                  Text(
                      'If system is selected, Vessel Vault will automatically adjust its theme based on your device\'s system settings', style: Theme.of(context).textTheme.labelSmall,),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
