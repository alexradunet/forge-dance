import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../learn/ui/view_model/learn_view_model.dart';
import '../../media/ui/evidence_picker.dart';
import '../../method/model/forge_method.dart';
import '../../method/repository/method_catalog.dart';
import '../../method/ui/method_page.dart';
import '../../method/ui/method_view_model.dart';
import '../../practice/model/practice.dart';
import '../../practice/ui/practice_log_page.dart';
import '../../practice/ui/practice_view_model.dart';
import '../../practice_player/ui/practice_player_page.dart';
import '../model/vocabulary_entry.dart';
import '../model/vocabulary_learning.dart';
import '../repository/vocabulary_repository.dart';
import 'vocabulary_page.dart';

class VocabularyEntryPage extends ConsumerStatefulWidget {
  const VocabularyEntryPage({
    super.key,
    required this.entry,
    required this.onBack,
  });
  final VocabularyEntry entry;
  final VoidCallback onBack;

  @override
  ConsumerState<VocabularyEntryPage> createState() =>
      _VocabularyEntryPageState();
}

class _VocabularyEntryPageState extends ConsumerState<VocabularyEntryPage> {
  Future<void> _practice({required bool harder}) async {
    final entry = widget.entry;
    if (!(ref
            .read(learnViewModelProvider)
            .value
            ?.canOpenLesson(entry.lessonId) ??
        false)) {
      return;
    }
    final block = const VocabularyRepository().practiceFor(
      entry,
      harder: harder,
    );
    final record = await Navigator.of(context, rootNavigator: true)
        .push<PracticeRecord>(
          MaterialPageRoute(builder: (_) => PracticePlayerPage(block: block)),
        );
    if (record == null || !mounted) return;
    await _savePractice(record);
  }

