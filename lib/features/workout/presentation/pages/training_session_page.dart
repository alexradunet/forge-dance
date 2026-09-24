import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../stats/model/projection_health.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../model/workout.dart';
import '../../ui/view_model/workout_view_model.dart';
import 'workout_overview.dart';

/// The daily training session (WOD): purpose-built overview → timed exercise
/// steps with a timer/skip gate → purpose-built completion reward.
class TrainingSessionPage extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onStart;
  final bool startImmediately;

  const TrainingSessionPage({
    super.key,
    this.onClose,
    this.onStart,
    this.startImmediately = false,
  });

  @override
  ConsumerState<TrainingSessionPage> createState() =>
      _TrainingSessionPageState();
}

class _TrainingSessionPageState extends ConsumerState<TrainingSessionPage>
    with WidgetsBindingObserver {
  int _currentPage = 0;
  bool _isTimerRunning = false;
  int _timeLeft = 0;
  Timer? _timer;
  final Set<int> _skippedExercises = {};
  final Set<int> _completedExercises = {};
  bool _completionHandled = false;
  bool _xpAwarded = false;
  bool _saving = false;
  bool _saveFailed = false;
  bool _allowExit = false;
  bool _confirmingExit = false;
  late final ScrollController _contentScrollController;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.startImmediately ? 1 : 0;
    _contentScrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _contentScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _stopTimer();
  }

  Future<void> _close(BuildContext context) async {
    if (_saving || _confirmingExit) return;
    _clearFeedback();
    final wod = ref.read(workoutViewModelProvider).value?.wod;
    if (!_isIntro && (wod == null || !_isComplete(wod) || _saveFailed)) {
      _stopTimer();
      _confirmingExit = true;
      final leave = await FgImmersiveScaffold.showModal<bool>(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text(LocaleKeys.workoutLeaveTitle.tr()),
          content: Text(LocaleKeys.workoutLeaveBody.tr()),
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
      _confirmingExit = false;
      if (leave != true || !mounted) return;
      ref.read(workoutViewModelProvider.notifier).abandonCompletion();
    }
    setState(() => _allowExit = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) (widget.onClose ?? () => Navigator.of(context).pop())();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutViewModelProvider);
    final state = workoutState.value;
    if (state == null) {
      return FgImmersiveScaffold(
        title: LocaleKeys.workoutOverview.tr(),
        bodyBuilder: (context) => workoutState.hasError
            ? FgEmpty(
                icon: Icons.error_outline,
                title: LocaleKeys.unexpectedErrorOccurred.tr(),
                tone: FgEmptyTone.error,
                actionLabel: LocaleKeys.practiceRetry.tr(),
                onAction: () => ref.invalidate(workoutViewModelProvider),
              )
            : const Center(child: FgSpinner()),
      );
    }
    final wod = state.wod;
    if (_isIntro) {
      return WorkoutOverview(
        workout: wod,
        onStart: widget.onStart ?? () => _nextPage(wod),
        onClose: widget.onClose ?? () => Navigator.of(context).pop(),
      );
    }
    _initializeTimerIfNeeded(wod);
    final complete = _isComplete(wod);
    return PopScope(
      canPop: _allowExit,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close(context);
      },
      child: FgImmersiveScaffold(
        bodyBuilder: (context) => FgReadingBody(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  key: const ValueKey('workout-content-scroll'),
                  controller: _contentScrollController,
                  padding: AppSpacing.allLG,
                  children: [
                    AppHeader(
                      compact: true,
                      title: wod.title,
                      onBack: _saving ? null : () => _close(context),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (complete) ...[
                      if (_saving) ...[
                        const Center(child: FgSpinner()),
                        Text(LocaleKeys.workoutSaving.tr()),
                      ] else if (_saveFailed)
                        FgEmpty(
                          icon: Icons.error_outline,
                          title: LocaleKeys.workoutSaveFailed.tr(),
                          tone: FgEmptyTone.error,
                          actionLabel: LocaleKeys.practiceRetry.tr(),
                          onAction: _handleCompletion,
                        )
                      else
                        _WorkoutComplete(
                          wod: wod,
                          xpAwarded: _xpAwarded,
                          streak:
                              ref.watch(userStatsProvider).value?.streakCount ??
                              0,
                          projectionHealth: state.projectionHealth,
                        ),
                    ] else ...[
                      FgRoundPanel(
                        active: true,
                        label: LocaleKeys.exerciseOf.tr(
                          args: [
                            '${_activeExerciseIndex + 1}',
                            '${wod.exercises.length}',
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              wod.exercises[_activeExerciseIndex].name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            FgTimerControl(
                              remaining: _timeLeft,
                              total:
                                  wod.exercises[_activeExerciseIndex].seconds,
                              running: _isTimerRunning,
                              actionLabel:
                                  (_timeLeft == 0
                                          ? LocaleKeys.timerComplete
                                          : _isTimerRunning
                                          ? LocaleKeys.pauseTimer
                                          : LocaleKeys.startTimer)
                                      .tr(),
                              semanticLabel: LocaleKeys
                                  .workoutTimerToggleSemantic
                                  .tr(args: ['$_timeLeft']),
                              onToggle: _toggleTimer,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(LocaleKeys.workoutWrittenCues.tr()),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              (_isLocked(wod)
                                      ? LocaleKeys.exerciseTimerInstruction
                                      : _skippedExercises.contains(
                                          _activeExerciseIndex,
                                        )
                                      ? LocaleKeys.exerciseSkippedReady
                                      : LocaleKeys.exerciseTimerComplete)
                                  .tr(),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            FgButton(
                              text: LocaleKeys.skip.tr(),
                              variant: FgButtonVariant.secondary,
                              onPressed: _isLocked(wod)
                                  ? () => _skipCurrentExercise(wod)
                                  : null,
                              semanticLabel: LocaleKeys.skipExerciseSemantic.tr(
                                args: [
                                  '${_activeExerciseIndex + 1}',
                                  '${wod.exercises.length}',
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                top: false,
                minimum: AppSpacing.allLG,
                child: _NavigationControls(
                  currentPage: _currentPage,
                  totalPages: _totalPageCount(wod),
                  isComplete: complete,
                  nextLocked: _isLocked(wod),
                  completing: _saving,
                  onPrevious: _saving || complete
                      ? null
                      : () {
                          if (_currentPage == 1 && widget.startImmediately) {
                            _close(context);
                          } else {
                            _previousPage();
                          }
                        },
                  onNext: _saving || _saveFailed
                      ? null
                      : complete
                      ? () => _close(context)
                      : () => _nextPage(wod),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      }
      if (_timeLeft <= 0) {
        _completedExercises.add(_activeExerciseIndex);
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    if (mounted) setState(() => _isTimerRunning = false);
  }

  void _toggleTimer() {
    if (!_isExercise(ref.read(workoutViewModelProvider).value!.wod)) return;
    HapticFeedback.selectionClick();
    if (_timeLeft <= 0) return;
    if (_isTimerRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _clearFeedback() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.removeCurrentSnackBar();
  }

  void _previousPage() {
    if (_confirmingExit || _saving) return;
    _clearFeedback();
    if (_currentPage <= 0) return;
    HapticFeedback.lightImpact();
    _timer?.cancel();
    if (_contentScrollController.hasClients) _contentScrollController.jumpTo(0);
    setState(() {
      _currentPage--;
      _timeLeft = 0;
      _isTimerRunning = false;
    });
    if (_isIntro && widget.startImmediately) {
      (widget.onClose ?? () => Navigator.of(context).pop())();
      return;
    }
    _initializeTimerIfNeeded(ref.read(workoutViewModelProvider).value!.wod);
  }

  void _nextPage(Workout wod) {
    if (_confirmingExit || _saving) return;
    if (_isLocked(wod)) {
      _showLockedFeedback();
      return;
    }
    _goToPage(_currentPage + 1, wod);
  }

  void _goToPage(int page, Workout wod) {
    if (_confirmingExit || _saving) return;
    _clearFeedback();
    if (page <= _currentPage) {
      while (_currentPage > page) {
        _previousPage();
      }
      return;
    }
    if (_isLocked(wod) && page > _currentPage) {
      _showLockedFeedback();
      return;
    }
    HapticFeedback.lightImpact();
    _timer?.cancel();
    if (_contentScrollController.hasClients) _contentScrollController.jumpTo(0);
    setState(() {
      _currentPage = page.clamp(0, _totalPageCount(wod) - 1);
      _timeLeft = 0;
      _isTimerRunning = false;
    });
    _initializeTimerIfNeeded(wod);
    if (_isComplete(wod)) {
      _handleCompletion();
    }
  }

  void _skipCurrentExercise(Workout wod, {int? expectedPage}) {
    if (!mounted ||
        _confirmingExit ||
        _saving ||
        _allowExit ||
        !_isExercise(wod) ||
        (expectedPage != null && expectedPage != _currentPage)) {
      return;
    }
    final exerciseIndex = _activeExerciseIndex;
    setState(() => _skippedExercises.add(exerciseIndex));
    _goToPage(_currentPage + 1, wod);
  }

  void _showLockedFeedback() {
    final wod = ref.read(workoutViewModelProvider).value?.wod;
    if (wod == null) return;

    final originatingPage = _currentPage;
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      FgSnackBar.build(
        context,
        text: LocaleKeys.completeTimerToContinue.tr(),
        tone: FgSnackBarTone.warning,
        actionLabel: LocaleKeys.skip.tr().toUpperCase(),
        onAction: () =>
            _skipCurrentExercise(wod, expectedPage: originatingPage),
      ),
    );
  }

  void _initializeTimerIfNeeded(Workout wod) {
    if (!_isExercise(wod)) return;
    if (_completedExercises.contains(_activeExerciseIndex) ||
        _skippedExercises.contains(_activeExerciseIndex)) {
      _timeLeft = 0;
      return;
    }
    final seconds = wod.exercises[_activeExerciseIndex].seconds;
    if (_timeLeft <= 0 || _timeLeft > seconds) _timeLeft = seconds;
  }

  Future<void> _handleCompletion() async {
    if (_saving || (_completionHandled && !_saveFailed)) return;
    setState(() {
      _saving = true;
      _saveFailed = false;
    });
    try {
      final awarded = await ref
          .read(workoutViewModelProvider.notifier)
          .completeWod();
      if (!mounted) return;
      setState(() {
        _completionHandled = true;
        _xpAwarded = awarded;
      });
    } catch (_) {
      if (mounted) setState(() => _saveFailed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  int _totalPageCount(Workout wod) => wod.exercises.length + 2;

  bool get _isIntro => _currentPage == 0;
  bool _isComplete(Workout wod) => _currentPage == _totalPageCount(wod) - 1;
  bool _isExercise(Workout wod) => !_isIntro && !_isComplete(wod);
  int get _activeExerciseIndex => _currentPage - 1;

  bool _isLocked(Workout wod) =>
      _isExercise(wod) &&
      _timeLeft > 0 &&
      !_completedExercises.contains(_activeExerciseIndex) &&
      !_skippedExercises.contains(_activeExerciseIndex);
}

class _WorkoutComplete extends StatelessWidget {
  const _WorkoutComplete({
    required this.wod,
    required this.xpAwarded,
    required this.streak,
    required this.projectionHealth,
  });

  final Workout wod;
  final bool xpAwarded;
  final int streak;
  final ProjectionHealth projectionHealth;

  @override
  Widget build(BuildContext context) {
    final rewardText = projectionHealth == ProjectionHealth.pendingRepair
        ? LocaleKeys.statsSyncing.tr()
        : xpAwarded
        ? LocaleKeys.youEarnedXp.tr(args: ['${wod.xp}'])
        : LocaleKeys.alreadyCompletedToday.tr();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FgIcon(
          icon: Icons.check_circle_outline_rounded,
          size: AppSizes.iconHuge,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          LocaleKeys.sessionComplete.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(color: context.forgeForeground),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          rewardText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: context.forgeForeground),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (streak > 0)
          Text(
            LocaleKeys.dayStreakKeepUp.tr(args: ['$streak']),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: context.forgeMutedForeground),
          ),
      ],
    );
  }
}

class _NavigationControls extends StatelessWidget {
  const _NavigationControls({
    required this.currentPage,
    required this.totalPages,
    required this.isComplete,
    required this.nextLocked,
    required this.completing,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final bool isComplete;
  final bool nextLocked;
  final bool completing;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final exerciseCount = totalPages - 2;
    final exerciseStep = (currentPage - 1).clamp(0, exerciseCount - 1);
    final stepLabel = isComplete
        ? LocaleKeys.sessionComplete.tr()
        : LocaleKeys.workoutStepOf.tr(
            args: ['${exerciseStep + 1}', '$exerciseCount'],
          );
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft):
            _PreviousWorkoutStepIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight):
            _NextWorkoutStepIntent(),
      },
      child: Actions(
        actions: {
          _PreviousWorkoutStepIntent:
              CallbackAction<_PreviousWorkoutStepIntent>(
                onInvoke: (_) {
                  onPrevious?.call();
                  return null;
                },
              ),
          _NextWorkoutStepIntent: CallbackAction<_NextWorkoutStepIntent>(
            onInvoke: (_) {
              onNext?.call();
              return null;
            },
          ),
        },
        child: FgStepNavigation(
          currentStep: exerciseStep,
          stepCount: exerciseCount,
          stepLabel: stepLabel,
          nextLabel: (isComplete ? LocaleKeys.finish : LocaleKeys.nextStep)
              .tr(),
          previousSemanticLabel: LocaleKeys.previousStepSemantic.tr(
            args: ['${currentPage + 1}', '$totalPages'],
          ),
          nextSemanticLabel: nextLocked
              ? LocaleKeys.nextLockedSemantic.tr()
              : isComplete
              ? LocaleKeys.finish.tr()
              : LocaleKeys.nextStepSemantic.tr(
                  args: ['${currentPage + 1}', '$totalPages'],
                ),
          onPrevious: onPrevious,
          onNext: onNext,
          nextLoading: completing,
        ),
      ),
    );
  }
}

class _PreviousWorkoutStepIntent extends Intent {
  const _PreviousWorkoutStepIntent();
}

class _NextWorkoutStepIntent extends Intent {
  const _NextWorkoutStepIntent();
}
