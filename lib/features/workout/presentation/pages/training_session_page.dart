import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../design_system/molecules/cards/fg_interactive_card.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/atoms/buttons/fg_button.dart';

class TrainingSessionPage extends StatefulWidget {
  final VoidCallback? onClose;

  const TrainingSessionPage({super.key, this.onClose});

  @override
  State<TrainingSessionPage> createState() => _TrainingSessionPageState();
}

class _TrainingSessionPageState extends State<TrainingSessionPage> {
  late final PageController _pageController;
  int _currentPage = 0;
  final int _totalExercises = 4; // Mock data count
  bool _isTimerRunning = false;
  int _timeLeft = 45; // seconds
  Timer? _timer;
  final Set<int> _skippedExercises = {};

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

  void _nextPage() {
    if (_isLocked) {
      _showLockedFeedback();
      return;
    }
    Element? element = context as Element?;
    if (element == null || !element.mounted) return;

    HapticFeedback.lightImpact();
    if (_currentPage < _totalPageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  int get _totalPageCount =>
      _totalExercises + 2; // Intro + Exercises + Complete

  void _toggleTimer() {
    HapticFeedback.selectionClick();
    if (_isTimerRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _skipCurrentExercise() {
    final exerciseIndex = _activeExerciseIndex;
    if (exerciseIndex >= 0) {
      _skippedExercises.add(exerciseIndex);
      setState(() {}); // Trigger rebuild to unlock

      // Optional: Auto-advance after skip?
      // _nextPage();
      // User asked "acknowledge the skip", implies unlocking is enough,
      // but typically "Skip" means "Next". I'll start with just Unlock + Visual Feedback.
      // Actually, "acknowledge the skip" to me means "Unlock".
      // Let's make it Unlock AND Advance.
      _nextPage();
    }
  }

  // Helper to map page index to logical state
  bool get _isIntro => _currentPage == 0;
  bool get _isComplete => _currentPage == _totalPageCount - 1;
  int get _activeExerciseIndex => _currentPage - 1;

  bool get _isLocked =>
      !_isIntro &&
      !_isComplete &&
      _timeLeft > 0 &&
      !_skippedExercises.contains(_activeExerciseIndex);

  @override
  Widget build(BuildContext context) {
    return SwipeableCardScreenTemplate(
      title: 'Daily Practice',
      subtitle: _isComplete ? 'Session Complete' : 'Body Control • 25 min',
      onBack: widget.onClose ?? () => Navigator.of(context).pop(),
      headerLeft: _isLocked
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _previousPage,
            )
          : null,
      // Progress calculation:
      // Intro: -1 (Hidden/Empty)
      // Active: 0 to _totalExercises - 1
      // Complete: _totalExercises (Full)
      progressSteps: _totalExercises,
      currentStep: _isIntro
          ? -1
          : (_isComplete ? _totalExercises : _activeExerciseIndex),
      onStepClick: (index) {
        if (_isLocked && index > _activeExerciseIndex) {
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
          if (!_isLocked) return;

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
          physics: _isLocked
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
              if (!_skippedExercises.contains(index - 1)) {
                _timeLeft = 45;
              } else {
                _timeLeft = 45;
              }
              _stopTimer();
            });
          },
          itemCount: _totalPageCount,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: _buildCardForIndex(index),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLockedFeedback() {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.forgeFire),
            const SizedBox(width: 12),
            const Expanded(child: Text('Complete the timer to continue!')),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _skipCurrentExercise();
              },
              child: const Text('SKIP',
                  style: TextStyle(color: AppColors.forgeFire)),
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

  Widget _buildCardForIndex(int index) {
    if (index == 0) {
      // INTRO CARD
      return FgInteractiveCard(
        title: 'BODY CONTROL',
        subtitle: 'WORKOUT OF THE DAY',
        backgroundImage:
            'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?q=80&w=2069&auto=format&fit=crop',
        style: 'Modern',
        difficulty: 'Intermediate',
        progress: 0,
        backTitle: 'WORKOUT OVERVIEW',
        backSubtitle: 'Technique Goals',
        backContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Master your movement with this fundamental sequence designed to improve awareness and stability.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.fitness_center, '5 EXERCISES'),
            _buildInfoRow(Icons.timer, '25 MINUTES'),
            _buildInfoRow(Icons.bolt, '350 CALORIES'),
          ],
        ),
        footer: SizedBox(
          width: double.infinity,
          child: FgButton(
            text: 'START TRAINING',
            variant: FgButtonVariant.primary,
            onPressed: _nextPage,
          ),
        ),
      );
    } else if (index == _totalPageCount - 1) {
      // COMPLETE CARD
      return FgInteractiveCard(
        title: 'SESSION COMPLETE',
        subtitle: 'GREAT WORK!',
        backgroundImage:
            'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
        style: 'Training',
        difficulty: 'Complete',
        progress: 1.0,
        backTitle: 'STATS SUMMARY',
        backSubtitle: 'Daily Progress',
        backContent: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 60, color: AppColors.forgeFire),
              const SizedBox(height: 16),
              Text('You earned 500 XP!',
                  style: AppTypography.h3.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Keep it up for a 3-day streak!',
                  style: TextStyle(color: Colors.white60)),
            ],
          ),
        ),
        footer: SizedBox(
          width: double.infinity,
          child: FgButton(
            text: 'FINISH',
            variant: FgButtonVariant.primary,
            onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else {
      // ACTIVE EXERCISE CARD
      final exerciseIndex = index - 1;
      return FgInteractiveCard(
        title: _getExerciseName(exerciseIndex),
        subtitle: 'EXERCISE ${exerciseIndex + 1} OF $_totalExercises',
        backgroundImage:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2000',
        style: 'Drill',
        difficulty: 'Active',
        progress: (exerciseIndex + 1) / _totalExercises,
        onPlayTap: _toggleTimer,
        isPlaying: _isTimerRunning,
        backTitle: 'INSTRUCTIONS',
        backSubtitle: 'Proper Form',
        backContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Focus on controlled movements and steady breathing.',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            Text('1. Start in a neutral position',
                style: AppTypography.bodySmall.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Text('2. Engage your core',
                style: AppTypography.bodySmall.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Text('3. Follow through with intentionality',
                style: AppTypography.bodySmall.copyWith(color: Colors.white)),
          ],
        ),
        footer: Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: _toggleTimer,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isTimerRunning
                        ? AppColors.forgeFire.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isTimerRunning
                          ? AppColors.forgeFire
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isTimerRunning ? Icons.pause : Icons.play_arrow,
                        color: _isTimerRunning
                            ? AppColors.forgeFire
                            : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_timeLeft}s',
                        style: AppTypography.h4.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('STEP',
                      style: AppTypography.label
                          .copyWith(fontSize: 10, color: Colors.white54)),
                  Text('${exerciseIndex + 1} / $_totalExercises',
                      style: AppTypography.h5
                          .copyWith(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: _nextPage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.skip_next,
                      color: Colors.white, size: 20),
                )),
          ],
        ),
      );
    }
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

  String _getExerciseName(int index) {
    const names = [
      'Top Rock Basic',
      'Indian Step',
      '6-Step Drill',
      'Baby Freeze Hold'
    ];
    if (index >= 0 && index < names.length) return names[index];
    return 'Freestyle';
  }
}
