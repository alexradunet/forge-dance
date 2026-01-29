import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_border_radius.dart';
import '../../tokens/app_animation.dart';

/// Theory Deck Card - Interactive flashcard-style lesson card
/// Based on HTML mockup: forge_theory__interactive_deck (Beat Tap, Creative Experiment)
/// Shows stacked deck effect with progress indicators and hero content
class TheoryDeckCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? moduleLabel;
  final String moduleName;
  final int currentStep;
  final int totalSteps;
  final Widget? heroContent;
  final Widget? bottomContent;
  final Color accentColor;
  final VoidCallback? onFlip;

  const TheoryDeckCard({
    super.key,
    required this.title,
    this.subtitle,
    this.moduleLabel,
    required this.moduleName,
    this.currentStep = 1,
    this.totalSteps = 5,
    this.heroContent,
    this.bottomContent,
    this.accentColor = AppColors.forgeFire,
    this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: List.generate(
              totalSteps,
              (index) {
                final isActive = index == currentStep - 1;
                final isCompleted = index < currentStep - 1;
                return Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.only(
                      right: index < totalSteps - 1 ? 8 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? accentColor
                          : isCompleted
                              ? accentColor.withAlpha((0.3 * 255).round())
                              : AppColors.crystalWhite.withAlpha((0.2 * 255).round()),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: accentColor.withAlpha((0.5 * 255).round()),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Card stack
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background card (deepest)
              Positioned(
                top: 16,
                bottom: -20,
                left: 32,
                right: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: AppBorderRadius.xxLarge,
                    border: Border.all(
                      color: AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // Middle card
              Positioned(
                top: 8,
                bottom: -10,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: AppBorderRadius.xxLarge,
                    border: Border.all(
                      color: AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // Front card
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: AppBorderRadius.xxLarge,
                    border: Border.all(
                      color: accentColor.withAlpha((0.5 * 255).round()),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withAlpha((0.3 * 255).round()),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side - BPM and streak (example)
                            if (heroContent != null)
                              const SizedBox.shrink()
                            else
                              const SizedBox.shrink(),

                            // Flip button
                            if (onFlip != null)
                              GestureDetector(
                                onTap: onFlip,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.crystalWhite.withAlpha((0.05 * 255).round()),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.flip_camera_android,
                                    color: AppColors.textMuted,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Hero content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                title.toUpperCase(),
                                style: AppTypography.h1.copyWith(
                                  color: AppColors.crystalWhite,
                                  fontSize: 48,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (subtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    subtitle!,
                                    style: AppTypography.body.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              const SizedBox(height: 24),

                              // Custom hero content
                              if (heroContent != null) heroContent!,
                            ],
                          ),
                        ),
                      ),

                      // Bottom content
                      if (bottomContent != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                                width: 1,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            child: Container(
                              color: AppColors.bgDeep.withAlpha((0.6 * 255).round()),
                              child: bottomContent,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Beat tap zone widget for rhythm exercises
class BeatTapZone extends StatefulWidget {
  final VoidCallback? onTap;
  final double bpm;
  final int streak;
  final bool isAnimating;

  const BeatTapZone({
    super.key,
    this.onTap,
    this.bpm = 100,
    this.streak = 0,
    this.isAnimating = true,
  });

  @override
  State<BeatTapZone> createState() => _BeatTapZoneState();
}

class _BeatTapZoneState extends State<BeatTapZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    final beatDuration = Duration(milliseconds: (60000 / widget.bpm).round());
    _pulseController = AnimationController(
      vsync: this,
      duration: beatDuration,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // BPM and streak header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BPM indicator
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.forgeFire,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.bpm.toInt()} BPM',
                  style: AppTypography.mono.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Streak badge
            if (widget.streak > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.crystalWhite.withAlpha((0.05 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.crystalWhite.withAlpha((0.1 * 255).round()),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'STREAK',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.streak}x',
                      style: AppTypography.mono.copyWith(
                        color: AppColors.forgeFire,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 24),

        // Tap zone
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rings
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.forgeFire.withAlpha((0.2 * 255).round()),
                    width: 1,
                  ),
                ),
              ),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.forgeFire.withAlpha((0.1 * 255).round()),
                    width: 1,
                  ),
                ),
              ),

              // Main button
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isAnimating ? _pulseAnimation.value : 1.0,
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) => setState(() => _isPressed = false),
                      onTapCancel: () => setState(() => _isPressed = false),
                      onTap: widget.onTap,
                      child: AnimatedContainer(
                        duration: AppAnimation.fast,
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF2A2A2A),
                              const Color(0xFF151515),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.forgeFire,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.forgeFire.withAlpha((0.4 * 255).round()),
                              blurRadius: _isPressed ? 30 : 15,
                              spreadRadius: _isPressed ? 5 : 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: _isPressed
                                  ? AppColors.crystalWhite
                                  : AppColors.forgeFire.withAlpha((0.5 * 255).round()),
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'TAP ZONE',
                              style: AppTypography.h2.copyWith(
                                color: _isPressed
                                    ? AppColors.crystalWhite
                                    : AppColors.forgeFire.withAlpha((0.8 * 255).round()),
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bottom content widget showing current exercise info
class ExerciseInfoBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;

  const ExerciseInfoBar({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.graphic_eq,
    this.iconColor = AppColors.forgeFire,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  iconColor.withAlpha((0.2 * 255).round()),
                  iconColor.withAlpha((0.05 * 255).round()),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withAlpha((0.2 * 255).round()),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.crystalWhite,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
