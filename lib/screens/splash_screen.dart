import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go(Constants.routeLogin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo
            Image.asset('assets/images/app_logo.png', width: 120, height: 120),
            const SizedBox(height: 24),
            Text(
              'LabelGuard',
              style: textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan. Check. Enforce.',
              style: textTheme.bodyMedium,
            ),
            const Spacer(),
            Text(
              'Powered by Legal Metrology',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
