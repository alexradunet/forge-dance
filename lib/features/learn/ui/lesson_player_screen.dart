import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/lesson.dart';
import '../repository/lesson_catalog.dart';
import '../ui/view_model/learn_view_model.dart';

/// Plays the user's current lesson step-by-step; the final step offers a
/// completion action that persists progress and unlocks the next lesson.
class LessonPlayerScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  final String lessonId;
  const LessonPlayerScreen({required this.lessonId, super.key, this.onBack});

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  int _currentStep = 0;
  bool _completing = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final learnState = ref.watch(learnViewModelProvider);
    final state = learnState.value;

    if (state == null) {
      return Scaffold(
        body: FgBackground(
          child: learnState.hasError
              ? FgEmpty(
                  icon: Icons.error_outline,
                  title: LocaleKeys.unexpectedErrorOccurred.tr(),
                  tone: FgEmptyTone.error,
                )
              : const Center(child: FgSpinner()),
        ),
      );
    }

    final lesson = state.activeModule.lessons.firstWhere(
      (lesson) => lesson.id == widget.lessonId,
      orElse: () => state.currentLesson ?? state.activeModule.lessons.last,
    );
    final steps = stepsFor(lesson);
    final lessonNumber = state.activeModule.lessons.indexOf(lesson) + 1;
    final isLastStep = _currentStep == steps.length - 1;

    return SwipeableCardScreenTemplate(
      title: lesson.title,
      subtitle: LocaleKeys.lessonNumberType.tr(
        args: ['$lessonNumber', lesson.type.label],
      ),
      onBack: widget.onBack ?? () => Navigator.of(context).pop(),
      progressSteps: steps.length,
      currentStep: _currentStep,
      useFullWidth: false,
      onStepClick: (index) {
        final motion = context.forgeMotion;
        _pageController.animateToPage(
          index,
          duration: motion.standard,
          curve: motion.enterCurve,
        );
      },
      actionZone: isLastStep
          ? FgButton(
              text: LocaleKeys.completeLesson.tr(),
              expand: true,
              isLoading: _completing,
              onPressed: () => _completeLesson(lesson),
            )
          : null,
      children: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentStep = index;
          });
        },
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: FgInteractiveCard(
                title: step.title,
                flipSemanticLabel: LocaleKeys.flipCard.tr(),
                subtitle: LocaleKeys.stepN
                    .tr(args: ['${index + 1}'])
                    .toUpperCase(),
                backgroundImage: 'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
                style: lesson.type.label,
                difficulty: lesson.difficulty,
                progress: (index + 1) / steps.length,
                backTitle: LocaleKeys.stepDetails.tr().toUpperCase(),
                backSubtitle: LocaleKeys.techniqueBreakdown.tr(),
                backContent: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (step.description.isNotEmpty)
                      Text(
                        step.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).forgeColors.onImmersiveMuted,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (step.focus.isNotEmpty)
                      _buildTechniquePoint(
                        LocaleKeys.focusLabel.tr(),
                        step.focus,
                      ),
                    if (step.breath.isNotEmpty)
                      _buildTechniquePoint(
                        LocaleKeys.breathLabel.tr(),
                        step.breath,
                      ),
                    if (step.energy.isNotEmpty)
                      _buildTechniquePoint(
                        LocaleKeys.energyLabel.tr(),
                        step.energy,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _completeLesson(Lesson lesson) async {
    if (_completing) return;
    setState(() => _completing = true);

    await ref.read(learnViewModelProvider.notifier).completeLesson(lesson.id);

    if (!mounted) return;
    setState(() => _completing = false);
    widget.onBack?.call();
  }

  Widget _buildTechniquePoint(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FgLabel(text: label, tone: FgLabelTone.accent),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).forgeColors.onImmersive),
          ),
        ],
      ),
    );
  }
}
