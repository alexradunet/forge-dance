import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

/// Branded welcome moment shared by the authentication screens.
class AuthBrandHero extends StatelessWidget {
  const AuthBrandHero({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: message,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.huge,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard.withValues(alpha: 0.72),
          borderRadius: AppBorderRadius.xxLarge,
          border: Border.all(
            color: AppColors.forgeFire.withValues(alpha: 0.32),
          ),
          boxShadow: const [AppShadows.glowPrimary, AppShadows.shadowCard],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FgLogo(size: AppSizes.iconHuge, variant: FgLogoVariant.full),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.electricBlue)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    message.toUpperCase(),
                    style: AppTypography.overline.copyWith(
                      color: AppColors.textMain,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.forgeFire)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
