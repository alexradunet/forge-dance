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

/// The daily training session (WOD): purpose-built overview → timed exercise
/// steps with a timer/skip gate → purpose-built completion reward.
class TrainingSessionPage extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const TrainingSessionPage({super.key, this.onClose});

  @override
  ConsumerState<TrainingSessionPage> createState() =>
      _TrainingSessionPageState();
}

class _TrainingSessionPageState extends ConsumerState<TrainingSessionPage> {
  static const _wideMinWidth = 760.0;
  static const _wideMinHeight = 480.0;
  static const _contentMaxWidth = 520.0;
  static const _collapsedMediaHeight = 88.0;
  static const _expandedMediaMaxHeight = 320.0;
  static const _shortScreenHeight = 620.0;

  int _currentPage = 0;
  bool _isTimerRunning = false;
  int _timeLeft = 0;
  Timer? _timer;
  final Set<int> _skippedExercises = {};
  final Set<int> _completedExercises = {};
  bool _completionHandled = false;
  bool _xpAwarded = false;
  bool _mediaCollapsed = false;
  late final ScrollController _contentScrollController;

  @override
  void initState() {
    super.initState();
    _contentScrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _contentScrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_contentScrollController.hasClients || _mediaCollapsed) return;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (screenHeight <= _shortScreenHeight &&
        _contentScrollController.offset > 24) {
      setState(() => _mediaCollapsed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutViewModelProvider);
    final state = workoutState.value;

    if (state == null) {
      return Scaffold(
        body: FgBackground(
          child: workoutState.hasError
              ? FgEmpty(
                  icon: Icons.error_outline,
                  title: LocaleKeys.unexpectedErrorOccurred.tr(),
                  tone: FgEmptyTone.error,
                )
              : const Center(child: FgSpinner()),
        ),
      );
    }

    final wod = state.wod;
    _initializeTimerIfNeeded(wod);
    final totalPages = _totalPageCount(wod);
    final isComplete = _isComplete(wod);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth >= _wideMinWidth &&
                  constraints.maxHeight >= _wideMinHeight;
              return Column(
                children: [
                  AppHeader(
                    title: LocaleKeys.dailyPractice.tr(),
                    subtitle: isComplete
                        ? LocaleKeys.sessionComplete.tr()
                        : '${wod.title} • ${LocaleKeys.minutesCount.tr(args: ['${wod.estimatedMinutes}'])}',
                    onBack: widget.onClose ?? () => Navigator.of(context).pop(),
                  ),
                  _WorkoutProgressHeader(
                    currentPage: _currentPage,
                    totalPages: totalPages,
                    exerciseCount: wod.exercises.length,
                    onStepSelected: (index) => _goToPage(index + 1, wod),
                  ),
                  Expanded(
                    child: isWide
                        ? _WideWorkoutLayout(
                            media: _buildMediaPane(
                              wod,
                              expanded: true,
                              minHeight: 220,
                              maxHeight: _expandedMediaMaxHeight,
                            ),
                            content: _buildContentPanel(
                              wod,
                              projectionHealth: state.projectionHealth,
                              isWide: true,
                            ),
                          )
                        : _NarrowWorkoutLayout(
                            mediaCollapsed: _mediaCollapsed,
                            media: _buildMediaPane(
                              wod,
                              expanded: !_mediaCollapsed,
                              minHeight: _mediaCollapsed
                                  ? _collapsedMediaHeight
                                  : 104,
                              maxHeight: _mediaCollapsed
                                  ? _collapsedMediaHeight
                                  : (constraints.maxHeight * 0.34).clamp(
                                      112.0,
                                      _expandedMediaMaxHeight,
                                    ),
                            ),
                            onRestoreMedia: () =>
                                setState(() => _mediaCollapsed = false),
                            content: _buildContentPanel(
                              wod,
                              projectionHealth: state.projectionHealth,
                              isWide: false,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPane(
    Workout wod, {
    required bool expanded,
    required double minHeight,
    required double maxHeight,
  }) {
    final motion = context.forgeMotion;
    return AnimatedContainer(
      key: const ValueKey('workout-media-shell'),
      duration: motion.standard,
      curve: motion.enterCurve,
      constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        child: GestureDetector(
          key: const ValueKey('workout-media-swipe-zone'),
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity < 0) {
              _nextPage(wod);
            } else if (velocity > 0) {
              _previousPage();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              _WorkoutMediaVisual(isExercise: _isExercise(wod)),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.48),
                    ],
                  ),
                ),
              ),
              if (_isExercise(wod)) _buildTimerOverlay(wod),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: Text(
                  _mediaTitle(wod),
                  maxLines: expanded ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).forgeColors.onImmersive,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerOverlay(Workout wod) {
    final locked = _isLocked(wod);
    return Center(
      child: Semantics(
        button: true,
        enabled: true,
        label: LocaleKeys.workoutTimerToggleSemantic.tr(args: ['$_timeLeft']),
        child: ExcludeSemantics(
          child: FgButton(
            text: '${_timeLeft}s',
            semanticLabel: LocaleKeys.timerSeconds.tr(args: ['$_timeLeft']),
            shape: FgButtonShape.circle,
            size: FgButtonSize.xl,
            variant: _isTimerRunning || !locked
                ? FgButtonVariant.primary
                : FgButtonVariant.secondary,
            onPressed: _toggleTimer,
          ),
        ),
      ),
    );
  }

  Widget _buildContentPanel(
    Workout wod, {
    required ProjectionHealth projectionHealth,
    required bool isWide,
  }) {
    final content = AnimatedSwitcher(
      duration: context.forgeMotion.standard,
      switchInCurve: context.forgeMotion.enterCurve,
      switchOutCurve: context.forgeMotion.exitCurve,
      transitionBuilder: (child, animation) {
        if (MediaQuery.disableAnimationsOf(context)) return child;
        if (isWide) return FadeTransition(opacity: animation, child: child);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(_currentPage),
        child: _buildContentForPage(wod, projectionHealth),
      ),
    );

    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              key: const ValueKey('workout-content-scroll'),
              controller: isWide ? null : _contentScrollController,
              padding: EdgeInsets.all(isWide ? AppSpacing.xxl : AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                child: content,
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.fromLTRB(
              isWide ? AppSpacing.xxl : AppSpacing.lg,
              0,
              isWide ? AppSpacing.xxl : AppSpacing.lg,
              isWide ? AppSpacing.xxl : AppSpacing.sm,
            ),
            child: _NavigationControls(
              currentPage: _currentPage,
              totalPages: _totalPageCount(wod),
              isComplete: _isComplete(wod),
              nextLocked: _isLocked(wod),
              completing: false,
              onPrevious: _currentPage == 0 ? null : _previousPage,
              onNext: _isComplete(wod)
                  ? widget.onClose ?? () => Navigator.of(context).pop()
                  : () => _nextPage(wod),
              prominentNext: !isWide,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentForPage(Workout wod, ProjectionHealth projectionHealth) {
    if (_isIntro) {
      return _WorkoutOverview(wod: wod);
    }
    if (_isComplete(wod)) {
      final streak = ref.watch(userStatsProvider).value?.streakCount ?? 0;
      return _WorkoutComplete(
        wod: wod,
        xpAwarded: _xpAwarded,
        streak: streak,
        projectionHealth: projectionHealth,
      );
    }
    final exercise = wod.exercises[_activeExerciseIndex];
    return _ExerciseContent(
      exercise: exercise,
      exerciseNumber: _activeExerciseIndex + 1,
      exerciseCount: wod.exercises.length,
      isTimerComplete: !_isLocked(wod),
      wasSkipped: _skippedExercises.contains(_activeExerciseIndex),
      onSkip: () => _skipCurrentExercise(wod),
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

  void _previousPage() {
    if (_currentPage <= 0) return;
    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() {
      _currentPage--;
      _mediaCollapsed = false;
      _isTimerRunning = false;
    });
    _initializeTimerIfNeeded(ref.read(workoutViewModelProvider).value!.wod);
  }

  void _nextPage(Workout wod) {
    if (_isLocked(wod)) {
      _showLockedFeedback();
      return;
    }
    _goToPage(_currentPage + 1, wod);
  }

  void _goToPage(int page, Workout wod) {
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
    setState(() {
      _currentPage = page.clamp(0, _totalPageCount(wod) - 1);
      _mediaCollapsed = false;
      _isTimerRunning = false;
    });
    _initializeTimerIfNeeded(wod);
    if (_isComplete(wod)) {
      _handleCompletion();
    }
  }

  void _skipCurrentExercise(Workout wod) {
    final exerciseIndex = _activeExerciseIndex;
    if (exerciseIndex < 0) return;
    setState(() => _skippedExercises.add(exerciseIndex));
    _goToPage(_currentPage + 1, wod);
  }

  void _showLockedFeedback() {
    final wod = ref.read(workoutViewModelProvider).value?.wod;
    if (wod == null) return;

    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      FgSnackBar.build(
        context,
        text: LocaleKeys.completeTimerToContinue.tr(),
        tone: FgSnackBarTone.warning,
        actionLabel: LocaleKeys.skip.tr().toUpperCase(),
        onAction: () => _skipCurrentExercise(wod),
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
    if (_completionHandled) return;
    _completionHandled = true;

    final awarded = await ref
        .read(workoutViewModelProvider.notifier)
        .completeWod();
    if (!mounted) return;
    setState(() => _xpAwarded = awarded);
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

  String _mediaTitle(Workout wod) {
    if (_isIntro) return wod.title;
    if (_isComplete(wod)) return LocaleKeys.sessionComplete.tr();
    return wod.exercises[_activeExerciseIndex].name;
  }
}

class _WorkoutProgressHeader extends StatelessWidget {
  const _WorkoutProgressHeader({
    required this.currentPage,
    required this.totalPages,
    required this.exerciseCount,
    required this.onStepSelected,
  });

  final int currentPage;
  final int totalPages;
  final int exerciseCount;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final stepText = LocaleKeys.workoutStepOf.tr(
      args: ['${currentPage + 1}', '$totalPages'],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.sm,
        AppSpacing.xxl,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: FgProgressBar(
                  value: (currentPage + 1) / totalPages,
                  semanticLabel: stepText,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Text(
                stepText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).forgeColors.onImmersive,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var index = 0; index < exerciseCount; index++) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.sm),
                  Semantics(
                    button: true,
                    selected: currentPage == index + 1,
                    label: LocaleKeys.goToExerciseStep.tr(
                      args: ['${index + 1}'],
                    ),
                    child: ExcludeSemantics(
                      child: FgButton(
                        text: '${index + 1}',
                        variant: currentPage == index + 1
                            ? FgButtonVariant.primary
                            : FgButtonVariant.secondary,
                        size: FgButtonSize.sm,
                        shape: FgButtonShape.circle,
                        onPressed: () => onStepSelected(index),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WideWorkoutLayout extends StatelessWidget {
  const _WideWorkoutLayout({required this.media, required this.content});

  final Widget media;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        0,
        AppSpacing.xxl,
        AppSpacing.xxl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: Center(child: media)),
          const SizedBox(width: AppSpacing.xxl),
          Expanded(flex: 2, child: content),
        ],
      ),
    );
  }
}

class _NarrowWorkoutLayout extends StatelessWidget {
  const _NarrowWorkoutLayout({
    required this.mediaCollapsed,
    required this.media,
    required this.onRestoreMedia,
    required this.content,
  });

  final bool mediaCollapsed;
  final Widget media;
  final VoidCallback onRestoreMedia;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          media,
          if (mediaCollapsed) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: FgButton(
                text: LocaleKeys.restoreLessonMedia.tr(),
                icon: const Icon(Icons.expand_less_rounded),
                variant: FgButtonVariant.secondary,
                size: FgButtonSize.sm,
                onPressed: onRestoreMedia,
                semanticLabel: LocaleKeys.restoreLessonMediaSemantic.tr(),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _WorkoutMediaVisual extends StatelessWidget {
  const _WorkoutMediaVisual({required this.isExercise});

  final bool isExercise;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).forgeColors.immersiveSurface,
      ),
      child: FgImage(
        imageUrl: isExercise
            ? 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2000'
            : 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
        fit: isExercise ? BoxFit.contain : BoxFit.cover,
        placeholder: const _MediaFallbackIcon(),
        errorWidget: const _MediaFallbackIcon(),
      ),
    );
  }
}

class _MediaFallbackIcon extends StatelessWidget {
  const _MediaFallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.fitness_center_rounded,
          size: 180,
          color: Theme.of(context).forgeColors.onImmersive
              .withValues(alpha: 0.72),
        ),
      ),
    );
  }
}

class _WorkoutOverview extends StatelessWidget {
  const _WorkoutOverview({required this.wod});

  final Workout wod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(wod.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Text(
          wod.description,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _InfoRow(
          icon: Icons.fitness_center,
          text: LocaleKeys.exercisesCount.tr(args: ['${wod.exercises.length}']),
        ),
        _InfoRow(
          icon: Icons.timer,
          text: LocaleKeys.minutesCount.tr(args: ['${wod.estimatedMinutes}']),
        ),
        _InfoRow(
          icon: Icons.bolt,
          text: LocaleKeys.xpReward.tr(args: ['${wod.xp}']),
        ),
      ],
    );
  }
}

class _ExerciseContent extends StatelessWidget {
  const _ExerciseContent({
    required this.exercise,
    required this.exerciseNumber,
    required this.exerciseCount,
    required this.isTimerComplete,
    required this.wasSkipped,
    required this.onSkip,
  });

  final WorkoutExercise exercise;
  final int exerciseNumber;
  final int exerciseCount;
  final bool isTimerComplete;
  final bool wasSkipped;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FgLabel(
          text: LocaleKeys.exerciseOf.tr(
            args: ['$exerciseNumber', '$exerciseCount'],
          ),
          tone: FgLabelTone.accent,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(exercise.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Text(
          isTimerComplete
              ? (wasSkipped
                    ? LocaleKeys.exerciseSkippedReady.tr()
                    : LocaleKeys.exerciseTimerComplete.tr())
              : LocaleKeys.exerciseTimerInstruction.tr(),
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xxl),
        FgButton(
          text: LocaleKeys.skip.tr(),
          variant: FgButtonVariant.secondary,
          onPressed: isTimerComplete ? null : onSkip,
          semanticLabel: LocaleKeys.skipExerciseSemantic.tr(
            args: ['$exerciseNumber', '$exerciseCount'],
          ),
        ),
      ],
    );
  }
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
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          rewardText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (streak > 0)
          Text(
            LocaleKeys.dayStreakKeepUp.tr(args: ['$streak']),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          FgIcon(
            icon: icon,
            size: AppSizes.iconMd,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
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
    required this.prominentNext,
  });

  final int currentPage;
  final int totalPages;
  final bool isComplete;
  final bool nextLocked;
  final bool completing;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool prominentNext;

  @override
  Widget build(BuildContext context) {
    final nextLabel = isComplete
        ? LocaleKeys.finish.tr()
        : currentPage == 0
        ? LocaleKeys.startTraining.tr()
        : LocaleKeys.nextStep.tr();
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
        child: Row(
          children: [
            Flexible(
              child: FgButton(
                text: LocaleKeys.previousStep.tr(),
                variant: FgButtonVariant.secondary,
                onPressed: onPrevious,
                semanticLabel: LocaleKeys.previousStepSemantic.tr(
                  args: ['${currentPage + 1}', '$totalPages'],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: prominentNext ? 2 : 1,
              child: FgButton(
                text: nextLabel,
                variant: FgButtonVariant.primary,
                size: prominentNext ? FgButtonSize.xl : FgButtonSize.md,
                expand: true,
                isLoading: completing,
                onPressed: onNext,
                semanticLabel: nextLocked
                    ? LocaleKeys.nextLockedSemantic.tr()
                    : isComplete
                    ? LocaleKeys.finish.tr()
                    : LocaleKeys.nextStepSemantic.tr(
                        args: ['${currentPage + 1}', '$totalPages'],
                      ),
              ),
            ),
          ],
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
