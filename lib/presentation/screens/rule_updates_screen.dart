import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class RuleUpdatesScreen extends StatelessWidget {
  const RuleUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: StitchTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.ruleUpdatesTitle,
          style: StitchTheme.headlineMd.copyWith(color: StitchTheme.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRuleCard(
            title: AppLocalizations.of(context)!.ruleLmpcTitle,
            subtitle: AppLocalizations.of(context)!.ruleLmpcSubtitle,
          ),
          const SizedBox(height: 16),
          _buildRuleCard(
            title: AppLocalizations.of(context)!.ruleFssaiTitle,
            subtitle: AppLocalizations.of(context)!.ruleFssaiSubtitle,
          ),
          const SizedBox(height: 16),
          _buildRuleCard(
            title: AppLocalizations.of(context)!.ruleDigitalEvidenceTitle,
            subtitle: AppLocalizations.of(context)!.ruleDigitalEvidenceSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({required String title, required String subtitle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1917).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Color(0xFF059669),
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1C1917),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF78716C),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