  Future<void> _savePractice(PracticeRecord record) async {
    try {
      if (ref.read(practiceViewModelProvider).isLoading) {
        await ref.read(practiceViewModelProvider.future);
      }
      await ref.read(practiceViewModelProvider.notifier).record(record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.programmesPracticeSaved.tr())),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.programmesSaveError.tr()),
            action: SnackBarAction(
              label: LocaleKeys.programmesRetry.tr(),
              onPressed: () => _savePractice(record),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final learning = ref.watch(learnViewModelProvider);
    final method = ref.watch(methodViewModelProvider);
    final practice = ref.watch(practiceViewModelProvider);
    final learn = learning.value;
    final canOpenLesson = learn?.canOpenLesson(entry.lessonId) ?? false;
    final assessment = forgeAssessments.firstWhere(
      (item) => item.category == entry.category && item.level == 1,
    );
    final status =
        learn != null && method.value != null && practice.value != null
        ? VocabularyLearning(
            entry: entry,
            lessons: learn.progress,
            method: method.value!,
            practice: practice.value!,
          )
        : null;
    return FgImmersiveScaffold(
      bodyBuilder: (context) {
        final theme = Theme.of(context);
        return ListView(
          children: [
            AppHeader(
              title: entry.name,
              subtitle: '${vocabularyKindLabel(entry.kind)} • ${entry.style}',
              onBack: widget.onBack,
            ),
            Padding(
              padding: AppSpacing.screen,
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.forgeColors.onImmersive,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      entry.definition,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    if (entry.aliases.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        LocaleKeys.vocabularyAlsoKnown.tr(
                          args: [entry.aliases.join(', ')],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    _section(
                      context,
                      LocaleKeys.vocabularyContext.tr(),
                      entry.context,
                    ),
                    _section(context, LocaleKeys.vocabularyCue.tr(), entry.cue),
                    _section(
                      context,
                      LocaleKeys.vocabularyMistake.tr(),
                      entry.commonMistake,
                    ),
                    _section(
                      context,
                      LocaleKeys.vocabularyPractice.tr(),
                      entry.practice,
                    ),
                    _section(
                      context,
                      LocaleKeys.vocabularyEasier.tr(),
                      entry.easierPractice,
                    ),
                    _section(
                      context,
                      LocaleKeys.vocabularyHarder.tr(),
                      entry.harderPractice,
                    ),
                    Text(LocaleKeys.vocabularyComfort.tr()),
                    const SizedBox(height: AppSpacing.lg),
                    FgButton(
                      text: canOpenLesson
                          ? LocaleKeys.vocabularyViewLesson.tr()
                          : LocaleKeys.vocabularyViewPath.tr(),
                      onPressed: () {
                        if (canOpenLesson) {
                          LessonDestination(
                            entry.moduleId,
                            entry.lessonId,
                          ).push<void>(context);
                        } else {
                          ModuleDestination(entry.moduleId).push<void>(context);
                        }
                      },
                    ),
                    if (!canOpenLesson)
                      Text(LocaleKeys.vocabularyPathHint.tr()),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      LocaleKeys.programmesPrerequisites.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    if (const VocabularyRepository()
                        .prerequisitesFor(entry)
                        .isEmpty)
                      Text(LocaleKeys.programmesNoPrerequisites.tr()),
                    for (final lesson
                        in const VocabularyRepository().prerequisitesFor(entry))
                      FgButton(
                        text: lesson.title,
                        variant: FgButtonVariant.secondary,
                        isEnabled: learn != null,
                        onPressed: () {
                          if (learn == null) return;
                          final module = learn.modules.firstWhere(
                            (module) => module.lessons.any(
                              (item) => item.id == lesson.id,
                            ),
                          );
                          if (learn.canOpenLesson(lesson.id)) {
                            LessonDestination(
                              module.id,
                              lesson.id,
                            ).push<void>(context);
                          } else {
                            ModuleDestination(module.id).push<void>(context);
                          }
                        },
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    FgButton(
                      text: LocaleKeys.vocabularyStartEasier.tr(),
                      isEnabled: canOpenLesson,
                      onPressed: () => _practice(harder: false),
                    ),
                    FgButton(
                      text: LocaleKeys.vocabularyStartHarder.tr(),
                      variant: FgButtonVariant.secondary,
                      isEnabled: canOpenLesson,
                      onPressed: () => _practice(harder: true),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      LocaleKeys.vocabularyLearningEvidence.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    Text(LocaleKeys.programmesCompletionNotMastery.tr()),
                    if (learning.isLoading ||
                        method.isLoading ||
                        practice.isLoading)
                      const Center(child: FgSpinner()),
                    if (learning.hasError ||
                        method.hasError ||
                        practice.hasError)
                      FgButton(
                        text: LocaleKeys.programmesRetry.tr(),
                        onPressed: () {
                          ref.invalidate(learnViewModelProvider);
                          ref.invalidate(methodViewModelProvider);
                          ref.invalidate(practiceViewModelProvider);
                        },
                      ),
                    if (status != null) ...[
                      Text(
                        status.studied
                            ? LocaleKeys.programmesStudied.tr()
                            : LocaleKeys.programmesNotStudied.tr(),
                      ),
                      Text(
                        status.categoryLevel > 0
                            ? LocaleKeys.vocabularyCategoryDemonstrated.tr(
                                args: [
                                  entry.category.label,
                                  '${status.categoryLevel}',
                                ],
                              )
                            : LocaleKeys.vocabularyCategoryNotDemonstrated.tr(
                                args: [entry.category.label],
                              ),
                      ),
                      Text(LocaleKeys.vocabularyCategoryEvidenceHint.tr()),
                      for (final attempt in status.categoryAttempts.take(
                        3,
                      )) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '${DateFormat.yMMMd().add_Hm().format(attempt.performedAt.toLocal())} • ${attempt.assessment.title}',
                        ),
                        Text(
                          attempt.passed
                              ? LocaleKeys.vocabularyCriteriaMet.tr()
                              : LocaleKeys.vocabularyCriteriaNotMet.tr(),
                        ),
                        if (attempt.notes.isNotEmpty) Text(attempt.notes),
                        if (attempt.evidenceId case final evidenceId?)
                          FgButton(
                            text: LocaleKeys.vocabularyViewEvidence.tr(),
                            variant: FgButtonVariant.secondary,
                            onPressed: () =>
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).push<void>(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EvidenceViewer(evidenceId: evidenceId),
                                  ),
                                ),
                          ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        LocaleKeys.vocabularyPracticeHistory.tr(
                          args: ['${status.practiceHistory.length}'],
                        ),
                      ),
                      if (status.practiceHistory.isEmpty)
                        Text(LocaleKeys.vocabularyNoPractice.tr()),
                      for (final record in status.practiceHistory.take(3))
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            LocaleKeys.vocabularyPracticeSummary.tr(
                              args: [
                                DateFormat.yMMMd().add_Hm().format(
                                  record.performedAt.toLocal(),
                                ),
                                '${record.durationSeconds}',
                                '${record.bpm}',
                                '${record.difficulty}',
                              ],
                            ),
                          ),
                        ),
                    ],
                    FgButton(
                      text: LocaleKeys.vocabularyOpenHistory.tr(),
                      variant: FgButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) =>
                              PracticeLogPage(vocabularyId: entry.id),
                        ),
                      ),
                    ),
                    FgButton(
                      text: LocaleKeys.vocabularyAssessCategory.tr(
                        args: [entry.category.label],
                      ),
                      isEnabled:
                          learn?.canOpenLesson(assessment.linkedLessonId) ??
                          false,
                      onPressed: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) => MethodPage(
                            initialCategory: entry.category,
                            initialAssessmentId: assessment.id,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      LocaleKeys.vocabularyRelated.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final id in entry.relatedIds)
                      if (const VocabularyRepository().byId(id)
                          case final related?)
                        FgButton(
                          text: related.name,
                          variant: FgButtonVariant.secondary,
                          onPressed: () =>
                              VocabularyDestination(id).push<void>(context),
                        ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FgCard(
        immersive: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.forgeColors.onImmersive,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.forgeColors.onImmersiveMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
