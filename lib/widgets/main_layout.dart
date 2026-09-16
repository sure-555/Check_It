import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/constants.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(Constants.routeHistory)) return 1;
    if (location.startsWith(Constants.routeDashboard)) return 2;
    if (location.startsWith(Constants.routeProfile)) return 3;
    return 0; // Default to Home (Scan)
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(Constants.routeHome);
        break;
      case 1:
        context.go(Constants.routeHistory);
        break;
      case 2:
        context.go(Constants.routeDashboard);
        break;
      case 3:
        context.go(Constants.routeProfile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
