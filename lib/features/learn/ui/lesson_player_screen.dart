import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _techniqueExpanded = false;
  final _contentScrollController = ScrollController();

  @override
  void dispose() {
    _contentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final learnState = ref.watch(learnViewModelProvider);
    final state = learnState.value;
    if (state == null || learnState.hasError) {
      return PopScope(
        canPop: !_completing,
        child: FgImmersiveScaffold(
          title: LocaleKeys.exploreTitle.tr(),
          onBack: () {
            if (!_completing) _back();
          },
          bodyBuilder: (context) => FgReadingBody(
            child: learnState.hasError
                ? SingleChildScrollView(
                    child: FgEmpty(
                      icon: Icons.error_outline,
                      title: LocaleKeys.unexpectedErrorOccurred.tr(),
                      tone: FgEmptyTone.error,
                      actionLabel: LocaleKeys.methodRetry.tr(),
                      onAction: () => ref.invalidate(learnViewModelProvider),
                    ),
                  )
                : const Center(child: FgSpinner()),
          ),
        ),
      );
    }
    final lesson = state.lessonById(widget.lessonId);
    if (lesson == null) {
      return FgImmersiveScaffold(
        title: LocaleKeys.exploreTitle.tr(),
        onBack: _back,
        bodyBuilder: (context) => SingleChildScrollView(
          child: FgEmpty(
            icon: Icons.error_outline,
            title: LocaleKeys.unexpectedErrorOccurred.tr(),
          ),
        ),
      );
    }
    if (!state.canOpenLesson(widget.lessonId)) {
      return FgImmersiveScaffold(
        title: LocaleKeys.exploreTitle.tr(),
        onBack: _back,
        bodyBuilder: (context) => SingleChildScrollView(
          child: FgEmpty(
            icon: Icons.lock_outline,
            title: LocaleKeys.lockedLabel.tr(),
          ),
        ),
      );
    }
    final steps = stepsFor(lesson);
    final isLastStep = _currentStep == steps.length - 1;
    return PopScope(
      canPop: !_completing,
      child: FgImmersiveScaffold(
        bodyBuilder: (context) => FgReadingBody(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    key: const ValueKey('lesson-content-scroll'),
                    controller: _contentScrollController,
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppHeader(
                          title: lesson.title,
                          onBack: () {
                            if (!_completing) _back();
                          },
                        ),
                        Text(
                          LocaleKeys.lessonWrittenCues.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _LessonStepContent(
                          key: ValueKey(_currentStep),
                          step: steps[_currentStep],
                          techniqueExpanded: _techniqueExpanded,
                          onTechniqueChanged: (expanded) =>
                              setState(() => _techniqueExpanded = expanded),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _NavigationControls(
                    currentStep: _currentStep,
                    stepCount: steps.length,
                    isLastStep: isLastStep,
                    completing: _completing,
                    onPrevious: _currentStep == 0 || _completing
                        ? null
                        : () => _goToStep(_currentStep - 1),
                    onNext: _completing
                        ? null
                        : isLastStep
                        ? () => _completeLesson(lesson)
                        : () => _goToStep(_currentStep + 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _back() => (widget.onBack ?? () => Navigator.of(context).maybePop())();

  void _goToStep(int index) {
    if (_completing) return;
    if (_contentScrollController.hasClients) _contentScrollController.jumpTo(0);
    setState(() {
      _currentStep = index;
      _techniqueExpanded = false;
    });
  }

  Future<void> _completeLesson(Lesson lesson) async {
    if (_completing) return;
    setState(() => _completing = true);
    await ref.read(learnViewModelProvider.notifier).completeLesson(lesson.id);
    if (!mounted) return;
    setState(() => _completing = false);
    if (!ref.read(learnViewModelProvider).hasError) _back();
  }
}

class _LessonStepContent extends StatelessWidget {
  const _LessonStepContent({
    super.key,
    required this.step,
    required this.techniqueExpanded,
    required this.onTechniqueChanged,
  });

  final LessonStep step;
  final bool techniqueExpanded;
  final ValueChanged<bool> onTechniqueChanged;

  @override
  Widget build(BuildContext context) {
    return FgRoundPanel(
      label: LocaleKeys.practiceCue.tr(),
      active: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FgSectionHeading(title: step.title),
          const SizedBox(height: AppSpacing.md),
          Text(
            step.description.isEmpty
                ? LocaleKeys.lessonSummaryFallback.tr()
                : step.description,
          ),

          Semantics(
            expanded: techniqueExpanded,
            child: ExpansionTile(
              key: PageStorageKey('technique-${step.title}'),
              initiallyExpanded: techniqueExpanded,
              onExpansionChanged: onTechniqueChanged,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: AppSpacing.lg),
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              shape: const Border(),
              collapsedShape: const Border(),
              iconColor: context.forgeMutedForeground,
              collapsedIconColor: context.forgeMutedForeground,
              title: Text(
                LocaleKeys.techniqueDetails.tr(),
                style: TextStyle(color: context.forgeForeground),
              ),
              subtitle: Text(
                LocaleKeys.techniqueDetailsHint.tr(),
                style: TextStyle(color: context.forgeMutedForeground),
              ),
              children: [
                if (step.focus.isNotEmpty)
                  FgCoachingCue(
                    icon: Icons.center_focus_strong_rounded,
                    label: LocaleKeys.focusLabel.tr(),
                    value: step.focus,
                  ),
                if (step.breath.isNotEmpty)
                  FgCoachingCue(
                    icon: Icons.air_rounded,
                    label: LocaleKeys.breathLabel.tr(),
                    value: step.breath,
                  ),
                if (step.energy.isNotEmpty)
                  FgCoachingCue(
                    icon: Icons.bolt_rounded,
                    label: LocaleKeys.energyLabel.tr(),
                    value: step.energy,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationControls extends StatelessWidget {
  const _NavigationControls({
    required this.currentStep,
    required this.stepCount,
    required this.isLastStep,
    required this.completing,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentStep;
  final int stepCount;
  final bool isLastStep;
  final bool completing;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final stepLabel = LocaleKeys.lessonStepOf.tr(
      args: ['${currentStep + 1}', '$stepCount'],
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _PreviousStepIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _NextStepIntent(),
      },
      child: Actions(
        actions: {
          _PreviousStepIntent: CallbackAction<_PreviousStepIntent>(
            onInvoke: (_) {
              onPrevious?.call();
              return null;
            },
          ),
          _NextStepIntent: CallbackAction<_NextStepIntent>(
            onInvoke: (_) {
              onNext?.call();
              return null;
            },
          ),
        },
        child: FgStepNavigation(
          currentStep: currentStep,
          stepCount: stepCount,
          stepLabel: stepLabel,
          nextLabel:
              (isLastStep ? LocaleKeys.completeLesson : LocaleKeys.nextStep)
                  .tr(),
          previousSemanticLabel: LocaleKeys.previousStepSemantic.tr(
            args: ['${currentStep + 1}', '$stepCount'],
          ),
          nextSemanticLabel: isLastStep
              ? LocaleKeys.completeLesson.tr()
              : LocaleKeys.nextStepSemantic.tr(
                  args: ['${currentStep + 1}', '$stepCount'],
                ),
          onPrevious: onPrevious,
          onNext: onNext,
          nextLoading: completing,
        ),
      ),
    );
  }
}

class _PreviousStepIntent extends Intent {
  const _PreviousStepIntent();
}

class _NextStepIntent extends Intent {
  const _NextStepIntent();
}
