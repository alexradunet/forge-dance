import 'package:flutter/material.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';

class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  @override
  Widget build(BuildContext context) {
    return SwipeableCardScreenTemplate(
      title: 'Groove Basics',
      subtitle: 'Lesson 2 • Movement',
      onBack: () => Navigator.of(context).pop(),
      progressSteps: _totalSteps,
      currentStep: _currentStep,
      onStepClick: (index) {
        setState(() {
          _currentStep = index;
        });
      },
      // Action Zone (Bottom Controls)
      actionZone: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _currentStep > 0
                  ? () => setState(() => _currentStep--)
                  : null,
              icon: Icon(
                Icons.arrow_back_ios,
                color: _currentStep > 0
                    ? Colors.white
                    : Colors.white.withOpacity(0.2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.forgeFire,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                _currentStep == _totalSteps - 1 ? 'COMPLETE' : 'NEXT STEP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            IconButton(
              onPressed: _currentStep < _totalSteps - 1
                  ? () => setState(() => _currentStep++)
                  : null,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: _currentStep < _totalSteps - 1
                    ? Colors.white
                    : Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),

      // Main Content (Card Placeholder)
      children: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4, // Card ratio
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder Image
                  Image.network(
                    'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                  ),

                  // Content Overlay
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.forgeFire,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'STEP ${_currentStep + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getStepTitle(_currentStep),
                          style: AppTypography.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Follow the rhythm and stay loose. This fundamental movement is key to your flow.',
                          style: AppTypography.body
                              .copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
