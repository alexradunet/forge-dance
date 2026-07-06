import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_dance/design_system/molecules/cards/fg_interactive_card.dart';

import '../../../design_system/atoms/buttons/fg_button.dart';
import '../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../generated/locale_keys.g.dart';
import '../../common/ui/widgets/common_error.dart';
import '../model/lesson.dart';
import '../repository/lesson_catalog.dart';
import '../ui/view_model/learn_view_model.dart';

/// Plays the user's current lesson step-by-step; the final step offers a
/// completion action that persists progress and unlocks the next lesson.
class LessonPlayerScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const LessonPlayerScreen({super.key, this.onBack});

  @override
  ConsumerState<LessonPlayerScreen> createState() =>
      _LessonPlayerScreenState();
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
    final state = learnState.valueOrNull;

    if (state == null) {
      return Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: learnState.hasError
            ? const CommonError()
            : const Center(child: FgSpinner()),
      );
    }

    final lesson = state.currentLesson ?? state.activeModule.lessons.last;
    final steps = stepsFor(lesson);
    final lessonNumber = state.activeModule.lessons.indexOf(lesson) + 1;
    final isLastStep = _currentStep == steps.length - 1;

    return SwipeableCardScreenTemplate(
      title: lesson.title,
      subtitle: 'Lesson $lessonNumber • ${lesson.type.label}',
      onBack: widget.onBack ?? () => Navigator.of(context).pop(),
      progressSteps: steps.length,
      currentStep: _currentStep,
      useFullWidth: false,
      onStepClick: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
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
                subtitle:
                    LocaleKeys.stepN.tr(args: ['${index + 1}']).toUpperCase(),
                backgroundImage:
                    'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
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
                        style: AppTypography.bodySmall
                            .copyWith(color: Colors.white70),
                      ),
                    const SizedBox(height: 24),
                    if (step.focus.isNotEmpty)
                      _buildTechniquePoint(
                          LocaleKeys.focusLabel.tr(), step.focus),
                    if (step.breath.isNotEmpty)
                      _buildTechniquePoint(
                          LocaleKeys.breathLabel.tr(), step.breath),
                    if (step.energy.isNotEmpty)
                      _buildTechniquePoint(
                          LocaleKeys.energyLabel.tr(), step.energy),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.label.copyWith(
              color: AppColors.forgeFire,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
