import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/molecules/navigation/app_floating_action_bar.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/organisms/cards/app_workout_intro_card.dart';
import '../../../../design_system/organisms/cards/app_session_complete_card.dart';
import '../../../../design_system/design_system.dart';
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
  int _currentExercise = 0;
  final int _totalExercises = 5;

  void _startWorkout() {
    setState(() {
      _state = TrainingSessionState.active;
    });
  }

  void _finishWorkout() {
    setState(() {
      _state = TrainingSessionState.complete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          Column(
            children: [
              AppHeader(
                title: 'DAILY PRACTICE',
                subtitle: _state == TrainingSessionState.complete
                    ? 'Completed'
                    : 'Today\'s WOD',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: _buildMainContent(),
                ),
              ),
              const SizedBox(height: 100), // Space for FAB
            ],
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _buildFloatingAction(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_state) {
      case TrainingSessionState.intro:
        return const AppWorkoutIntroCard(
          title: 'Body Control',
          duration: '25 min',
          intensity: 'Medium',
          description:
              'Master your movement with this fundamental sequence designed to improve awareness and stability.',
        );
      case TrainingSessionState.active:
        return FgCarousel(
          viewportFraction: 1.0, // Or whatever the previous default was
          enableScaleEffect: true, // Assuming the deck had this
          items: List.generate(
            _totalExercises,
            (index) => const SizedBox.shrink(),
          ),
          onIndexChanged: (index) {
            setState(() {
              _currentExercise = index;
            });
          },
        );
      case TrainingSessionState.complete:
        return const AppSessionCompleteCard();
    }
  }

  Widget _buildFloatingAction() {
    switch (_state) {
      case TrainingSessionState.intro:
        return FgButton(
          text: 'START WORKOUT',
          variant: FgButtonVariant.primary,
          width: double.infinity,
          onPressed: _startWorkout,
        );
      case TrainingSessionState.active:
        final isLast = _currentExercise == _totalExercises - 1;
        return AppFloatingActionBar(
          children: [
            FgButton(
              text: 'PREV',
              variant: FgButtonVariant.ghost,
              isEnabled: _currentExercise > 0,
              onPressed: () {
                // In a real app, this would control the deck
              },
            ),
            FgButton(
              text: isLast ? 'FINISH' : 'NEXT',
              variant: FgButtonVariant.primary,
              onPressed: isLast
                  ? _finishWorkout
                  : () {
                      // In a real app, this would control the deck
                    },
            ),
          ],
        );
      case TrainingSessionState.complete:
        return FgButton(
          text: 'BACK TO HOME',
          variant: FgButtonVariant.primary,
          width: double.infinity,
          onPressed: () {
            if (widget.onClose != null) {
              widget.onClose!();
            } else {
              Navigator.pop(context);
            }
          },
        );
    }
  }
}
