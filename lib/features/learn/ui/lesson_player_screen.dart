import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/molecules/cards/fg_interactive_card.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/tokens/app_spacing.dart';

class LessonPlayerScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LessonPlayerScreen({super.key, this.onBack});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeableCardScreenTemplate(
      title: 'Groove Basics',
      subtitle: 'Lesson 2 • Movement',
      onBack: widget.onBack ?? () => Navigator.of(context).pop(),
      progressSteps: _totalSteps,
      currentStep: _currentStep,
      useFullWidth: false,
      onStepClick: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      // children is now a PageView
      children: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentStep = index;
          });
        },
        itemCount: _totalSteps,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: FgInteractiveCard(
                title: _getStepTitle(index),
                subtitle: 'STEP ${index + 1}',
                backgroundImage:
                    'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
                style: 'Groove',
                difficulty: 'Beginner',
                progress: (index + 1) / _totalSteps,
                backTitle: 'STEP DETAILS',
                backSubtitle: 'Technique Breakdown',
                backContent: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Follow the rhythm and stay loose. This fundamental movement is key to your flow.',
                      style: AppTypography.bodySmall
                          .copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    _buildTechniquePoint(
                        'Focus', 'Keep your knees slightly bent and relaxed.'),
                    _buildTechniquePoint('Breath', 'Exhale on the downbeat.'),
                    _buildTechniquePoint(
                        'Energy', 'Direct your power from the core.'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTechniquePoint(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.label.copyWith(
              color: AppColors.forgeFire,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'FIND THE BEAT';
      case 1:
        return 'BOUNCE TECHNIQUE';
      case 2:
        return 'ARM SWING';
      case 3:
        return 'FULL GROOVE';
      default:
        return 'READY';
    }
  }
}
