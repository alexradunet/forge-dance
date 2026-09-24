import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';

/// Honest readiness state; only the local-profile router decides when to leave.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => FgImmersiveScaffold(
    bodyBuilder: (context) => FgReadingBody(
      child: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.allXXL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: FgLogo(
                  size: AppSizes.avatarXl,
                  variant: FgLogoVariant.full,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              FgSectionHeading(title: LocaleKeys.personalOnboardingTitle.tr()),
              const SizedBox(height: AppSpacing.xxl),
              const FgDivider(),
              const SizedBox(height: AppSpacing.lg),
              Semantics(
                liveRegion: true,
                child: Text(LocaleKeys.personalOpening.tr()),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
