import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Pure branding shown while auth state resolves. Navigation remains owned by
/// the router redirect in `lib/routing/app_redirect.dart`.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final motion = context.forgeMotion;

    return Scaffold(
      body: FgBackground(
        showGrid: false,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: AppSizes.iconLg,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const FgLogo(
                    size: AppSizes.avatarXl,
                    variant: FgLogoVariant.full,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'THE STAGE IS YOURS.',
                    style: AppTypography.overline.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: AppSpacing.xxxl,
              left: AppSpacing.xxl,
              right: AppSpacing.xxl,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.squareTileMd,
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 0.33),
                    duration: motion.slow,
                    curve: motion.enterCurve,
                    builder: (context, value, _) => FgProgressBar(
                      value: value,
                      size: FgProgressBarSize.sm,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
