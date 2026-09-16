import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../theme/stitch_theme.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _deptController;
  late TextEditingController _badgeController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _nameController = TextEditingController(text: settings.profileName);
    _idController = TextEditingController(text: settings.profileId);
    _deptController = TextEditingController(text: settings.profileDepartment);
    _badgeController = TextEditingController(text: settings.profileBadge);
    _emailController = TextEditingController(text: settings.profileEmail);
    _phoneController = TextEditingController(text: settings.profilePhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _deptController.dispose();
    _badgeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      context.read<SettingsProvider>().updateProfile(
        name: _nameController.text,
        id: _idController.text,
        department: _deptController.text,
        badge: _badgeController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.msgProfileUpdated),
          backgroundColor: StitchTheme.complianceGreen,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.surface,
        title: Text(AppLocalizations.of(context)!.editProfileTitle, style: StitchTheme.titleLg.copyWith(color: StitchTheme.primary)),
        iconTheme: IconThemeData(color: StitchTheme.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(AppLocalizations.of(context)!.editFullName, _nameController, validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.errNameRequired : null),
              const SizedBox(height: 16),
              _buildField(AppLocalizations.of(context)!.editInspectorId, _idController),
              const SizedBox(height: 16),
              _buildField(AppLocalizations.of(context)!.editDepartment, _deptController),
              const SizedBox(height: 16),
              _buildField(AppLocalizations.of(context)!.editBadgeNumber, _badgeController),
              const SizedBox(height: 16),
              _buildField(AppLocalizations.of(context)!.editEmail, _emailController, keyboardType: TextInputType.emailAddress, validator: (v) {
                if (v!.isEmpty) return AppLocalizations.of(context)!.errEmailRequired;
                if (!v.contains('@')) return AppLocalizations.of(context)!.errEmailInvalid;
                return null;
              }),
              const SizedBox(height: 16),
              _buildField(AppLocalizations.of(context)!.editPhone, _phoneController, keyboardType: TextInputType.phone, validator: (v) {
                if (v!.isEmpty) return AppLocalizations.of(context)!.errPhoneRequired;
                if (v.length != 10) return AppLocalizations.of(context)!.errPhoneInvalid;
                return null;
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: StitchTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(AppLocalizations.of(context)!.btnSaveChanges, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {String? Function(String?)? validator, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: StitchTheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: StitchTheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: StitchTheme.outlineVariant),
        ),
      ),
    );
  }
}
