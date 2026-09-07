import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../learn/model/lesson_progress.dart';
import '../../learn/ui/state/learn_state.dart';
import '../../learn/ui/view_model/learn_view_model.dart';
import '../../method/model/forge_method.dart';
import '../../method/repository/method_catalog.dart';
import '../../method/ui/method_page.dart';
import '../../practice/model/practice.dart';
import '../../practice/ui/practice_view_model.dart';
import '../../practice_player/ui/practice_player_page.dart';
import '../model/programme.dart';
import '../repository/programme_catalog.dart';
import 'programmes_view_model.dart';

class ProgrammesPage extends ConsumerWidget {
  const ProgrammesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolled = ref.watch(programmesViewModelProvider);
    final learn = ref.watch(learnViewModelProvider);
    return FgImmersiveScaffold(
      bodyBuilder: (context) => ListView(
        children: [
          AppHeader(
            title: LocaleKeys.programmesTitle.tr(),
            onBack: () => Navigator.of(context).pop(),
          ),
          Padding(
            padding: AppSpacing.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.programmesIntroduction.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).forgeColors.onImmersive,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (enrolled.isLoading || learn.isLoading)
                  const Center(child: FgSpinner()),
                if (enrolled.hasError || learn.hasError)
                  FgButton(
                    text: LocaleKeys.programmesRetry.tr(),
                    onPressed: () {
                      ref.invalidate(programmesViewModelProvider);
                      ref.invalidate(learnViewModelProvider);
                    },
                  ),
                for (final programme in forgeProgrammes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: FgCard(
                      immersive: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            programme.title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .forgeColors
                                      .onImmersive,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            programme.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .forgeColors
                                      .onImmersiveMuted,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (learn.value case final learning?)
                            Text(
                              LocaleKeys.programmesProgress.tr(
                                args: [
                                  '${programme.completedSessions(learning)}',
                                  '${programme.sessions.length}',
                                ],
                              ),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .forgeColors
                                        .onImmersiveMuted,
                                  ),
                            ),
                          FgButton(
                            text:
                                (enrolled.value?.contains(programme.id) ??
                                    false)
                                ? LocaleKeys.programmesContinue.tr()
                                : LocaleKeys.programmesView.tr(),
                            onPressed: () => Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (_) =>
                                    _ProgrammePage(programme: programme),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgrammePage extends ConsumerStatefulWidget {
  const _ProgrammePage({required this.programme});
  final Programme programme;

  @override
  ConsumerState<_ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends ConsumerState<_ProgrammePage> {
  bool _saving = false;

  Future<void> _enrol(bool enrolled) async {
    setState(() => _saving = true);
    try {
      final notifier = ref.read(programmesViewModelProvider.notifier);
      if (enrolled) {
        await notifier.leave(widget.programme.id);
      } else {
        await notifier.enrol(widget.programme.id);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.programmesSaveError.tr())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _practice(PracticeBlock block) async {
    final learn = ref.read(learnViewModelProvider).value;
    if (!(learn?.canOpenLesson(block.lessonId) ?? false)) return;
    final record = await Navigator.of(context, rootNavigator: true)
        .push<PracticeRecord>(
          MaterialPageRoute(builder: (_) => PracticePlayerPage(block: block)),
        );
    if (record == null || !mounted) return;
    // Keep the returned record until persistence succeeds, so a disk failure is retryable.
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

  void _openLesson(LearnState learn, String id) {
    final module = learn.modules.firstWhere(
      (module) => module.lessons.any((lesson) => lesson.id == id),
    );
    if (learn.canOpenLesson(id)) {
      LessonDestination(module.id, id).push<void>(context);
    } else {
      ModuleDestination(module.id).push<void>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final learning = ref.watch(learnViewModelProvider);
    final enrolments = ref.watch(programmesViewModelProvider);
    final programme = widget.programme;
    final learn = learning.value;
    final enrolled = enrolments.value?.contains(programme.id) ?? false;
    final assessment = forgeAssessments.firstWhere(
      (item) => item.id == programme.assessmentId,
    );
    return FgImmersiveScaffold(
      bodyBuilder: (context) {
        final theme = Theme.of(context);
        return ListView(
          children: [
            AppHeader(
              title: programme.title,
              onBack: () => Navigator.of(context).pop(),
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
                    Text(programme.description),
                    const SizedBox(height: AppSpacing.lg),
                    Text(programme.schedule),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      LocaleKeys.programmesGains.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    for (final gain in programme.intendedGains.entries)
                      Text('${gain.key.label}: ${gain.value}'),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      LocaleKeys.programmesPrerequisites.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    if (programme.prerequisiteLessonIds.isEmpty)
                      Text(LocaleKeys.programmesNoPrerequisites.tr()),
                    if (learn != null)
                      for (final id in programme.prerequisiteLessonIds)
                        FgButton(
                          text: learn.lessonById(id)!.title,
                          variant: FgButtonVariant.secondary,
                          onPressed: () => _openLesson(learn, id),
                        ),
                    if (learning.isLoading || enrolments.isLoading)
                      const Center(child: FgSpinner()),
                    if (learning.hasError || enrolments.hasError)
                      FgButton(
                        text: LocaleKeys.programmesRetry.tr(),
                        onPressed: () {
                          ref.invalidate(learnViewModelProvider);
                          ref.invalidate(programmesViewModelProvider);
                        },
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    FgButton(
                      text: enrolled
                          ? LocaleKeys.programmesLeave.tr()
                          : LocaleKeys.programmesStart.tr(),
                      isLoading: _saving,
                      isEnabled:
                          learn != null &&
                          enrolments.hasValue &&
                          (enrolled ||
                              programme.unmetPrerequisites(learn).isEmpty),
                      onPressed: () => _enrol(enrolled),
                    ),
                    if (learn != null &&
                        programme.unmetPrerequisites(learn).isNotEmpty)
                      Text(LocaleKeys.programmesPrerequisiteHint.tr()),
                    if (learn != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        LocaleKeys.programmesProgress.tr(
                          args: [
                            '${programme.completedSessions(learn)}',
                            '${programme.sessions.length}',
                          ],
                        ),
                      ),
                      FgProgressBar(
                        value:
                            programme.completedSessions(learn) /
                            programme.sessions.length,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(LocaleKeys.programmesCompletionNotMastery.tr()),
                      const SizedBox(height: AppSpacing.lg),
                      for (final session in programme.sessions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: FgCard(
                            immersive: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(session.schedule),
                                Text(
                                  learn.lessonById(session.lessonId)!.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.forgeColors.onImmersive,
                                  ),
                                ),
                                Text(
                                  learn.progress[session.lessonId]?.status ==
                                          LessonStatus.completed
                                      ? LocaleKeys.programmesStudied.tr()
                                      : LocaleKeys.programmesNotStudied.tr(),
                                ),
                                if (programme.nextSession(learn)?.lessonId ==
                                    session.lessonId)
                                  Text(LocaleKeys.programmesNextSession.tr()),
                                FgButton(
                                  text: learn.canOpenLesson(session.lessonId)
                                      ? LocaleKeys.vocabularyViewLesson.tr()
                                      : LocaleKeys.vocabularyViewPath.tr(),
                                  variant: FgButtonVariant.secondary,
                                  onPressed: () =>
                                      _openLesson(learn, session.lessonId),
                                ),
                                FgButton(
                                  text: LocaleKeys.programmesPracticeSession
                                      .tr(),
                                  isEnabled:
                                      enrolled &&
                                      learn.canOpenLesson(session.lessonId),
                                  onPressed: () => _practice(session.practice),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      LocaleKeys.programmesFinalAssessment.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.forgeColors.onImmersive,
                      ),
                    ),
                    Text(assessment.title),
                    Text(LocaleKeys.programmesAssessmentHint.tr()),
                    FgButton(
                      text: LocaleKeys.programmesOpenAssessment.tr(),
                      isEnabled:
                          learn != null &&
                          learn.canOpenLesson(assessment.linkedLessonId),
                      onPressed: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) => MethodPage(
                            initialCategory: assessment.category,
                            initialAssessmentId: assessment.id,
                          ),
                        ),
                      ),
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
}
