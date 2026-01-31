import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppAnimation,
  path: 'Design System/Tokens',
)
Widget buildAnimationPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: context.knobs.list(
          label: 'Duration',
          options: [
            AppAnimation.instant,
            AppAnimation.fast,
            AppAnimation.standard,
            AppAnimation.slow,
            AppAnimation.slower,
            AppAnimation.slowest,
          ],
          labelBuilder: (value) => '${value.inMilliseconds}ms',
          initialOption: AppAnimation.standard,
        ),
        curve: context.knobs.list(
          label: 'Curve',
          options: [
            AppAnimation.defaultCurve,
            AppAnimation.easeOut,
            AppAnimation.easeIn,
            AppAnimation.easeOutCubic,
            AppAnimation.easeInOutCubic,
            AppAnimation.spring,
            AppAnimation.bounce,
            AppAnimation.sharp,
          ],
          labelBuilder: (value) => value.runtimeType.toString(),
          initialOption: AppAnimation.defaultCurve,
        ),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - value)), // Slide up
            child: Opacity(
              opacity: value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.forgeFire,
                  borderRadius: AppBorderRadius.medium,
                  boxShadow: [AppShadows.shadowLg],
                ),
              ),
            ),
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Just to trigger a rebuild for animation
        (context as Element).markNeedsBuild();
      },
      child: const Icon(Icons.refresh),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppAnimation,
  path: 'Design System/Tokens',
)
Widget buildAnimationShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _AnimationRow(name: 'Instant (50ms)', duration: AppAnimation.instant),
        _AnimationRow(name: 'Fast (150ms)', duration: AppAnimation.fast),
        _AnimationRow(
            name: 'Standard (300ms)', duration: AppAnimation.standard),
        _AnimationRow(name: 'Slow (500ms)', duration: AppAnimation.slow),
        _AnimationRow(name: 'Slower (700ms)', duration: AppAnimation.slower),
        _AnimationRow(name: 'Slowest (1000ms)', duration: AppAnimation.slowest),
      ],
    ),
  );
}

class _AnimationRow extends StatefulWidget {
  final String name;
  final Duration duration;

  const _AnimationRow({required this.name, required this.duration});

  @override
  State<_AnimationRow> createState() => _AnimationRowState();
}

class _AnimationRowState extends State<_AnimationRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: AppBorderRadius.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textMain)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedContainer(
                  duration: widget.duration,
                  curve: AppAnimation.easeInOutCubic,
                  width: _expanded ? constraints.maxWidth : 50,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue,
                    borderRadius: AppBorderRadius.small,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
