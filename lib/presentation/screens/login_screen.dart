import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../theme/stitch_theme.dart';
import '../../providers/auth_provider.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _publicUsernameController = TextEditingController();
  final _publicPasswordController = TextEditingController();

  final _inspectorIdController = TextEditingController();
  final _inspectorPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _publicUsernameController.dispose();
    _publicPasswordController.dispose();
    _inspectorIdController.dispose();
    _inspectorPasswordController.dispose();
    super.dispose();
  }

  void _showInspectorLoginDialog() {
    _inspectorIdController.clear();
    _inspectorPasswordController.clear();
    setState(() {
      _errorMessage = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: StitchTheme.surfaceContainerLowest,
              title: Text('Inspector Login', style: StitchTheme.headlineMd.copyWith(color: StitchTheme.primary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _inspectorIdController,
                    decoration: InputDecoration(
                      labelText: 'Inspector ID',
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _inspectorPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)?.btnCancel ?? 'Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setStateDialog(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });

                          final authProvider = context.read<AuthProvider>();
                          final success = await authProvider.loginAsInspector(
                            _inspectorIdController.text.trim(),
                            _inspectorPasswordController.text,
                          );

                          setStateDialog(() {
                            _isLoading = false;
                          });

                          if (success && context.mounted) {
                            Navigator.pop(context); // Close dialog
                            context.go('/home'); // Navigate to home
                          } else {
                            setStateDialog(() {
                              _errorMessage = 'Invalid credentials';
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StitchTheme.primary,
                    foregroundColor: StitchTheme.onPrimary,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Login'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Inspector Login Button at Top Right
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _showInspectorLoginDialog,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1C1917), // Charcoal
                ),
                child: const Text('Inspector Login', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 120,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.shield, size: 120, color: StitchTheme.primary),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome to LabelGuard',
                      style: StitchTheme.headlineMd.copyWith(color: StitchTheme.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Public access (optional)',
                      style: StitchTheme.bodyMd.copyWith(color: StitchTheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _publicUsernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _publicPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle public login or skip
                          context.read<AuthProvider>().loginAsGuest();
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StitchTheme.primary,
                          foregroundColor: StitchTheme.onPrimary,
                        ),
                        child: const Text('Continue as Public User'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
