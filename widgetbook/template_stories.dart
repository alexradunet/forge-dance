import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

List<WidgetbookNode> buildTemplateStories() {
  return [
    WidgetbookComponent(
      name: 'SwipeableCardScreenTemplate',
      useCases: [
        WidgetbookUseCase(
          name: 'Training step',
          builder: (_) => const _SwipeableTemplateStory(),
        ),
      ],
    ),
  ];
}

class _SwipeableTemplateStory extends StatefulWidget {
  const _SwipeableTemplateStory();

  @override
  State<_SwipeableTemplateStory> createState() =>
      _SwipeableTemplateStoryState();
}

class _SwipeableTemplateStoryState extends State<_SwipeableTemplateStory> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return SwipeableCardScreenTemplate(
      title: 'Groove foundations',
      subtitle: 'Practice session',
      progressSteps: 4,
      currentStep: _currentStep,
      onStepClick: (step) => setState(() => _currentStep = step),
      onBack: () {},
      headerRight: const FgLevelBadge(level: 3),
      actionZone: FgButton(
        text: _currentStep == 3 ? 'Finish session' : 'Continue',
        expand: true,
        onPressed: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          }
        },
      ),
      children: FgCard(
        variant: FgCardVariant.elevated,
        padding: AppSpacing.allXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FgIcon(
              icon: Icons.music_note_rounded,
              size: 56,
              color: AppColors.forgeFire,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Find the downbeat',
              style: AppTypography.h2.copyWith(
                color: AppColors.crystalWhite,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Listen for the strongest pulse, then mark it with your bounce.',
              style: AppTypography.body.copyWith(color: AppColors.gray300),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
