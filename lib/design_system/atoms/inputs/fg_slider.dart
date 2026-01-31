import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_animation.dart';
import '../../tokens/app_typography.dart';

/// Slider control atom - Range input with glow thumb and gradient track
/// Based on HTML mockup: forge.dance_home_dashboard_9 (02. Range Sliders)
class FgSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String? label;
  final String? valueLabel;
  final bool showBpmStyle;
  final bool showTicks;
  final bool isEnabled;

  const FgSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.label,
    this.valueLabel,
    this.showBpmStyle = false,
    this.showTicks = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and value header
        if (label != null || valueLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (label != null)
                  Text(
                    label!.toUpperCase(),
                    style: AppTypography.overline.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (valueLabel != null)
                  Text(
                    valueLabel!,
                    style: showBpmStyle
                        ? AppTypography.h3.copyWith(
                            color: AppColors.forgeFire,
                            fontWeight: FontWeight.w700,
                          )
                        : AppTypography.bodySmall.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w700,
                          ),
                  ),
              ],
            ),
          ),

        // Slider track
        GestureDetector(
          onHorizontalDragUpdate: isEnabled
              ? (details) {
                  final box = context.findRenderObject() as RenderBox?;
                  if (box != null) {
                    final localPosition = details.localPosition;
                    final newPercentage =
                        (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                    final newValue = min + (max - min) * newPercentage;
                    onChanged?.call(newValue);
                  }
                }
              : null,
          onTapDown: isEnabled
              ? (details) {
                  final box = context.findRenderObject() as RenderBox?;
                  if (box != null) {
                    final newPercentage =
                        (details.localPosition.dx / box.size.width)
                            .clamp(0.0, 1.0);
                    final newValue = min + (max - min) * newPercentage;
                    onChanged?.call(newValue);
                  }
                }
              : null,
          child: SizedBox(
            height: 32,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Track background with optional ticks
                Container(
                  height: showBpmStyle ? 6 : 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgDeep,
                    borderRadius:
                        BorderRadius.circular(showBpmStyle ? 3 : 2),
                    border: showBpmStyle
                        ? Border.all(color: AppColors.borderSubtle, width: 1)
                        : null,
                  ),
                  child: showTicks
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            5,
                            (index) => Container(
                              width: 1,
                              color:
                                  AppColors.crystalWhite.withOpacity(0.1),
                            ),
                          ),
                        )
                      : null,
                ),

                // Active track with gradient
                AnimatedContainer(
                  duration: AppAnimation.fast,
                  curve: AppAnimation.easeOut,
                  height: showBpmStyle ? 6 : 4,
                  width: percentage *
                      (MediaQuery.of(context).size.width - 48), // Account for padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: showBpmStyle
                          ? [
                              AppColors.forgeFire.withOpacity(0.5),
                              AppColors.forgeFire,
                            ]
                          : [
                              AppColors.crystalWhite.withOpacity(0.4),
                              AppColors.crystalWhite.withOpacity(0.6),
                            ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      bottomLeft: Radius.circular(3),
                    ),
                  ),
                ),

                // Thumb
                AnimatedPositioned(
                  duration: AppAnimation.fast,
                  curve: AppAnimation.easeOut,
                  left: percentage *
                          (MediaQuery.of(context).size.width - 48 - 24) -
                      12, // Account for thumb size
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: showBpmStyle
                            ? AppColors.forgeFire
                            : AppColors.crystalWhite,
                        width: 2,
                      ),
                      boxShadow: showBpmStyle
                          ? [
                              BoxShadow(
                                color: AppColors.forgeFire.withOpacity(0.8),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: showBpmStyle
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.forgeFire,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Min/Max labels
        if (showTicks || showBpmStyle)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  min.toInt().toString(),
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  max.toInt().toString(),
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
