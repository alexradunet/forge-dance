import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../organisms/navigation/app_header.dart';
import '../atoms/visuals/fg_background.dart';

class SwipeableCardScreenTemplate extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? headerLeft;
  final Widget? headerRight;
  final int progressSteps;
  final int currentStep;
  final ValueChanged<int>? onStepClick;
  final Widget children;
  final Widget? actionZone;
  final VoidCallback? onBack;
  final bool useFullWidth;
  final List<Color>? customStepColors;

  const SwipeableCardScreenTemplate({
    super.key,
    required this.title,
    this.subtitle,
    this.headerLeft,
    this.headerRight,
    this.progressSteps = 0,
    this.currentStep = 0,
    this.onStepClick,
    required this.children,
    this.actionZone,
    this.onBack,
    this.useFullWidth = false,
    this.customStepColors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: title,
              subtitle: subtitle,
              leftSlot: headerLeft,
              rightSlot: headerRight,
              onBack: onBack,
            ),

            // Progress Segments
            if (progressSteps > 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: List.generate(progressSteps, (index) {
                    final bool isActive = index == currentStep;
                    final bool isPast = index < currentStep;

                    // Determine color based on customStepColors if provided
                    Color stepColor;
                    if (customStepColors != null &&
                        index < customStepColors!.length) {
                      final customColor = customStepColors![index];
                      // If custom colors used:
                      // Active: Full Opacity
                      // Past/Future: Lower Opacity but visible to show the "Belt" color
                      stepColor =
                          isActive ? customColor : customColor.withOpacity(0.3);
                    } else {
                      // Default behavior (Workout style)
                      stepColor = isActive
                          ? AppColors.forgeFire
                          : isPast
                              ? Colors.white.withOpacity(0.4)
                              : Colors.white.withOpacity(0.1);
                    }

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onStepClick?.call(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 4,
                          decoration: BoxDecoration(
                            color: stepColor,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: (customStepColors != null &&
                                                  index <
                                                      customStepColors!.length
                                              ? customStepColors![index]
                                              : AppColors.forgeFire)
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                    )
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            // Main Content / Deck Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    useFullWidth ? 0 : 24, 24, useFullWidth ? 0 : 24, 0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: useFullWidth ? double.infinity : 500),
                    child: children,
                  ),
                ),
              ),
            ),

            // Action Zone
            if (actionZone != null) ...[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2), // y: 20 equivalent
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut, // spring-like bounce: 0
                    )),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Container(
                  key: ValueKey(actionZone
                      .hashCode), // Should ideally depend on content change or external state
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: actionZone,
                ),
              ),
              const SizedBox(height: 90),
            ] else
              const SizedBox(height: 100), // Height of BottomNav + some padding
          ],
        ),
      ),
    );
  }
}
