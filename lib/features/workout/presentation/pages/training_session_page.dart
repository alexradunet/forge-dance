import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../design_system/organisms/cards/app_interactive_card.dart';
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
    HapticFeedback.mediumImpact();
    setState(() {
      _state = TrainingSessionState.active;
      _currentExerciseIndex = 0;
    });
  }

  void _nextExercise() {
    HapticFeedback.lightImpact();
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

  void _toggleTimer() {
    HapticFeedback.selectionClick();
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwipeableCardScreenTemplate(
      title: 'Daily Practice',
      subtitle: _state == TrainingSessionState.complete
          ? 'Session Complete'
          : 'Body Control • 25 min',
      onBack: widget.onClose ?? () => Navigator.of(context).pop(),
      progressSteps: _totalExercises,
      currentStep: _state == TrainingSessionState.intro
          ? -1
          : (_state == TrainingSessionState.complete
              ? _totalExercises
              : _currentExerciseIndex),
      onStepClick: null,
      actionZone: null, // Controls now inside cards
      children: _buildCentralCard(),
    );
  }

  Widget _buildCentralCard() {
    return SizedBox(
      height: double.infinity,
      child: _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    if (_state == TrainingSessionState.intro) {
      return AppInteractiveCard(
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
            text: 'START SESSION',
            variant: FgButtonVariant.primary,
            onPressed: _startWorkout,
          ),
        ),
      );
    } else if (_state == TrainingSessionState.complete) {
      return AppInteractiveCard(
        title: 'SESSION COMPLETE',
        subtitle: 'GREAT WORK!',
        backgroundImage:
            'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
        style: 'Training',
        difficulty: 'Complete',
        progress: 1.0,
        backTitle: 'STATS SUMMARY',
        backSubtitle: 'Daily Progress',
        // COMPLETE STATE
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
      // Active State - Exercise Card
      return AppInteractiveCard(
        title: _getExerciseName(_currentExerciseIndex),
        subtitle: 'EXERCISE ${_currentExerciseIndex + 1} OF $_totalExercises',
        backgroundImage:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2000',
        style: 'Drill',
        difficulty: 'Active',
        progress: (_currentExerciseIndex + 1) / _totalExercises,
        onPlayTap: _toggleTimer,
        isPlaying: _isTimerRunning,
        backTitle: 'INSTRUCTIONS',
        backSubtitle: 'Proper Form',
        // ACTIVE STATE
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
            // Removed Spacer/TimeLeft from back content as it's now in footer
          ],
        ),
        footer: Row(
          children: [
            // Timer Toggle
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
                        '$_timeLeft s',
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
            // Info / Step
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('STEP',
                      style: AppTypography.label
                          .copyWith(fontSize: 10, color: Colors.white54)),
                  Text('${_currentExerciseIndex + 1} / $_totalExercises',
                      style: AppTypography.h5
                          .copyWith(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Next Button
            GestureDetector(
                onTap: _nextExercise,
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
