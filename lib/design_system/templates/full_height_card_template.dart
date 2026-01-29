import 'package:flutter/material.dart';

import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';

/// Full height card template - Safe area aware card layout
class FullHeightCardTemplate extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const FullHeightCardTemplate({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.gray950,
      body: SafeArea(
        child: Container(
          padding: padding ?? EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            safeAreaTop > 0 ? AppSpacing.lg : AppSpacing.xxl,
            AppSpacing.xxl,
            safeAreaBottom > 0 ? AppSpacing.lg : AppSpacing.xxl,
          ),
          child: child,
        ),
      ),
    );
  }
}
