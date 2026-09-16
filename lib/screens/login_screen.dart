import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _languages = ['English', 'हिन्दी', 'தமிழ்'];

  void _showInspectorLoginDialog() {
    final idController = TextEditingController();
    final pinController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(AppLocalizations.of(context)!.loginInspectorLogin),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginInspectorId, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              obscureText: true,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.loginPin, border: const OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.loginCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              final success = await auth.loginAsInspector(idController.text, pinController.text);
              if (success) {
                if (ctx.mounted) Navigator.pop(ctx);
                if (mounted) context.go(Constants.routeHome);
              }
            },
            child: Text(AppLocalizations.of(context)!.loginLoginBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/app_logo.png', width: 120, height: 120),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<AuthProvider>().loginAsGuest();
                          context.go(Constants.routeHome);
                        },
                        child: Text(AppLocalizations.of(context)!.loginContinueAsGuest),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showInspectorLoginDialog,
                        child: Text(AppLocalizations.of(context)!.loginInspectorLogin),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Language Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: context.watch<SettingsProvider>().language,
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            context.read<SettingsProvider>().setLanguage(newValue);
                          }
                        },
                        items: _languages.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
