import 'package:flutter/material.dart';
import '../theme/stitch_theme.dart';

class StitchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color titleColor;
  final bool centerTitle;

  const StitchAppBar({
    super.key,
    this.title = 'LM-GUARDIAN',
    this.showBackButton = false,
    this.actions,
    this.backgroundColor = StitchTheme.surface,
    this.titleColor = StitchTheme.primary,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      titleSpacing: showBackButton ? 0 : 24.0, // Match 1.5rem margin page roughly
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.chevron_left, color: titleColor, size: 28),
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 24,
            )
          : null,
      title: Text(
        title,
        style: StitchTheme.titleLg.copyWith(
          color: titleColor,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      actions: actions ?? [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: StitchTheme.onSurfaceVariant),
          onPressed: () {},
          splashRadius: 24,
        ),
        IconButton(
          icon: Icon(Icons.account_circle, color: StitchTheme.primary),
          onPressed: () {},
          splashRadius: 24,
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: StitchTheme.surfaceVariant.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
