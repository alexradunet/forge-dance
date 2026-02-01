import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/atoms/progress/fg_progress_bar.dart';
import '../../../../design_system/atoms/icons/fg_icon.dart';
import '../../../../design_system/molecules/cards/fg_content_card.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/tokens/app_shadows.dart';

import '../../../../design_system/atoms/visuals/fg_background.dart';

class HomePage extends StatelessWidget {
  final Function(String)? onNavigate;

  const HomePage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: AppHeader(
                title: 'ALEX_DANCER',
                subtitle: 'Welcome Back',
                rightSlot: _buildNotificationToggle(),
              ),
            ),

            // Hero Section
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: FgContentCard.hero(
                  title: 'EXPLOSIVE POWER',
                  subtitle:
                      'Build raw explosive strength and fast-twitch muscle response through dynamic intervals.',
                  tags: const ['TODAY\'S WOD', 'LIVE'],
                  imageUrl:
                      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&auto=format&fit=crop&q=80',
                  onTap: () => onNavigate?.call('training'),
                ),
              ),
            ),

            // Progress Section
            SliverToBoxAdapter(
              child: _buildProgressSection(),
            ),

            // Continue Training
            SliverToBoxAdapter(
              child: _buildHorizontalSection(
                title: 'CONTINUE TRAINING',
                children: [
                  FgContentCard(
                    title: 'Hip Opener Flow',
                    tags: const ['MOBILITY'],
                    imageUrl:
                        'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=400&auto=format&fit=crop&q=80',
                    progress: 0.65,
                    footerLabel: '5/8 Lessons',
                    onTap: () => onNavigate?.call('lesson-path'),
                  ),
                  const SizedBox(width: 16),
                  FgContentCard(
                    title: 'Isolation Drills',
                    tags: const ['BODY CONTROL'],
                    imageUrl:
                        'https://images.unsplash.com/photo-1508700929628-666bc8bd84ea?w=400&auto=format&fit=crop&q=80',
                    progress: 0.40,
                    footerLabel: '3/7 Lessons',
                    onTap: () => onNavigate?.call('lesson-path'),
                  ),
                ],
              ),
            ),

            // Recommended
            SliverToBoxAdapter(
              child: _buildHorizontalSection(
                title: 'RECOMMENDED FOR YOU',
                showViewAll: true,
                children: [
                  FgContentCard(
                    title: 'Footwork Fundamentals',
                    tags: const ['TECHNIQUE'],
                    imageUrl:
                        'https://images.unsplash.com/photo-1716996642138-e655f2a8dcd5?w=400&auto=format&fit=crop&q=80',
                    progress: 0,
                    footerLabel: '0/6 Lessons',
                    width: 180,
                    onTap: () => onNavigate?.call('lesson-path'),
                  ),
                  const SizedBox(width: 16),
                  FgContentCard(
                    title: 'Breaking Basics',
                    tags: const ['POWER MOVES'],
                    imageUrl:
                        'https://images.unsplash.com/photo-1506411393232-79727bc447af?w=400&auto=format&fit=crop&q=80',
                    progress: 0,
                    footerLabel: '0/7 Lessons',
                    width: 180,
                    onTap: () => onNavigate?.call('lesson-path'),
                  ),
                ],
              ),
            ),

            // Bottom Spacing for BottomNav
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const FgIcon(
              icon: Icons.notifications_none, size: 20, color: Colors.white),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.forgeFire,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgDeep, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MY PROGRESS',
            style: AppTypography.h3
                .copyWith(color: AppColors.textMain, fontSize: 20),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [AppShadows.shadowCard],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          child: const FgIcon(
                            icon: Icons.local_fire_department,
                            color: AppColors.forgeFire,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DAY 12',
                                style: AppTypography.body
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text('CURRENT STREAK',
                                style: AppTypography.label.copyWith(
                                    color: AppColors.textMuted, fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('LEVEL 4',
                            style: AppTypography.body
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text('INTERMEDIATE',
                            style: AppTypography.label.copyWith(
                                color: AppColors.textMuted, fontSize: 9)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const FgProgressBar(value: 0.82, height: 10),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1,240 XP',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMuted)),
                    Text('NEXT LEVEL: 1,500 XP',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection({
    required String title,
    required List<Widget> children,
    bool showViewAll = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.h3
                    .copyWith(color: AppColors.textMain, fontSize: 20),
              ),
              if (showViewAll)
                GestureDetector(
                  onTap: () => onNavigate?.call('explore'),
                  child: Text(
                    'VIEW ALL',
                    style: AppTypography.label.copyWith(
                      color: AppColors.forgeFire,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          child: Row(children: children),
        ),
      ],
    );
  }
}
