import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

enum FgLogoVariant {
  full, // Icon + Text
  iconOnly, // Just the flame/hammer icon
  textOnly, // Just the wordmark
}

enum FgLogoColor {
  brand, // Orange/White or standard colors
  white, // Pure white (for dark backgrounds)
  black, // Pure black (for light backgrounds)
}

/// Standardized Forge app logo.
///
/// Uses standard SVG assets or Icon equivalents.
class FgLogo extends StatelessWidget {
  final double size;
  final FgLogoVariant variant;
  final FgLogoColor color;

  const FgLogo({
    super.key,
    this.size = 32,
    this.variant = FgLogoVariant.iconOnly,
    this.color = FgLogoColor.brand,
  });

  @override
  Widget build(BuildContext context) {
    // In a real implementation, this would use SvgPicture.asset(Assets.logo...)
    // For now, we simulate the logo using Icons and Text as placeholders
    // to avoid dependency errors if assets aren't set up.

    switch (variant) {
      case FgLogoVariant.iconOnly:
        return Icon(
          Icons.local_fire_department,
          size: size,
          color: _getColor(),
        );
      case FgLogoVariant.textOnly:
        return Text(
          'FORGE',
          style: TextStyle(
            fontFamily: 'Oswald', // Assuming standard font
            fontWeight: FontWeight.bold,
            fontSize: size,
            color: _getColor(),
            letterSpacing: size * 0.1,
          ),
        );
      case FgLogoVariant.full:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department,
              size: size,
              color: _getColor(),
            ),
            SizedBox(width: size * 0.25),
            Text(
              'FORGE',
              style: TextStyle(
                fontFamily: 'Oswald',
                fontWeight: FontWeight.bold,
                fontSize: size * 0.8,
                color: _getColor(),
                letterSpacing: size * 0.1,
              ),
            ),
          ],
        );
    }
  }

  Color _getColor() {
    switch (color) {
      case FgLogoColor.brand:
        return AppColors.forgeFire;
      case FgLogoColor.white:
        return Colors.white;
      case FgLogoColor.black:
        return Colors.black;
    }
  }
}
