import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../theme/stitch_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

import 'edit_profile_screen.dart';
import 'notification_settings_screen.dart';
import 'rule_updates_screen.dart';
import 'package:label_guard/l10n/app_localizations.dart';
// If your login screen is elsewhere, adjust this import or rely on go_router
// import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        debugPrint('Picked file path: ${image.path}');
        if (mounted) {
          context.read<SettingsProvider>().setProfileImagePath(image.path);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: StitchTheme.primary,
      width: 96,
      height: 96,
      child: const Icon(Icons.person, color: Colors.white, size: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in SafeArea and ConstrainedBox for tablet support
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profileTitle,
          style: StitchTheme.headlineMd.copyWith(
            color: StitchTheme.primary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: StitchTheme.primary,
                foregroundColor: StitchTheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: Text(AppLocalizations.of(context)!.profileSyncNow, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 120, // Space for bottom FAB
                  ),
                  children: [
                    _buildUserInfoCard(settings),
                    const SizedBox(height: 24),
                    _buildSettingsGroup1(context, settings),
                    const SizedBox(height: 24),
                    _buildSettingsGroup2(context, settings),
                    const SizedBox(height: 16),
                    _buildLogoutButton(context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: StitchTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StitchTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1917).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: StitchTheme.primaryContainer, width: 2),
                  ),
                  child: ClipOval(
                    key: ValueKey(settings.profileImagePath ?? 'default'),
                    child: (settings.profileImagePath != null && !kIsWeb)
                        ? Image.file(
                            File(settings.profileImagePath!),
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar();
                            },
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE7E5E4), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF1C1917),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            settings.profileName,
            style: StitchTheme.headlineMd.copyWith(color: StitchTheme.primary),
          ),
          const SizedBox(height: 4),
          Text(
            'Senior Field Officer',
            style: StitchTheme.bodySm.copyWith(color: StitchTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup1(BuildContext context, SettingsProvider settings) {
    return Container(
      decoration: BoxDecoration(
        color: StitchTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StitchTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1917).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionItem(
            icon: Icons.manage_accounts,
            title: AppLocalizations.of(context)!.profileAccountSettings,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
          ),
          Divider(height: 1, color: StitchTheme.outlineVariant),
          _buildActionItem(
            icon: Icons.language,
            title: AppLocalizations.of(context)!.profileLanguage,
            trailingText: settings.language,
            onTap: () => _showLanguageSheet(context, settings),
          ),
          Divider(height: 1, color: StitchTheme.outlineVariant),
          _buildActionItem(
            icon: Icons.notifications,
            title: AppLocalizations.of(context)!.profileNotificationPreferences,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup2(BuildContext context, SettingsProvider settings) {
    return Container(
      decoration: BoxDecoration(
        color: StitchTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StitchTheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1917).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionItem(
            icon: Icons.cloud_sync,
            title: AppLocalizations.of(context)!.profileOfflineStorage,
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: StitchTheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '3 PENDING',
                style: StitchTheme.labelMd.copyWith(color: StitchTheme.onSecondary),
              ),
            ),
            onTap: () => context.push('/offline_sync'),
          ),
          Divider(height: 1, color: StitchTheme.outlineVariant),
          _buildActionItem(
            icon: Icons.gavel,
            title: AppLocalizations.of(context)!.profileLegalRuleUpdates,
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '2026',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RuleUpdatesScreen())),
          ),
          Divider(height: 1, color: StitchTheme.outlineVariant),
          _buildActionItem(
            icon: Icons.fingerprint,
            title: 'Digital Signature',
            onTap: () => context.push('/digital_signature'),
          ),
          Divider(height: 1, color: StitchTheme.outlineVariant),
          _buildActionItem(
            icon: Icons.info,
            title: AppLocalizations.of(context)!.profileAboutCheckIt,
            onTap: () => context.push('/about'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    String? trailingText,
    TextStyle? trailingTextStyle,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: StitchTheme.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: StitchTheme.onSurfaceVariant, size: 20),
      ),
      title: Text(
        title,
        style: StitchTheme.bodyLg.copyWith(color: StitchTheme.onSurface),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ignore: use_null_aware_elements
          if (trailingWidget != null) trailingWidget,
          if (trailingText != null)
            Text(
              trailingText,
              style: trailingTextStyle ?? StitchTheme.bodySm.copyWith(color: StitchTheme.onSurfaceVariant),
            ),
          if (trailingWidget != null || trailingText != null) const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: StitchTheme.onSurfaceVariant, size: 24),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: StitchTheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final languages = ['English', 'हिन्दी', 'தமிழ்'];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectLanguage, style: StitchTheme.headlineMd.copyWith(color: StitchTheme.primary)),
                const SizedBox(height: 16),
                ...languages.map((lang) {
                  final isSelected = settings.language == lang;
                  return ListTile(
                    title: Text(lang, style: StitchTheme.bodyMd.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    trailing: isSelected ? const Icon(Icons.check, color: StitchTheme.primary) : null,
                    onTap: () {
                      Navigator.pop(context);
                      settings.setLanguage(lang);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: StitchTheme.surfaceContainerLowest,
              title: Text(AppLocalizations.of(context)!.logoutConfirmationTitle),
              content: Text(AppLocalizations.of(context)!.logoutConfirmationContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.btnCancel),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close dialog

                    await context.read<AuthProvider>().logout();
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out successfully')),
                      );
                      try {
                        context.go('/login');
                      } catch (e) {
                        Navigator.of(context).popUntil((route) => false);
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.btnLogout, style: const TextStyle(color: StitchTheme.error)),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: StitchTheme.surfaceContainerLowest,
          side: const BorderSide(color: StitchTheme.errorContainer),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: StitchTheme.error),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.profileLogout,
              style: StitchTheme.headlineMd.copyWith(color: StitchTheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
