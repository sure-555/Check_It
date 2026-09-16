import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';
import 'package:label_guard/l10n/app_localizations.dart';

class StitchBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onScanTapped;

  const StitchBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onScanTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: StitchTheme.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: AppLocalizations.of(context)!.navHome,
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.history_outlined,
              activeIcon: Icons.history,
              label: AppLocalizations.of(context)!.navHistory,
              index: 1,
            ),
            _buildFab(),
            _buildNavItem(
              icon: Icons.assessment_outlined,
              activeIcon: Icons.assessment,
              label: AppLocalizations.of(context)!.navReports,
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: AppLocalizations.of(context)!.navProfile,
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected 
                      ? Colors.white 
                      : const Color(0xFFA8A29E),
                  size: 24,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StitchTheme.labelMd.copyWith( 
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: StitchTheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Transform.translate(
      offset: const Offset(0, -8),
      child: GestureDetector(
        onTap: onScanTapped,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: StitchTheme.secondary.withValues(alpha: 0.2), width: 2),
            boxShadow: [
              BoxShadow(
                color: StitchTheme.secondary.withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.qr_code_scanner,
              color: StitchTheme.primary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
