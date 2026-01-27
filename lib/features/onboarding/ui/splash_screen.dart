import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../routing/routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/repository/authentication_repository.dart';

/// Forge.dance Splash Screen
/// Based on the HTML design with Forge design system
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray950,
      body: Stack(
        children: [
          // Animated blur circles background
          _AnimatedBlurBackground(
            shimmerController: _shimmerController,
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fire icon
                  Icon(
                    Icons.local_fire_department,
                    size: 48,
                    color: AppColors.crystalWhite.withOpacity(0.4),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),

                  // FORGE.DANCE title
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FORGE',
                          style: AppTheme.h1.copyWith(
                            fontSize: 88,
                            height: 0.85,
                            letterSpacing: -2,
                            color: AppColors.crystalWhite,
                            shadows: [
                              // Text glow effect
                              Shadow(
                                color: AppColors.forgeFire.withOpacity(0.45),
                                blurRadius: 40,
                              ),
                              Shadow(
                                color: AppColors.electricBlue.withOpacity(0.25),
                                blurRadius: 80,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '.',
                          style: AppTheme.h1.copyWith(
                            fontSize: 88,
                            height: 0.85,
                            color: AppColors.forgeFire,
                            shadows: [
                              Shadow(
                                color: AppColors.forgeFire.withOpacity(0.45),
                                blurRadius: 40,
                              ),
                              Shadow(
                                color: AppColors.electricBlue.withOpacity(0.25),
                                blurRadius: 80,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'DANCE',
                          style: AppTheme.h1.copyWith(
                            fontSize: 88,
                            height: 0.85,
                            letterSpacing: -2,
                            color: AppColors.crystalWhite,
                            shadows: [
                              Shadow(
                                color: AppColors.forgeFire.withOpacity(0.45),
                                blurRadius: 40,
                              ),
                              Shadow(
                                color: AppColors.electricBlue.withOpacity(0.25),
                                blurRadius: 80,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Subtitle
                  Text(
                    'The Stage is Yours.',
                    style: AppTheme.bodyLarge.copyWith(
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 6.4, // 0.4em equivalent
                      color: AppColors.crystalWhite.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator at bottom
          Positioned(
            bottom: AppSpacing.xxxl,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Shimmer loading bar
                _ShimmerLoadingBar(
                  controller: _shimmerController,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                // Initialising text
                Text(
                  'INITIALISING',
                  style: AppTheme.caption.copyWith(
                    fontSize: 9,
                    letterSpacing: 3.6, // 0.4em equivalent
                    color: AppColors.crystalWhite.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn =
        await ref.read(authenticationRepositoryProvider).isLogin();
    debugPrint(
        '${Constants.tag} [SplashScreen._checkLoginStatus] isLoggedIn = $isLoggedIn');
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (isLoggedIn) {
      context.pushReplacement(Routes.main);
    } else {
      context.pushReplacement(Routes.register);
    }
  }
}

/// Animated blur background with glow effects
class _AnimatedBlurBackground extends StatelessWidget {
  final AnimationController shimmerController;

  const _AnimatedBlurBackground({
    required this.shimmerController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Primary color blur (Forge Fire)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.5,
          left: MediaQuery.of(context).size.width * 0.5,
          child: Transform.translate(
            offset: const Offset(-140, -140),
            child: Container(
              width: MediaQuery.of(context).size.width * 1.4,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: AppColors.forgeFire,
                shape: BoxShape.circle,
              ),
            ).withBlur(blur: 160, opacity: 0.1),
          ),
        ),

        // Accent color blur (Electric Blue)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.5,
          left: MediaQuery.of(context).size.width * 0.5,
          child: Transform.translate(
            offset: const Offset(-100, -100),
            child: Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: AppColors.electricBlue,
                shape: BoxShape.circle,
              ),
            ).withBlur(blur: 140, opacity: 0.1),
          ),
        ),

        // Smoke pattern overlay (gradient effect)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  AppColors.gray950.withOpacity(0),
                  AppColors.gray950,
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading bar animation
class _ShimmerLoadingBar extends StatelessWidget {
  final AnimationController controller;

  const _ShimmerLoadingBar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 1,
      child: Stack(
        children: [
          // Background line
          Container(
            width: 48,
            height: 1,
            color: AppColors.crystalWhite.withOpacity(0.1),
          ),
          // Animated shimmer
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                left: -60 + (controller.value * 180),
                top: 0,
                child: Container(
                  width: 60,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.forgeFire.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Extension to add blur effect to widgets
extension BlurExtension on Widget {
  Widget withBlur({required double blur, required double opacity}) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur / 10, sigmaY: blur / 10),
        child: Opacity(
          opacity: opacity,
          child: this,
        ),
      ),
    );
  }
}
