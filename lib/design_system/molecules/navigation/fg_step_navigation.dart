import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_button.dart';
import '../../atoms/progress/fg_progress_bar.dart';
import '../../tokens/app_spacing.dart';
import '../../theme/forge_theme_extensions.dart';

/// Previous/next navigation arranged around a compact progress readout.
class FgStepNavigation extends StatelessWidget {
  const FgStepNavigation({
    required this.currentStep,
    required this.stepCount,
    required this.stepLabel,
    required this.previousSemanticLabel,
    required this.nextSemanticLabel,
    required this.onPrevious,
    required this.onNext,
    super.key,
    this.nextLoading = false,
    this.nextLabel,
  });

  final int currentStep;
  final int stepCount;
  final String stepLabel;
  final String previousSemanticLabel;
  final String nextSemanticLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool nextLoading;
  final String? nextLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Text(
            stepLabel,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: context.forgeMutedForeground),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FgProgressBar.segmented(
          total: stepCount,
          current: currentStep,
          size: FgProgressBarSize.sm,
          semanticLabel: stepLabel,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            FgButton(
              icon: const Icon(Icons.arrow_back_rounded),
              variant: FgButtonVariant.secondary,
              shape: FgButtonShape.circle,
              onPressed: onPrevious,
              semanticLabel: previousSemanticLabel,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: FgButton(
                text: nextLabel ?? nextSemanticLabel,
                icon: const Icon(Icons.arrow_forward_rounded),
                variant: FgButtonVariant.primary,
                isLoading: nextLoading,
                onPressed: onNext,
                semanticLabel: nextSemanticLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
