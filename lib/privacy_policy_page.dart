import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String htmlData = "";

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final path = isArabic
        ? "assets/privacy/privacy_ar.html"
        : "assets/privacy/privacy_en.html";

    final data = await rootBundle.loadString(path);

    if (!mounted) return;

    setState(() {
      htmlData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.privacyPolicy),
      ),
      body: htmlData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Html(
                data: htmlData,
                style: {
                  "body": Style(
                    fontSize: FontSize(16),
                    lineHeight: LineHeight.number(1.6),
                  ),
                },
              ),
            ),
    );
  }
}