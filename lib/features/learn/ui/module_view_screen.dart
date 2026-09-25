import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/lesson_progress.dart';
import '../model/lesson.dart';
import '../ui/state/learn_state.dart';
import '../ui/view_model/learn_view_model.dart';

/// Module View Screen (Lesson Path) — renders the lesson catalog combined
/// with the dancer's locally persisted progress.
class ModuleViewScreen extends ConsumerWidget {
  final String? moduleId;
  final VoidCallback? onBack;
  final Function(String)? onLessonNavigate;

  const ModuleViewScreen({
    super.key,
    this.moduleId,
    this.onBack,
    this.onLessonNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);

    return FgImmersiveScaffold(
      title: LocaleKeys.exploreTitle.tr(),
      onBack: onBack,
      bodyBuilder: (context) => FgReadingBody(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, _) => FgEmpty(
            icon: Icons.error_outline,
            title: LocaleKeys.unexpectedErrorOccurred.tr(),
            tone: FgEmptyTone.error,
          ),
          data: (state) => _buildPath(
            context,
            ref,
            moduleId == null
                ? state
                : state.copyWith(activeModuleId: moduleId!),
          ),
        ),
      ),
    );
  }

  Widget _buildPath(BuildContext context, WidgetRef ref, LearnState state) {
    final current = state.currentLesson;
    final canContinue = current != null && state.canOpenLesson(current.id);
    final unmet = state.unmetPrerequisiteLessonIds(state.activeModule);
    final requirement = unmet.isEmpty ? null : state.lessonById(unmet.first);
    return ListView(
      padding: AppSpacing.allLG,
      children: [
        FgRoundPanel(
          label: LocaleKeys.lessonsCompletedOf.tr(
            args: [
              '${state.completedCountIn(state.activeModule)}',
              '${state.activeModule.lessons.length}',
            ],
          ),
          active: canContinue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FgSectionHeading(
                title: state.activeModule.title,
                subtitle: state.activeModule.subtitle,
              ),
              const SizedBox(height: AppSpacing.lg),
              FgProgressBar(value: state.moduleProgress),
              const SizedBox(height: AppSpacing.lg),
              if (!state.isModuleUnlocked(state.activeModule))
                Text(
                  LocaleKeys.requiresLesson.tr(
                    args: [requirement?.title ?? '—'],
                  ),
                )
              else if (current == null)
                Text(LocaleKeys.moduleComplete.tr())
              else ...[
                Text(
                  current.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                FgButton(
                  text: state.hasStartedModule(state.activeModule)
                      ? LocaleKeys.continueText.tr()
                      : LocaleKeys.startLesson.tr(),
                  expand: true,
                  onPressed: canContinue && onLessonNavigate != null
                      ? () {
                          ref
                              .read(learnViewModelProvider.notifier)
                              .startLesson(current.id);
                          onLessonNavigate?.call(current.id);
                        }
                      : null,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (state.isModuleUnlocked(state.activeModule))
          FgDetails(
            key: ValueKey('module-lessons-${state.activeModule.id}'),
            title: LocaleKeys.detailsAllLessons.tr(),
            initiallyExpanded: current == null,
            child: Column(
              children: [
                for (final (index, lesson)
                    in state.activeModule.lessons.indexed) ...[
                  FgRoundPanel(
                    label: LocaleKeys.lessonNumberType.tr(
                      args: ['${index + 1}', lesson.type.label],
                    ),
                    active: lesson.id == current?.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FgSectionHeading(title: lesson.title),
                        Text('${lesson.duration} · ${lesson.difficulty}'),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          state.statusOf(lesson) == LessonStatus.completed
                              ? LocaleKeys.statusCompleted.tr()
                              : state.canOpenLesson(lesson.id)
                              ? state.statusOf(lesson) ==
                                        LessonStatus.inProgress
                                    ? LocaleKeys.statusInProgress.tr()
                                    : LocaleKeys.lessonAvailable.tr()
                              : LocaleKeys.lockedLabel.tr(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        FgButton(
                          text: LocaleKeys.vocabularyViewLesson.tr(),
                          variant: FgButtonVariant.secondary,
                          onPressed:
                              state.canOpenLesson(lesson.id) &&
                                  onLessonNavigate != null
                              ? () {
                                  ref
                                      .read(learnViewModelProvider.notifier)
                                      .startLesson(lesson.id);
                                  onLessonNavigate?.call(lesson.id);
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
