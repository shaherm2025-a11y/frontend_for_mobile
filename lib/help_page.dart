import 'package:flutter/material.dart';
import 'package:plant_diagnosis_app/l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.howToUse),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          t.appUsageDetails,
          style: const TextStyle(
            fontSize: 16,
            height: 1.7,
          ),
        ),
      ),
    );
  }
}