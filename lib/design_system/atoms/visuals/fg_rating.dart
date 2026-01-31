import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

/// Star rating atom - Supports read-only display and interactive modification.
class FgRating extends StatelessWidget {
  final double value;
  final int itemCount;
  final double itemSize;
  final Color? color;
  final Color? unselectedColor;
  final ValueChanged<double>? onChanged;
  final MainAxisAlignment alignment;

  const FgRating({
    super.key,
    required this.value,
    this.itemCount = 5,
    this.itemSize = 24.0,
    this.color,
    this.unselectedColor,
    this.onChanged,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.legendGold;
    final effectiveUnselectedColor = unselectedColor ?? AppColors.gray700;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: List.generate(itemCount, (index) {
        final starValue = index + 1;
        IconData icon;
        Color iconColor;

        if (value >= starValue) {
          icon = Icons.star;
          iconColor = effectiveColor;
        } else if (value >= starValue - 0.5) {
          icon = Icons.star_half;
          iconColor = effectiveColor;
        } else {
          icon = Icons.star_border;
          iconColor = effectiveUnselectedColor;
        }

        return GestureDetector(
          onTap:
              onChanged != null ? () => onChanged!(starValue.toDouble()) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Icon(
              icon,
              size: itemSize,
              color: iconColor,
            ),
          ),
        );
      }),
    );
  }
}
