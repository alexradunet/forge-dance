import 'package:flutter/material.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/atoms/buttons/fg_button.dart';

enum TrainingSessionState { intro, active, complete }

class TrainingSessionPage extends StatefulWidget {
  final VoidCallback? onClose;

  const TrainingSessionPage({super.key, this.onClose});

  @override
  State<TrainingSessionPage> createState() => _TrainingSessionPageState();
}

class _TrainingSessionPageState extends State<TrainingSessionPage> {
  TrainingSessionState _state = TrainingSessionState.intro;
  int _currentExerciseIndex = 0;
  final int _totalExercises = 4;
  bool _isTimerRunning = false;
  int _timeLeft = 45; // Mock timer

  void _startWorkout() {
    setState(() {
      _state = TrainingSessionState.active;
      _currentExerciseIndex = 0;
    });
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _totalExercises - 1) {
      setState(() {
        _currentExerciseIndex++;
        _timeLeft = 45; // Reset mock timer
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _state = TrainingSessionState.complete;
      });
    }
  }

  void _prevExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _timeLeft = 45;
        _isTimerRunning = false;
      });
    } else {
      // Back to intro? or do nothing
      setState(() {
        _state = TrainingSessionState.intro;
      });
    }
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If completed, maybe show a different screen or just the card?
    // Using the template for all states for consistency.

    return SwipeableCardScreenTemplate(
      title: 'Daily Practice',
      subtitle: _state == TrainingSessionState.complete
          ? 'Session Complete'
          : 'Body Control • 25 min',
      onBack: widget.onClose ?? () => Navigator.of(context).pop(),
      // Show progress only when active
      progressSteps:
          _state == TrainingSessionState.active ? _totalExercises : 0,
      currentStep: _currentExerciseIndex,
      onStepClick: _state == TrainingSessionState.active
          ? (index) {
              setState(() => _currentExerciseIndex = index);
            }
          : null,

      actionZone: _buildActionZone(),

      children: _buildCentralCard(),
    );
  }

  Widget _buildCentralCard() {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildCardContent(),
      ),
    );
  }

  Widget _buildCardContent() {
    if (_state == TrainingSessionState.intro) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?q=80&w=2069&auto=format&fit=crop',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.forgeFire,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'WORKOUT OF THE DAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'BODY CONTROL',
                  style: AppTypography.h1
                      .copyWith(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Master your movement with this fundamental sequence designed to improve awareness and stability.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );
    } else if (_state == TrainingSessionState.complete) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 80, color: AppColors.forgeFire),
            const SizedBox(height: 24),
            Text(
              'SESSION COMPLETE',
              style: AppTypography.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Great work! You\'ve completed today\'s training.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    } else {
      // Active State - Exercise Card
      return Stack(
        fit: StackFit.expand,
        children: [
          // Background (could vary per exercise)
          Container(
            color: AppColors.surfaceDark,
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXERCISE ${_currentExerciseIndex + 1}',
                      style: const TextStyle(
                          color: AppColors.forgeFire,
                          fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.info_outline, color: Colors.white54),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _getExerciseName(_currentExerciseIndex),
                  style: AppTypography.h2.copyWith(color: Colors.white),
                ),

                const Spacer(),

                // Timer / Reps Center
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.forgeFire.withOpacity(0.3),
                          width: 4),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_timeLeft',
                            style: const TextStyle(
                              fontFamily: 'Bebas Neue',
                              fontSize: 80,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          const Text(
                            'SECONDS',
                            style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                                letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Footer
                Center(
                  child: Text(
                    _isTimerRunning ? 'STAY FOCUSED' : 'TAP TO START',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget? _buildActionZone() {
    if (_state == TrainingSessionState.intro) {
      return FgButton(
        text: 'START SESSION',
        variant: FgButtonVariant.primary,
        width: double.infinity,
        onPressed: _startWorkout,
      );
    } else if (_state == TrainingSessionState.complete) {
      return FgButton(
        text: 'FINISH',
        variant: FgButtonVariant.primary,
        width: double.infinity,
        onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
      );
    } else {
      // Active Controls
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _prevExercise,
              icon: const Icon(Icons.skip_previous, color: Colors.white),
              iconSize: 32,
            ),

            // Play/Pause
            GestureDetector(
              onTap: _toggleTimer,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.forgeFire,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forgeFire.withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Icon(
                  _isTimerRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),

            IconButton(
              onPressed: _nextExercise,
              icon: const Icon(Icons.skip_next, color: Colors.white),
              iconSize: 32,
            ),
          ],
        ),
      );
    }
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
