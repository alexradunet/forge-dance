import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_animation.dart';

/// Stepper control atom - Increment/decrement for numeric values
/// Based on HTML mockup: forge.dance_home_dashboard patterns
class FgStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int>? onChanged;
  final String? label;
  final String? unit;
  final bool isEnabled;
  final bool showBounds;

  const FgStepper({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.onChanged,
    this.label,
    this.unit,
    this.isEnabled = true,
    this.showBounds = false,
  });

  void _increment() {
    if (value + step <= max && isEnabled) {
      onChanged?.call(value + step);
    }
  }

  void _decrement() {
    if (value - step >= min && isEnabled) {
      onChanged?.call(value - step);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canIncrement = value + step <= max && isEnabled;
    final canDecrement = value - step >= min && isEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              label!.toUpperCase(),
              style: AppTypography.overline.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

        // Stepper row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrement button
            _StepperButton(
              icon: Icons.remove,
              onPressed: canDecrement ? _decrement : null,
              isEnabled: canDecrement,
            ),

            // Value display
            Container(
              constraints: const BoxConstraints(minWidth: 80),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value${unit != null ? ' $unit' : ''}',
                    style: AppTypography.h3.copyWith(
                      color: isEnabled
                          ? AppColors.crystalWhite
                          : AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (showBounds)
                    Text(
                      '$min - $max',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),

            // Increment button
            _StepperButton(
              icon: Icons.add,
              onPressed: canIncrement ? _increment : null,
              isEnabled: canIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepperButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const _StepperButton({
    required this.icon,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  State<_StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<_StepperButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp:
          widget.isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel:
          widget.isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        curve: AppAnimation.easeOut,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: widget.isEnabled
              ? _isPressed
                  ? AppColors.forgeFire.withAlpha((0.2 * 255).round())
                  : AppColors.surfaceDark
              : AppColors.surfaceDark.withAlpha((0.5 * 255).round()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isEnabled
                ? _isPressed
                    ? AppColors.forgeFire
                    : AppColors.borderSubtle
                : AppColors.borderSubtle.withAlpha((0.5 * 255).round()),
            width: 1,
          ),
          boxShadow: _isPressed && widget.isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.forgeFire.withAlpha((0.3 * 255).round()),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.isEnabled
                ? _isPressed
                    ? AppColors.forgeFire
                    : AppColors.crystalWhite
                : AppColors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Horizontal stepper with compact inline design
class InlineFgStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int>? onChanged;
  final String? label;
  final bool isEnabled;

  const InlineFgStepper({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.onChanged,
    this.label,
    this.isEnabled = true,
  });

  void _increment() {
    if (value + step <= max && isEnabled) {
      onChanged?.call(value + step);
    }
  }

  void _decrement() {
    if (value - step >= min && isEnabled) {
      onChanged?.call(value - step);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canIncrement = value + step <= max && isEnabled;
    final canDecrement = value - step >= min && isEnabled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _InlineButton(
            icon: Icons.remove,
            onPressed: canDecrement ? _decrement : null,
          ),

          // Value
          Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.crystalWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Increment button
          _InlineButton(
            icon: Icons.add,
            onPressed: canIncrement ? _increment : null,
          ),
        ],
      ),
    );
  }
}

class _InlineButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _InlineButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.crystalWhite.withAlpha((0.05 * 255).round())
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isEnabled ? AppColors.crystalWhite : AppColors.neutral600,
            size: 16,
          ),
        ),
      ),
    );
  }
}
