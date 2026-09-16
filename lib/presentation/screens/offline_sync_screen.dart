import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';

class OfflineSyncScreen extends StatefulWidget {
  const OfflineSyncScreen({super.key});

  @override
  State<OfflineSyncScreen> createState() => _OfflineSyncScreenState();
}

class _OfflineSyncScreenState extends State<OfflineSyncScreen> {
  final List<Map<String, String>> _mockInspections = [
    {
      'productName': 'Organic Honey 500g',
      'date': '2026-09-01 10:30 AM',
    },
    {
      'productName': 'Premium Green Tea',
      'date': '2026-09-01 11:15 AM',
    },
    {
      'productName': 'Whole Wheat Bread',
      'date': '2026-09-02 09:45 AM',
    },
  ];

  void _syncItem(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Synced successfully')),
    );
    setState(() {
      _mockInspections.removeAt(index);
    });
  }

  void _syncAll() {
    final count = _mockInspections.length;
    if (count == 0) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All $count items synced')),
    );
    setState(() {
      _mockInspections.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchTheme.background,
      appBar: AppBar(
        backgroundColor: StitchTheme.background,
        title: Text(
          'Offline Storage & Sync',
          style: StitchTheme.headlineMd.copyWith(
            color: StitchTheme.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _syncAll,
            child: const Text('Sync All', style: TextStyle(color: StitchTheme.secondary)),
          ),
        ],
      ),
      body: _mockInspections.isEmpty
          ? const Center(
              child: Text(
                'No pending inspections',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockInspections.length,
              itemBuilder: (context, index) {
                final inspection = _mockInspections[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      inspection['productName']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(inspection['date']!),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.sync, color: StitchTheme.secondary),
                      onPressed: () => _syncItem(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
