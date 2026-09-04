import 'package:flutter/material.dart';

import '../../atoms/buttons/fg_button.dart';
import '../../atoms/progress/fg_progress_bar.dart';
import '../../tokens/app_spacing.dart';

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
  });

  final int currentStep;
  final int stepCount;
  final String stepLabel;
  final String previousSemanticLabel;
  final String nextSemanticLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool nextLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FgButton(
          icon: const Icon(Icons.arrow_back_rounded),
          variant: FgButtonVariant.primary,
          shape: FgButtonShape.circle,
          onPressed: onPrevious,
          semanticLabel: previousSemanticLabel,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: FgProgressBar.segmented(
            total: stepCount,
            current: currentStep,
            size: FgProgressBarSize.sm,
            semanticLabel: stepLabel,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        FgButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          variant: FgButtonVariant.primary,
          shape: FgButtonShape.circle,
          isLoading: nextLoading,
          onPressed: onNext,
          semanticLabel: nextSemanticLabel,
        ),
      ],
    );
  }
}
