import 'package:flutter/material.dart';
import '../widgets/stitch_bottom_nav.dart';
import 'inspector_home_dashboard.dart';
import 'compliance_result_analysis.dart';
import 'product_scanner_interface.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const InspectorHomeDashboard(),
    const HistoryScreen(),
    const ComplianceResultAnalysis(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onScanTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductScannerInterface(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Needed for floating effect
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: StitchBottomNav(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              onScanTapped: _onScanTapped,
            ),
          ),
        ],
      ),
    );
  }
}
