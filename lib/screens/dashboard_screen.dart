import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../config/app_colors.dart';
import '../services/local_storage_service.dart';
import '../models/scan_result.dart';
import '../widgets/custom_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LocalStorageService _storage = LocalStorageService();
  List<ScanResult> _scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final scans = _storage.getAllScans();
      setState(() {
        _scans = scans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final totalScans = _scans.length;
    final compliant = _scans.where((s) => s.isCompliant).length;
    final nonCompliant = totalScans - compliant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspector Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Scans', totalScans.toString(), AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Compliant', compliant.toString(), AppColors.success),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Violations', nonCompliant.toString(), AppColors.danger),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Compliance Overview', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            CustomCard(
              child: SizedBox(
                height: 200,
                child: totalScans == 0
                    ? const Center(child: Text('No data to display'))
                    : PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                              color: AppColors.success,
                              value: compliant.toDouble(),
                              title: '$compliant',
                              radius: 50,
                              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            PieChartSectionData(
                              color: AppColors.danger,
                              value: nonCompliant.toDouble(),
                              title: '$nonCompliant',
                              radius: 50,
                              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ..._scans.take(5).map((scan) => _buildActivityItem(scan)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return CustomCard(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ScanResult scan) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scan.isCompliant ? AppColors.successLight : AppColors.dangerLight,
        child: Icon(
          scan.isCompliant ? Icons.check : Icons.warning,
          color: scan.isCompliant ? AppColors.success : AppColors.danger,
        ),
      ),
      title: Text(scan.productName.isNotEmpty ? scan.productName : 'Unknown Product'),
      subtitle: Text(scan.scanDate.toString().split('.')[0]),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
