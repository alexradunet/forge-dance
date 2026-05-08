import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';
import '../../authentication/ui/view_model/authentication_view_model.dart';

/// Forge.dance Splash Screen
/// Minimalist design with logo, tagline, and progress indicator
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        showGrid: false,
        child: Stack(
          children: [
            // Main content - centered vertically
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Small flame icon at top (about 1/3 down from center)
                  Icon(
                    Icons.local_fire_department,
                    size: 24,
                    color: AppColors.gray400,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // FORGE.DANCE logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FORGE',
                        style: AppTheme.h1.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: AppColors.crystalWhite,
                        ),
                      ),
                      Text(
                        '.DANCE',
                        style: AppTheme.h1.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forgeFire,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Tagline
                  Text(
                    'THE STAGE IS YOURS.',
                    style: AppTheme.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),

            // Linear progress indicator at bottom
            Positioned(
              bottom: AppSpacing.xxxl,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 120,
                  height: 2,
                  child: Stack(
                    children: [
                      // Background line
                      Container(
                        width: 120,
                        height: 2,
                        color: AppColors.gray800,
                      ),
                      // Progress bar (about 1/3 width)
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 120 * 0.33 * _progressController.value,
                              height: 2,
                              color: AppColors.electricBlue,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authState = await ref.read(authenticationViewModelProvider.future);
    if (!mounted) return;

    if (authState.authSession != null || authState.isLoggedIn) {
      context.pushReplacement(Routes.main);
      return;
    }

    if (authState.hasExistingAccount) {
      context.pushReplacement(Routes.login);
      return;
    }

    context.pushReplacement(Routes.register);
  }
}
