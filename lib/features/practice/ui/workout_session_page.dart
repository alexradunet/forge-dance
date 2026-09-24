import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../generated/locale_keys.g.dart';

import '../../../design_system/design_system.dart';
import '../../practice_player/ui/practice_player_page.dart';
import '../model/workout_session.dart';

/// Owns the route, not persistence. Only one shared player is mounted at a time.
class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({super.key, required this.session});
  final WorkoutSession session;

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage>
    with WidgetsBindingObserver {
  WorkoutSession get session => widget.session;
  bool _leaving = false;
  double _drag = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) session.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    session.dispose();
    super.dispose();
  }

  String get _variant {
    final round = session.current;
    return '${round.independent ? LocaleKeys.playerIndependent.tr() : LocaleKeys.playerGuided.tr()}; '
        '${LocaleKeys.playerPhrase.tr()}: ${round.clock.phraseStart}–${round.clock.phraseEnd}; ${round.block.adaptation}';
  }

  Future<void> _next() async {
    final result = await session.next(_variant);
    if (mounted && result == WorkoutAdvance.confirmSkip) await _skip();
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String action,
  }) async {
    if (!session.beginConfirmation()) return false;
    final result = await FgImmersiveScaffold.showModal<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        scrollable: true,
        content: Text(body),
        actions: [
          FgButton(
            key: const ValueKey('workout-cancel'),
            text: LocaleKeys.practiceCancel.tr(),
            variant: FgButtonVariant.ghost,
            onPressed: () => Navigator.pop(context, false),
          ),
          FgButton(
            key: const ValueKey('workout-confirm'),
            text: action,
            variant: FgButtonVariant.destructive,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _skip() async {
    if (session.saving || session.confirming) return;
    final failed = session.current.pending != null;
    final accepted = await _confirm(
      title: failed
          ? LocaleKeys.workoutAbandonTitle.tr()
          : LocaleKeys.workoutSkipTitle.tr(),
      body: failed
          ? LocaleKeys.workoutAbandonBody.tr()
          : LocaleKeys.workoutSkipBody.tr(),
      action: failed
          ? LocaleKeys.workoutAbandonSkip.tr()
          : LocaleKeys.workoutSkipRound.tr(),
    );
    if (!mounted) return;
    if (accepted) {
      session.confirmSkip();
    } else {
      session.cancelConfirmation();
    }
  }

  Future<void> _exit() async {
    if (_leaving || session.saving || session.confirming) return;
    if (!session.summary) {
      final accepted = await _confirm(
        title: LocaleKeys.workoutSessionLeaveTitle.tr(),
        body: session.error == null
            ? LocaleKeys.workoutSessionLeaveBody.tr()
            : LocaleKeys.workoutLeaveFailedBody.tr(),
        action: LocaleKeys.workoutLeave.tr(),
      );
      if (!mounted) return;
      session.cancelConfirmation();
      if (!accepted) return;
    }
    setState(() => _leaving = true);
    // Let PopScope receive the changed permission before popping the route.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  String _status(WorkoutRoundStatus status) => switch (status) {
    WorkoutRoundStatus.current => LocaleKeys.workoutStatusCurrent.tr(),
    WorkoutRoundStatus.completed => LocaleKeys.workoutStatusCompleted.tr(),
    WorkoutRoundStatus.skipped => LocaleKeys.workoutStatusSkipped.tr(),
  };

  Widget _navigation() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        container: true,
        liveRegion: true,
        child: Text(
          LocaleKeys.workoutRoundStatus.tr(
            args: [
              '${session.index + 1}',
              '${session.rounds.length}',
              _status(session.current.status),
            ],
          ),
          key: const ValueKey('workout-round-status'),
        ),
      ),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          FgButton(
            key: const ValueKey('workout-previous'),
            text: LocaleKeys.workoutPrevious.tr(),
            variant: FgButtonVariant.secondary,
            onPressed:
                session.index > 0 &&
                    !session.saving &&
                    (session.current.pending == null ||
                        session.current.status != WorkoutRoundStatus.current)
                ? session.previous
                : null,
          ),
          FgButton(
            key: const ValueKey('workout-next'),
            text: LocaleKeys.workoutNext.tr(),
            variant: FgButtonVariant.secondary,
            onPressed: session.saving ? null : _next,
          ),
          if (session.current.status == WorkoutRoundStatus.current)
            FgButton(
              key: const ValueKey('workout-skip'),
              text: LocaleKeys.workoutSkip.tr(),
              variant: FgButtonVariant.ghost,
              onPressed: session.saving ? null : _skip,
            ),
        ],
      ),

      if (session.saving)
        Semantics(
          container: true,
          liveRegion: true,
          child: Text(LocaleKeys.workoutSavingRound.tr()),
        ),
      if (session.error != null) ...[
        Semantics(
          container: true,
          liveRegion: true,
          child: Text(
            LocaleKeys.workoutSaveError.tr(args: ['${session.error}']),
            key: const ValueKey('workout-save-error'),
          ),
        ),
        FgButton(
          key: const ValueKey('workout-retry'),
          text: LocaleKeys.practiceRetrySave.tr(),
          onPressed: session.saving ? null : _next,
        ),
      ],
      Semantics(
        container: true,
        child: FgDetails(
          key: const ValueKey('workout-navigation-details'),
          title: LocaleKeys.workoutNavigationDetails.tr(),
          child: Text(
            '${session.plan.title} · ${session.plan.dateKey}\n${LocaleKeys.workoutNavigationHelp.tr()}',
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
    ],
  );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: session,
    builder: (context, _) => PopScope(
      canPop: _leaving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: session.summary
          ? FgImmersiveScaffold(
              title: LocaleKeys.workoutSummaryTitle.tr(),
              bodyBuilder: (context) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.readingContentMax,
                  ),
                  child: ListView(
                    padding: AppSpacing.allLG,
                    children: [
                      Text(
                        LocaleKeys.workoutSummaryCounts.tr(
                          args: ['${session.completed}', '${session.skipped}'],
                        ),
                        key: const ValueKey('workout-summary'),
                      ),
                      if (session.completed == 0)
                        Text(LocaleKeys.workoutNoCompleted.tr()),
                      Text(LocaleKeys.workoutSummaryHelp.tr()),
                      if (session.abandonedSave)
                        Text(LocaleKeys.workoutSummaryAbandoned.tr()),
                      for (final round in session.rounds)
                        Text('${round.block.title} · ${_status(round.status)}'),
                      const SizedBox(height: AppSpacing.lg),
                      FgButton(
                        variant: FgButtonVariant.secondary,
                        text: LocaleKeys.workoutReviewRounds.tr(),
                        onPressed: session.previous,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FgButton(
                        key: const ValueKey('workout-finish'),
                        text: LocaleKeys.workoutFinishSession.tr(),
                        onPressed: _exit,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : GestureDetector(
              onHorizontalDragStart: (_) => _drag = 0,
              onHorizontalDragUpdate: (details) => _drag += details.delta.dx,
              onHorizontalDragEnd: (_) {
                if (_drag < -AppSizes.comfortableTouchTarget) _next();
                if (_drag > AppSizes.comfortableTouchTarget) session.previous();
              },
              child: PracticePlayerPage(
                key: ValueKey(session.index),
                block: session.current.block,
                session: session,
                navigation: _navigation(),
                onExit: _exit,
                onNext: _next,
              ),
            ),
    ),
  );
}
