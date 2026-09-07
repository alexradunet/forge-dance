import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../learn/repository/lesson_catalog.dart';
import '../../learn/ui/lesson_player_screen.dart';
import '../../learn/ui/view_model/learn_view_model.dart';
import '../../method/ui/method_view_model.dart';
import '../../practice_player/ui/practice_player_page.dart';
import '../model/practice.dart';
import '../repository/practice_planner.dart';
import 'practice_log_page.dart';
import 'practice_view_model.dart';

class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({super.key});

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  bool _busy = false;
  PracticeRecord? _pending;
  String? _error;

  Future<void> _play(PracticeBlock block) async {
    if (_busy || _pending != null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final record = await Navigator.of(context, rootNavigator: true)
        .push<PracticeRecord>(
          MaterialPageRoute(builder: (_) => PracticePlayerPage(block: block)),
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _pending = record;
    });
    if (record != null) await _savePending();
  }

  Future<void> _savePending() async {
    final record = _pending;
    if (_busy || record == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(practiceViewModelProvider.notifier).record(record);
      if (!mounted) return;
      setState(() => _pending = null);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(LocaleKeys.practiceSaved.tr())));
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = LocaleKeys.practiceSaveFailed.tr(args: ['$error']),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveChoices(PracticePreferences value) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(practicePreferencesViewModelProvider.notifier).save(value);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = LocaleKeys.practiceSaveFailed.tr(args: ['$error']),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _discard() async {
    final discard = await FgImmersiveScaffold.showModal<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
        _error = null;
      });
    }
  }

  Future<void> _openLesson(String lessonId) async {
    final learn = ref.read(learnViewModelProvider).value;
    if (learn == null || !learn.canOpenLesson(lessonId)) return;
    final module = allModules.firstWhere(
      (module) => module.lessons.any((lesson) => lesson.id == lessonId),
    );
    ref.read(learnViewModelProvider.notifier).selectModule(module.id);
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => LessonPlayerScreen(
          lessonId: lessonId,
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final method = ref.watch(methodViewModelProvider);
    final preferences = ref.watch(practicePreferencesViewModelProvider);
    final learn = ref.watch(learnViewModelProvider);
    final progress = method.value;
    final choices = preferences.value;
    return PopScope(
      canPop: _pending == null && !_busy,
      child: FgImmersiveScaffold(
        title: LocaleKeys.practiceTitle.tr(),
        bodyBuilder: (context) => ListView(
          padding: AppSpacing.allLG,
          children: [
            Text(LocaleKeys.practiceIntro.tr()),
            const SizedBox(height: AppSpacing.lg),
            FgButton(
              text: LocaleKeys.practiceLogTitle.tr(),
              variant: FgButtonVariant.secondary,
              onPressed: _pending != null || _busy
                  ? null
                  : () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => const PracticeLogPage(),
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FgButton(
              text: LocaleKeys.practiceOptionalFitness.tr(),
              variant: FgButtonVariant.ghost,
              onPressed: _pending != null || _busy
                  ? null
                  : () => context.push(Routes.workout),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_pending != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FgCard(
                immersive: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.practiceUnsaved.tr()),
                    Text(_pending!.title),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        FgButton(
                          text: LocaleKeys.practiceRetrySave.tr(),
                          isLoading: _busy,
                          onPressed: _savePending,
                        ),
                        FgButton(
                          text: LocaleKeys.practiceDiscard.tr(),
                          variant: FgButtonVariant.ghost,
                          onPressed: _busy ? null : _discard,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (method.hasError || preferences.hasError) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                LocaleKeys.practiceLoadFailed.tr(
                  args: ['${method.error ?? preferences.error}'],
                ),
              ),
              FgButton(
                text: LocaleKeys.practiceRetry.tr(),
                onPressed: () async {
                  await ref.read(methodViewModelProvider.notifier).reload();
                  await ref
                      .read(practicePreferencesViewModelProvider.notifier)
                      .reload();
                },
              ),
            ] else if (progress == null || choices == null)
              const Center(child: FgSpinner())
            else ...[
              const SizedBox(height: AppSpacing.lg),
              _choices(context, choices),
              const SizedBox(height: AppSpacing.lg),
              Text(
                LocaleKeys.practicePlanSummary.tr(args: ['${choices.minutes}']),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (learn.hasError)
                Text(LocaleKeys.practiceLessonLoadFailed.tr()),
              for (final block in buildPracticePlan(
                progress: progress,
                minutes: choices.minutes,
                gentle: choices.gentle,
                includeConditioning: choices.includeConditioning,
                support: choices.support,
              ).blocks) ...[
                const SizedBox(height: AppSpacing.lg),
                FgCard(
                  immersive: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        block.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        LocaleKeys.practiceBlockSummary.tr(
                          args: [
                            '${block.minutes}',
                            '${block.level}',
                            '${block.bpm}',
                          ],
                        ),
                      ),
                      if (block.category != null &&
                          progress.levelFor(block.category!) == 0)
                        Text(LocaleKeys.practiceUnassessed.tr()),
                      const SizedBox(height: AppSpacing.sm),
                      Text(block.adaptation),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          FgButton(
                            text: LocaleKeys.practicePlay.tr(),
                            icon: const Icon(Icons.play_arrow),
                            onPressed: _busy || _pending != null
                                ? null
                                : () => _play(block),
                          ),
                          FgButton(
                            text: LocaleKeys.practiceRelatedLesson.tr(),
                            variant: FgButtonVariant.secondary,
                            onPressed:
                                _busy ||
                                    _pending != null ||
                                    !(learn.value?.canOpenLesson(
                                          block.lessonId,
                                        ) ??
                                        false)
                                ? null
                                : () => _openLesson(block.lessonId),
                          ),
                        ],
                      ),
                      if (!(learn.value?.canOpenLesson(block.lessonId) ??
                          false))
                        Text(LocaleKeys.practiceLessonLocked.tr()),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _choices(BuildContext context, PracticePreferences value) {
    void change({
      int? minutes,
      bool? gentle,
      bool? conditioning,
      PracticeSupport? support,
    }) {
      _saveChoices(
        PracticePreferences(
          minutes: minutes ?? value.minutes,
          gentle: gentle ?? value.gentle,
          includeConditioning: conditioning ?? value.includeConditioning,
          support: support ?? value.support,
        ),
      );
    }

    return FgCard(
      immersive: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.practiceTime.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final minutes in [10, 20, 30, 45, 60])
                FgFilterChip(
                  label: LocaleKeys.practiceMinutes.tr(args: ['$minutes']),
                  isSelected: value.minutes == minutes,
                  isEnabled: !_busy && _pending == null,
                  onSelected: (_) => change(minutes: minutes),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(LocaleKeys.practiceGentle.tr())),
              FgToggle(
                value: value.gentle,
                semanticLabel: LocaleKeys.practiceGentle.tr(),
                isEnabled: !_busy && _pending == null,
                onChanged: (gentle) => change(gentle: gentle),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(LocaleKeys.practiceConditioning.tr())),
              FgToggle(
                value: value.includeConditioning,
                semanticLabel: LocaleKeys.practiceConditioning.tr(),
                isEnabled: !_busy && _pending == null,
                onChanged: (conditioning) => change(conditioning: conditioning),
              ),
            ],
          ),
          Text(
            LocaleKeys.practiceSupport.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final support in PracticeSupport.values)
                FgFilterChip(
                  label: switch (support) {
                    PracticeSupport.standing =>
                      LocaleKeys.practiceStanding.tr(),
                    PracticeSupport.seated => LocaleKeys.practiceSeated.tr(),
                    PracticeSupport.supported =>
                      LocaleKeys.practiceSupported.tr(),
                  },
                  isSelected: value.support == support,
                  isEnabled: !_busy && _pending == null,
                  onSelected: (_) => change(support: support),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
