import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../theme/stitch_theme.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.surface,
        title: Text(AppLocalizations.of(context)!.notificationSettingsTitle, style: StitchTheme.titleLg.copyWith(color: StitchTheme.primary)),
        iconTheme: IconThemeData(color: StitchTheme.primary),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildToggleCard(AppLocalizations.of(context)!.notifScanAlerts, settings.scanAlerts, settings.setScanAlerts),
              const SizedBox(height: 8),
              _buildToggleCard(AppLocalizations.of(context)!.notifCriticalAlerts, settings.criticalAlerts, settings.setCriticalAlerts),
              const SizedBox(height: 8),
              _buildToggleCard(AppLocalizations.of(context)!.notifReportAlerts, settings.reportAlerts, settings.setReportAlerts),
              const SizedBox(height: 8),
              _buildToggleCard(AppLocalizations.of(context)!.notifDailySummary, settings.dailySummary, settings.setDailySummary),
              const SizedBox(height: 8),
              _buildToggleCard(AppLocalizations.of(context)!.notifSoundEffects, settings.soundEffects, settings.setSoundEffects),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleCard(String title, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: StitchTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: StitchTheme.bodyMd.copyWith(fontWeight: FontWeight.w500)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: StitchTheme.complianceGreen,
          inactiveTrackColor: StitchTheme.surfaceVariant,
        ),
      ),
    );
  }
}
