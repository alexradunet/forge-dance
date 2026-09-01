import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

enum FgLogoVariant { full, iconOnly, textOnly }

enum FgLogoColor { brand, white, black }

/// Canonical Forge Dance brand mark and wordmark.
class FgLogo extends StatelessWidget {
  const FgLogo({
    super.key,
    this.size = 32,
    this.variant = FgLogoVariant.iconOnly,
    this.color = FgLogoColor.brand,
  });

  final double size;
  final FgLogoVariant variant;
  final FgLogoColor color;

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);
    final mark = _ForgeMark(size: size, color: colors.mark);
    final wordmark = _ForgeWordmark(
      fontSize: size * 0.72,
      primaryColor: colors.wordmark,
      accentColor: colors.accent,
    );

    final logo = switch (variant) {
      FgLogoVariant.iconOnly => mark,
      FgLogoVariant.textOnly => wordmark,
      FgLogoVariant.full => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mark,
          const SizedBox(width: AppSpacing.sm),
          wordmark,
        ],
      ),
    };

    return Semantics(
      image: true,
      label: 'Forge Dance',
      child: ExcludeSemantics(child: logo),
    );
  }

  _LogoColors _resolveColors(BuildContext context) {
    return switch (color) {
      FgLogoColor.brand => _LogoColors(
        mark: AppColors.forgeFire,
        wordmark: context.forgeForeground,
        accent: AppColors.forgeFire,
      ),
      FgLogoColor.white => const _LogoColors(
        mark: AppColors.crystalWhite,
        wordmark: AppColors.crystalWhite,
        accent: AppColors.crystalWhite,
      ),
      FgLogoColor.black => const _LogoColors(
        mark: AppColors.gray950,
        wordmark: AppColors.gray950,
        accent: AppColors.gray950,
      ),
    };
  }
}

class _ForgeMark extends StatelessWidget {
  const _ForgeMark({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _ForgeMarkPainter(color)),
    );
  }
}

class _ForgeWordmark extends StatelessWidget {
  const _ForgeWordmark({
    required this.fontSize,
    required this.primaryColor,
    required this.accentColor,
  });

  final double fontSize;
  final Color primaryColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.h2.copyWith(
      fontSize: fontSize,
      height: 1,
      letterSpacing: fontSize * 0.06,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'FORGE',
            style: style.copyWith(color: primaryColor),
          ),
          TextSpan(
            text: '.DANCE',
            style: style.copyWith(color: accentColor),
          ),
        ],
      ),
      maxLines: 1,
    );
  }
}

class _ForgeMarkPainter extends CustomPainter {
  const _ForgeMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final primary = Paint()..color = color;
    final secondary = Paint()..color = color.withAlpha(92);

    final bolt = Path()
      ..moveTo(width * 0.18, height * 0.08)
      ..lineTo(width * 0.76, height * 0.08)
      ..lineTo(width * 0.53, height * 0.42)
      ..lineTo(width * 0.82, height * 0.42)
      ..lineTo(width * 0.24, height * 0.94)
      ..lineTo(width * 0.39, height * 0.57)
      ..lineTo(width * 0.14, height * 0.57)
      ..close();
    canvas.drawPath(bolt, primary);

    final spark = Path()
      ..moveTo(width * 0.7, height * 0.66)
      ..lineTo(width * 0.9, height * 0.55)
      ..lineTo(width * 0.82, height * 0.81)
      ..close();
    canvas.drawPath(spark, secondary);
  }

  @override
  bool shouldRepaint(covariant _ForgeMarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _LogoColors {
  const _LogoColors({
    required this.mark,
    required this.wordmark,
    required this.accent,
  });

  final Color mark;
  final Color wordmark;
  final Color accent;
}
