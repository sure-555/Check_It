import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_provider.dart';
import '../theme/stitch_theme.dart';
import '../../config/constants.dart';

class BatchSetupScreen extends StatefulWidget {
  const BatchSetupScreen({super.key});

  @override
  State<BatchSetupScreen> createState() => _BatchSetupScreenState();
}

class _BatchSetupScreenState extends State<BatchSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _startScanning() {
    if (_formKey.currentState!.validate()) {
      final scanProvider = context.read<ScanProvider>();
      scanProvider.startBatch(
        _shopController.text.trim(),
        _locationController.text.trim(),
        _selectedDate,
      );
      context.push(Constants.routeScan);
    }
  }

  @override
  void dispose() {
    _shopController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        title: const Text('New Batch Inspection'),
        backgroundColor: StitchTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scan'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch Details',
                  style: StitchTheme.headlineMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: StitchTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the details for the shop or establishment being inspected.',
                  style: StitchTheme.bodyMd.copyWith(
                    color: StitchTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _shopController,
                  decoration: InputDecoration(
                    labelText: 'Shop/Establishment Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: StitchTheme.surface,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location/Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: StitchTheme.surface,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Inspection Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: StitchTheme.surface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.toLocal()}'.split(' ')[0],
                          style: StitchTheme.bodyLg,
                        ),
                        const Icon(Icons.calendar_today, color: StitchTheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startScanning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StitchTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Start Scanning'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
