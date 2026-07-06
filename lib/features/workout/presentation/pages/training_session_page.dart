import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../../design_system/molecules/cards/fg_interactive_card.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/atoms/buttons/fg_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/ui/widgets/common_error.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../model/workout.dart';
import '../../ui/state/workout_state.dart';
import '../../ui/view_model/workout_view_model.dart';

/// The daily training session (WOD): intro card → timed exercise cards with
/// the lock/skip mechanic → completion card. Completing the final page
/// persists the session and awards XP exactly once per day.
class TrainingSessionPage extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const TrainingSessionPage({super.key, this.onClose});

  @override
  ConsumerState<TrainingSessionPage> createState() =>
      _TrainingSessionPageState();
}

class _TrainingSessionPageState extends ConsumerState<TrainingSessionPage> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isTimerRunning = false;
  int _timeLeft = 45; // seconds; set per exercise on page change
  Timer? _timer;
  final Set<int> _skippedExercises = {};
  bool _completionHandled = false;
  bool _xpAwarded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _stopTimer();
        setState(() {
          // Timer finished, auto-unlock happens via state check
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _previousPage() {
    HapticFeedback.lightImpact();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage(Workout wod) {
    if (_isLocked(wod)) {
      _showLockedFeedback();
      return;
    }
    HapticFeedback.lightImpact();
    if (_currentPage < _totalPageCount(wod) - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  int _totalPageCount(Workout wod) =>
      wod.exercises.length + 2; // Intro + Exercises + Complete

  void _toggleTimer() {
    HapticFeedback.selectionClick();
    if (_isTimerRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _skipCurrentExercise(Workout wod) {
    final exerciseIndex = _activeExerciseIndex;
    if (exerciseIndex >= 0) {
      _skippedExercises.add(exerciseIndex);
      setState(() {}); // Trigger rebuild to unlock
      _nextPage(wod);
    }
  }

  // Helpers to map page index to logical state
  bool get _isIntro => _currentPage == 0;
  bool _isComplete(Workout wod) => _currentPage == _totalPageCount(wod) - 1;
  int get _activeExerciseIndex => _currentPage - 1;

  bool _isLocked(Workout wod) =>
      !_isIntro &&
      !_isComplete(wod) &&
      _timeLeft > 0 &&
      !_skippedExercises.contains(_activeExerciseIndex);

  Future<void> _handleCompletion() async {
    if (_completionHandled) return;
    _completionHandled = true;

    final awarded =
        await ref.read(workoutViewModelProvider.notifier).completeWod();
    if (!mounted) return;
    setState(() => _xpAwarded = awarded);
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutViewModelProvider);
    final state = workoutState.valueOrNull;

    if (state == null) {
      return Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: workoutState.hasError
            ? const CommonError()
            : const Center(child: FgSpinner()),
      );
    }

    final wod = state.wod;
    final isComplete = _isComplete(wod);
    final isLocked = _isLocked(wod);

    return SwipeableCardScreenTemplate(
      title: LocaleKeys.dailyPractice.tr(),
      subtitle: isComplete
          ? LocaleKeys.sessionComplete.tr()
          : '${wod.title} • ${wod.estimatedMinutes} min',
      onBack: widget.onClose ?? () => Navigator.of(context).pop(),
      headerLeft: isLocked
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _previousPage,
            )
          : null,
      progressSteps: wod.exercises.length,
      currentStep: _isIntro
          ? -1
          : (isComplete ? wod.exercises.length : _activeExerciseIndex),
      onStepClick: (index) {
        if (isLocked && index > _activeExerciseIndex) {
          _showLockedFeedback();
          return;
        }

        _pageController.animateToPage(
          index + 1, // Skip intro page
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      actionZone: null,
      children: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (!isLocked) return;

          // Velocity < 0 is Swipe Left (Next)
          if (details.primaryVelocity! < 0) {
            _showLockedFeedback();
          }
          // Velocity > 0 is Swipe Right (Back)
          else if (details.primaryVelocity! > 0) {
            _previousPage();
          }
        },
        child: PageView.builder(
          physics: isLocked
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
              final exerciseIndex = index - 1;
              if (exerciseIndex >= 0 &&
                  exerciseIndex < wod.exercises.length) {
                _timeLeft = wod.exercises[exerciseIndex].seconds;
              }
              _stopTimer();
            });
            if (index == _totalPageCount(wod) - 1) {
              _handleCompletion();
            }
          },
          itemCount: _totalPageCount(wod),
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: _buildCardForIndex(index, state),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLockedFeedback() {
    final wod = ref.read(workoutViewModelProvider).valueOrNull?.wod;
    if (wod == null) return;

    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.forgeFire),
            const SizedBox(width: 12),
            Expanded(child: Text(LocaleKeys.completeTimerToContinue.tr())),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _skipCurrentExercise(wod);
              },
              child: Text(LocaleKeys.skip.tr().toUpperCase(),
                  style: const TextStyle(color: AppColors.forgeFire)),
            )
          ],
        ),
        backgroundColor: Colors.grey[900],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCardForIndex(int index, WorkoutState state) {
    final wod = state.wod;

    if (index == 0) {
      return _buildIntroCard(wod);
    }
    if (index == _totalPageCount(wod) - 1) {
      return _buildCompleteCard(wod);
    }
    return _buildExerciseCard(wod, index - 1);
  }

  Widget _buildIntroCard(Workout wod) {
    return FgInteractiveCard(
      title: wod.title.toUpperCase(),
      subtitle: LocaleKeys.wodTag.tr().toUpperCase(),
      backgroundImage: wod.imageUrl,
      style: wod.style,
      difficulty: wod.difficulty,
      progress: 0,
      backTitle: LocaleKeys.workoutOverview.tr().toUpperCase(),
      backSubtitle: wod.style,
      backContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wod.description,
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
            Icons.fitness_center,
            LocaleKeys.exercisesCount
                .tr(args: ['${wod.exercises.length}']).toUpperCase(),
          ),
          _buildInfoRow(
            Icons.timer,
            LocaleKeys.minutesCount
                .tr(args: ['${wod.estimatedMinutes}']).toUpperCase(),
          ),
          _buildInfoRow(
            Icons.bolt,
            LocaleKeys.xpReward.tr(args: ['${wod.xp}']).toUpperCase(),
          ),
        ],
      ),
      footer: SizedBox(
        width: double.infinity,
        child: FgButton(
          text: LocaleKeys.startTraining.tr(),
          variant: FgButtonVariant.primary,
          onPressed: () => _nextPage(wod),
        ),
      ),
    );
  }

  Widget _buildCompleteCard(Workout wod) {
    final streak =
        ref.watch(userStatsProvider).valueOrNull?.streakCount ?? 0;

    return FgInteractiveCard(
      title: LocaleKeys.sessionComplete.tr().toUpperCase(),
      subtitle: LocaleKeys.greatWork.tr().toUpperCase(),
      backgroundImage:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
      style: wod.style,
      difficulty: 'Complete',
      progress: 1.0,
      backTitle: LocaleKeys.statsSummary.tr().toUpperCase(),
      backSubtitle: LocaleKeys.dailyPractice.tr(),
      backContent: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 60, color: AppColors.forgeFire),
            const SizedBox(height: 16),
            Text(
              _xpAwarded
                  ? LocaleKeys.youEarnedXp.tr(args: ['${wod.xp}'])
                  : LocaleKeys.alreadyCompletedToday.tr(),
              textAlign: TextAlign.center,
              style: AppTypography.h3.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            if (streak > 0)
              Text(
                LocaleKeys.dayStreakKeepUp.tr(args: ['$streak']),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60),
              ),
          ],
        ),
      ),
      footer: SizedBox(
        width: double.infinity,
        child: FgButton(
          text: LocaleKeys.finish.tr(),
          variant: FgButtonVariant.primary,
          onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Workout wod, int exerciseIndex) {
    final exercise = wod.exercises[exerciseIndex];

    return FgInteractiveCard(
      title: exercise.name,
      subtitle: LocaleKeys.exerciseOf.tr(args: [
        '${exerciseIndex + 1}',
        '${wod.exercises.length}',
      ]).toUpperCase(),
      backgroundImage:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2000',
      style: wod.style,
      difficulty: 'Active',
      progress: (exerciseIndex + 1) / wod.exercises.length,
      centerOverlay: GestureDetector(
        onTap: _toggleTimer,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isTimerRunning ? AppColors.forgeFire : Colors.white,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${_timeLeft}s',
              style: AppTypography.h3.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      footer: null,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.forgeFire),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
