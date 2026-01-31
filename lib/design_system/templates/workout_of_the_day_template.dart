import 'package:flutter/material.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/buttons/app_button.dart';
import 'package:flutter_mvvm_riverpod/design_system/organisms/navigation/app_header.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_spacing.dart';

/// Workout of the Day Template
/// Displays a featured workout content with a "Start Workout" call to action.
class WorkoutOfTheDayTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget content;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;
  final VoidCallback? onStartWorkout;
  final String startButtonText;

  const WorkoutOfTheDayTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.onBack,
    this.onMenu,
    this.onStartWorkout,
    this.startButtonText = 'Start Workout',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      extendBody: true,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(color: Colors.white.withOpacity(0.02)),
            ),
          ),

          Column(
            children: [
              SafeArea(
                bottom: false,
                child: AppHeader(
                  title: title,
                  subtitle: subtitle,
                  onBack: onBack,
                  rightSlot: onMenu != null
                      ? IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: onMenu,
                        )
                      : null,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Center(child: content),
                ),
              ),
              // Bottom Action Area
              if (onStartWorkout != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    MediaQuery.of(context).padding.bottom + AppSpacing.lg,
                  ),
                  child: AppButton(
                    text: startButtonText.toUpperCase(),
                    variant: AppButtonVariant.primary,
                    width: double.infinity,
                    onPressed: onStartWorkout,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
