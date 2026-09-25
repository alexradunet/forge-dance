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
  bool _saving = false;
  PracticeRecord? _pending;
  bool _saveFailed = false;

  Future<void> _practice({required bool harder}) async {
    if (_saving || _pending != null) return;
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
    setState(() => _saving = true);
    final record = await Navigator.of(context, rootNavigator: true)
        .push<PracticeRecord>(
          MaterialPageRoute(builder: (_) => PracticePlayerPage(block: block)),
        );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _pending = record;
    });
    if (record == null) return;
    await _savePractice(record);
  }

  Future<void> _savePractice(PracticeRecord record) async {
    if (_saving || !identical(record, _pending)) return;
    setState(() {
      _saving = true;
      _saveFailed = false;
    });
    try {
      if (ref.read(practiceViewModelProvider).isLoading) {
        await ref.read(practiceViewModelProvider.future);
      }
      await ref.read(practiceViewModelProvider.notifier).record(record);
      if (!mounted) return;
      setState(() => _pending = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.programmesPracticeSaved.tr())),
      );
    } catch (_) {
      if (mounted) setState(() => _saveFailed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _discardPending(BuildContext context) async {
    if (_saving) return;
    final discard = await FgImmersiveScaffold.showModal<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(LocaleKeys.practiceDiscardTitle.tr()),
        content: Text(LocaleKeys.practiceDiscardBody.tr()),
        actions: [
          FgButton(
            text: LocaleKeys.practiceCancel.tr(),
            variant: FgButtonVariant.ghost,
            onPressed: () => Navigator.pop(context, false),
          ),
          FgButton(
            text: LocaleKeys.practiceDiscard.tr(),
            variant: FgButtonVariant.destructive,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (discard == true && mounted) {
      setState(() {
        _pending = null;
        _saveFailed = false;
      });
    }
  }

  Widget _pendingResult(BuildContext context) => FgReadingBody(
    child: ListView(
      padding: AppSpacing.allLG,
      children: [
        FgRoundPanel(
          label: LocaleKeys.practiceUnsaved.tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _pending!.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_saveFailed)
                Text(
                  LocaleKeys.programmesSaveError.tr(),
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: AppSpacing.lg),
              FgButton(
                text: LocaleKeys.practiceRetrySave.tr(),
                isLoading: _saving,
                onPressed: () => _savePractice(_pending!),
              ),
              const SizedBox(height: AppSpacing.sm),
              FgButton(
                text: LocaleKeys.practiceDiscard.tr(),
                variant: FgButtonVariant.secondary,
                onPressed: _saving ? null : () => _discardPending(context),
              ),
            ],
          ),
        ),
      ],
    ),
  );

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
    return PopScope(
      canPop: !_saving && _pending == null,
      child: FgImmersiveScaffold(
        bodyBuilder: (context) {
          if (_pending != null) return _pendingResult(context);
          if (_saving) return const Center(child: FgSpinner());
          final theme = Theme.of(context);
          final prerequisiteLinks = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (const VocabularyRepository().prerequisitesFor(entry).isEmpty)
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
                      (module) =>
                          module.lessons.any((item) => item.id == lesson.id),
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
            ],
          );
          return Column(
            children: [
              FgReadingBody(
                child: AppHeader(
                  title: LocaleKeys.vocabularyTitle.tr(),
                  compact: true,
                  onBack: widget.onBack,
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.readingContentMax,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: AppSpacing.allLG,
                          child: DefaultTextStyle(
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.forgeColors.onImmersive,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FgSectionHeading(
                                  eyebrow:
                                      '${LocaleKeys.vocabularyEntryIndex.tr(args: ['${const VocabularyRepository().entries.indexOf(entry) + 1}'.padLeft(2, '0')])} · ${vocabularyKindLabel(entry.kind)} · ${entry.style}',
                                  title: entry.name.toUpperCase(),
                                  subtitle: entry.definition,
                                ),
                                const SizedBox(height: AppSpacing.xxl),
                                FgCard(
                                  immersive: true,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.vocabularyCue.tr(),
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(
                                        entry.cue,
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  LocaleKeys.vocabularyComfort.tr(),
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: AppSpacing.xxl),
                                FgButton(
                                  text: canOpenLesson
                                      ? LocaleKeys.vocabularyStartEasier.tr()
                                      : LocaleKeys.vocabularyViewPath.tr(),
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    if (canOpenLesson) {
                                      _practice(harder: false);
                                    } else {
                                      ModuleDestination(entry.moduleId)
                                          .push<void>(context);
                                    }
                                  },
                                ),
                                if (status != null) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    status.studied
                                        ? LocaleKeys.programmesStudied.tr()
                                        : LocaleKeys.programmesNotStudied.tr(),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                                const SizedBox(height: AppSpacing.lg),
                                FgDetails(
                                  key: ValueKey(
                                    'vocabulary-technique-${entry.id}',
                                  ),
                                  title: LocaleKeys.detailsMovement.tr(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (canOpenLesson) ...[
                                        FgButton(
                                          text: LocaleKeys.vocabularyViewLesson
                                              .tr(),
                                          variant: FgButtonVariant.secondary,
                                          onPressed: () => LessonDestination(
                                            entry.moduleId,
                                            entry.lessonId,
                                          ).push<void>(context),
                                        ),
                                        const SizedBox(height: AppSpacing.lg),
                                      ],
                                      if (entry.aliases.isNotEmpty)
                                        Text(
                                          LocaleKeys.vocabularyAlsoKnown.tr(
                                            args: [entry.aliases.join(', ')],
                                          ),
                                        ),
                                      _section(
                                        context,
                                        LocaleKeys.vocabularyContext.tr(),
                                        entry.context,
                                      ),
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
                                      if (canOpenLesson)
                                        FgButton(
                                          text: LocaleKeys.vocabularyStartHarder
                                              .tr(),
                                          variant: FgButtonVariant.secondary,
                                          onPressed: () =>
                                              _practice(harder: true),
                                        ),
                                    ],
                                  ),
                                ),
                                if (const VocabularyRepository()
                                    .prerequisitesFor(entry)
                                    .isNotEmpty)
                                  FgDetails(
                                    key: ValueKey(
                                      'vocabulary-prerequisites-${entry.id}',
                                    ),
                                    title: LocaleKeys.programmesPrerequisites
                                        .tr(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        if (!canOpenLesson) ...[
                                          Text(
                                            LocaleKeys.vocabularyPathHint.tr(),
                                          ),
                                          const SizedBox(height: AppSpacing.md),
                                        ],
                                        prerequisiteLinks,
                                      ],
                                    ),
                                  ),
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
                                FgDetails(
                                  key: ValueKey(
                                    'vocabulary-progress-${entry.id}',
                                  ),
                                  title: LocaleKeys.detailsProgress.tr(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (status != null) ...[
                                        Text(
                                          status.categoryLevel > 0
                                              ? LocaleKeys
                                                    .vocabularyCategoryDemonstrated
                                                    .tr(
                                                      args: [
                                                        entry.category.label,
                                                        '${status.categoryLevel}',
                                                      ],
                                                    )
                                              : LocaleKeys
                                                    .vocabularyCategoryNotDemonstrated
                                                    .tr(
                                                      args: [
                                                        entry.category.label,
                                                      ],
                                                    ),
                                        ),
                                      ],
                                      FgButton(
                                        text: LocaleKeys
                                            .vocabularyAssessCategory
                                            .tr(args: [entry.category.label]),
                                        isEnabled:
                                            learn?.canOpenLesson(
                                              assessment.linkedLessonId,
                                            ) ??
                                            false,
                                        onPressed: () => Navigator.of(context)
                                            .push<void>(
                                              MaterialPageRoute(
                                                builder: (_) => MethodPage(
                                                  initialCategory:
                                                      entry.category,
                                                  initialAssessmentId:
                                                      assessment.id,
                                                ),
                                              ),
                                            ),
                                      ),
                                      if (learn != null &&
                                          !learn.canOpenLesson(
                                            assessment.linkedLessonId,
                                          )) ...[
                                        Text(
                                          LocaleKeys.compactAssessmentLocked
                                              .tr(),
                                        ),
                                        FgButton(
                                          text: LocaleKeys.vocabularyViewPath
                                              .tr(),
                                          variant: FgButtonVariant.secondary,
                                          onPressed: () {
                                            final module = learn.modules
                                                .firstWhere(
                                                  (module) =>
                                                      module.lessons.any(
                                                        (lesson) =>
                                                            lesson.id ==
                                                            assessment
                                                                .linkedLessonId,
                                                      ),
                                                );
                                            ModuleDestination(module.id)
                                                .push<void>(context);
                                          },
                                        ),
                                      ],
                                      const SizedBox(height: AppSpacing.lg),
                                      Text(
                                        LocaleKeys
                                            .programmesCompletionNotMastery
                                            .tr(),
                                      ),
                                      if (status != null) ...[
                                        Text(
                                          LocaleKeys
                                              .vocabularyCategoryEvidenceHint
                                              .tr(),
                                        ),
                                        for (final attempt
                                            in status.categoryAttempts) ...[
                                          const SizedBox(height: AppSpacing.md),
                                          Text(
                                            '${DateFormat.yMMMd().add_Hm().format(attempt.performedAt.toLocal())} • ${attempt.assessment.title}',
                                          ),
                                          Text(
                                            attempt.passed
                                                ? LocaleKeys
                                                      .vocabularyCriteriaMet
                                                      .tr()
                                                : LocaleKeys
                                                      .vocabularyCriteriaNotMet
                                                      .tr(),
                                          ),
                                          if (attempt.notes.isNotEmpty)
                                            Text(attempt.notes),
                                          if (attempt.evidenceId
                                              case final evidenceId?)
                                            FgButton(
                                              text: LocaleKeys
                                                  .vocabularyViewEvidence
                                                  .tr(),
                                              variant:
                                                  FgButtonVariant.secondary,
                                              onPressed: () =>
                                                  Navigator.of(
                                                    context,
                                                    rootNavigator: true,
                                                  ).push<void>(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EvidenceViewer(
                                                            evidenceId:
                                                                evidenceId,
                                                          ),
                                                    ),
                                                  ),
                                            ),
                                        ],
                                        const SizedBox(height: AppSpacing.lg),
                                        Text(
                                          LocaleKeys.vocabularyPracticeHistory.tr(
                                            args: [
                                              '${status.practiceHistory.length}',
                                            ],
                                          ),
                                        ),
                                        if (status.practiceHistory.isEmpty)
                                          Text(
                                            LocaleKeys.vocabularyNoPractice
                                                .tr(),
                                          ),
                                        for (final record
                                            in status.practiceHistory.take(3))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: AppSpacing.sm,
                                            ),
                                            child: Text(
                                              LocaleKeys
                                                  .vocabularyPracticeSummary
                                                  .tr(
                                                    args: [
                                                      DateFormat.yMMMd()
                                                          .add_Hm()
                                                          .format(
                                                            record.performedAt
                                                                .toLocal(),
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
                                        text: LocaleKeys.vocabularyOpenHistory
                                            .tr(),
                                        variant: FgButtonVariant.secondary,
                                        onPressed: () => Navigator.of(context)
                                            .push<void>(
                                              MaterialPageRoute(
                                                builder: (_) => PracticeLogPage(
                                                  vocabularyId: entry.id,
                                                ),
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (entry.relatedIds.isNotEmpty)
                                  FgDetails(
                                    key: ValueKey(
                                      'vocabulary-related-${entry.id}',
                                    ),
                                    title: LocaleKeys.vocabularyRelated.tr(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        for (final id in entry.relatedIds)
                                          if (const VocabularyRepository().byId(
                                                id,
                                              )
                                              case final related?)
                                            FgButton(
                                              text: related.name,
                                              variant:
                                                  FgButtonVariant.secondary,
                                              onPressed: () =>
                                                  VocabularyDestination(id)
                                                      .push<void>(context),
                                            ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.forgeMutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
