import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.howToUseApp),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _card(Icons.info, t.howToUseApp, t.help_intro),

          _card(Icons.search, t.diagnosePlant, t.help_diagnosis),

          _card(Icons.person, t.contactExperts, t.help_experts),

          _card(Icons.bug_report, t.pestsDiseases, t.help_pests),

          _card(Icons.menu_book, t.awarenessGuide, t.help_awareness),

          _card(Icons.language, t.changeLanguage, t.help_language),

          _card(Icons.settings, t.settings, t.help_settings),

        ],
      ),
    );
  }

  Widget _card(IconData icon, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}