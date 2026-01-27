import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/primary_button.dart';

/// Forge.dance Home Screen
/// Main home screen with featured workout, progress, and quick actions
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final currentHour = DateTime.now().hour;
    if (currentHour >= 5 && currentHour < 12) return 'Good Morning';
    if (currentHour >= 12 && currentHour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.gray950,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WELCOME BACK',
                            style: AppTheme.caption.copyWith(
                              fontSize: 10,
                              letterSpacing: 1.2,
                              color: AppColors.gray400,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${_getGreeting()}, Alex!',
                            style: AppTheme.h3.copyWith(
                              color: AppColors.crystalWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification icon with badge
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Navigate to notifications
                          },
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.gray400,
                            size: 24,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.forgeFire,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Featured Workout Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: _FeaturedWorkoutCard(),
              ),
            ),

            // Your Progress Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Progress',
                          style: AppTheme.h5.copyWith(
                            color: AppColors.crystalWhite,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to stats
                          },
                          child: Text(
                            'View Stats',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppColors.gray400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Streak and Level Cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Streak',
                            value: '12',
                            unit: 'Days',
                            icon: '🔥',
                            iconColor: AppColors.forgeFire,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            label: 'Level',
                            value: '14',
                            unit: 'Master',
                            icon: '🏅',
                            iconColor: AppColors.electricBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Level Progress Card
                    _LevelProgressCard(),
                  ],
                ),
              ),
            ),

            // Quick Actions Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.md,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: AppTheme.h5.copyWith(
                        color: AppColors.crystalWhite,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QuickActionButton(
                          icon: Icons.refresh,
                          label: 'Review',
                          onTap: () {},
                        ),
                        SizedBox(width: AppSpacing.sm),
                        _QuickActionButton(
                          icon: Icons.grid_view,
                          label: 'Custom',
                          onTap: () {},
                        ),
                        SizedBox(width: AppSpacing.sm),
                        _QuickActionButton(
                          icon: Icons.flag,
                          label: 'Goals',
                          onTap: () {},
                        ),
                        SizedBox(width: AppSpacing.sm),
                        _QuickActionButton(
                          icon: Icons.favorite,
                          label: 'Favorites',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Featured Workout Card
class _FeaturedWorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.forgeFire.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gray800,
                    AppColors.gray950,
                  ],
                ),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.gray800,
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        size: 64,
                        color: AppColors.gray600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dark overlay for text readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: AppSpacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.forgeFire,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'DAILY DROP',
                        style: AppTheme.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.crystalWhite,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      "TODAY'S FORGE CHALLENGE",
                      style: AppTheme.caption.copyWith(
                        fontSize: 10,
                        color: AppColors.crystalWhite,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Title
                Text(
                  'HIP HOP',
                  style: AppTheme.h2.copyWith(
                    fontSize: 32,
                    color: AppColors.crystalWhite,
                  ),
                ),
                Text(
                  'THUNDER STRIKE',
                  style: AppTheme.h1.copyWith(
                    fontSize: 48,
                    height: 0.9,
                    color: AppColors.crystalWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Details
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bar_chart,
                          size: 16,
                          color: AppColors.gray300,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Level 5',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppColors.gray300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      '•',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppColors.gray300,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.gray300,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '45 min',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppColors.gray300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Start Workout Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'START WORKOUT',
                    backgroundColor: AppColors.forgeFire,
                    onPressed: () {
                      // Navigate to workout player
                    },
                    icon: const Icon(
                      Icons.bolt,
                      size: 20,
                      color: AppColors.crystalWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat Card (Streak or Level)
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
              Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTheme.h3.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Level Progress Card
class _LevelProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const currentXP = 1250;
    const targetXP = 2000;
    final progress = currentXP / targetXP;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level Progress',
                style: AppTheme.h6.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              Text(
                '$currentXP / $targetXP XP',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.gray700,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.electricBlue,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${targetXP - currentXP} XP to reach Level 15. Keep dancing!',
            style: AppTheme.bodySmall.copyWith(
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick Action Button
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.gray800,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.crystalWhite,
                size: 24,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.crystalWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
