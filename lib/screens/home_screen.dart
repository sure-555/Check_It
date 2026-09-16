import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final textTheme = Theme.of(context).textTheme;
    
    // Greeting based on role
    final greeting = auth.isInspector 
        ? 'Good afternoon, ${auth.inspectorName?.split(' ')[1] ?? 'Inspector'}'
        : 'Good afternoon, Citizen';
        
    final subtext = auth.isInspector
        ? 'You have 12 scans today'
        : 'Help us ensure safe products';

    return Scaffold(
      appBar: AppBar(
        title: Text(greeting, style: textTheme.titleLarge),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtext, style: textTheme.bodyMedium),
              const SizedBox(height: 48),
              
              // Big Scan Button
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go(Constants.routeScan);
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColorHeavy,
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Tap to scan label', style: textTheme.bodySmall),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Recent Activity Section
              Text('Recent Activity', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // Mock data
                    final isPass = index == 0;
                    return CustomCard(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isPass ? AppColors.success : AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          isPass ? 'Aashirvaad Atta 5kg' : 'Local Brand Chips',
                          style: textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          '${isPass ? "Compliant" : "3 Violations"} • ${index + 1}h ago',
                          style: textTheme.bodySmall,
                        ),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                        onTap: () {
                          // View details
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
