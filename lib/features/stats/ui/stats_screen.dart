import 'package:flutter/material.dart';

import '/design_system/tokens/app_colors.dart';
import '/design_system/molecules/progress/radial_progress_ring.dart';
import '/design_system/molecules/charts/activity_heatmap.dart';
import '/design_system/molecules/charts/weekly_performance_chart.dart';
import '../../profile/ui/widgets/profile_stats.dart';

/// Stats Dashboard Screen matching dashboard_3 mockup
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background gradients
          _buildBackgroundGradients(),
          // Main content
          _buildMainContent(context),
          // Bottom navigation
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradients() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -80,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.forgeFire.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.electricBlue.withOpacity(0.05),
                      Colors.transparent,
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

  Widget _buildMainContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              MediaQuery.paddingOf(context).top + 12,
              24,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MY PROGRESS',
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 36,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.forgeFire,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.bgDeep,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Radial progress ring
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: RadialProgressRing(
                level: 42,
                progress: 0.75,
                subtitle: '+12% This Week',
                size: 192,
              ),
            ),
          ),
        ),
        // Quick stats
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ProfileStatCard(
                    label: 'Current Streak',
                    value: '14 Days',
                    icon: Icons.local_fire_department,
                    iconColor: AppColors.forgeFire,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ProfileStatCard(
                    label: 'Total XP',
                    value: '2.4k',
                    icon: Icons.bolt,
                    iconColor: AppColors.electricBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Activity heatmap
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: ActivityHeatmapGrid(
              data: generateMockHeatmapData(weeks: 12),
              title: 'ACTIVITY LOG',
              subtitle: 'Last 3 Months',
            ),
          ),
        ),
        // Weekly performance chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
            child: WeeklyPerformanceChart(
              data: generateMockPerformanceData(),
              title: 'PERFORMANCE',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.neutral900.withOpacity(0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'Home', false),
              _buildNavItem(Icons.explore, 'Explore', false),
              _buildIgniteButton(),
              _buildNavItem(Icons.bar_chart, 'Stats', true),
              _buildNavItem(Icons.person, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 26,
          color: isActive ? AppColors.forgeFire : AppColors.textMuted,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.forgeFire : AppColors.textMuted,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.forgeFire,
              boxShadow: [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildIgniteButton() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.forgeFire, const Color(0xFFE03E00)],
              ),
              border: Border.all(color: AppColors.bgDeep, width: 6),
              boxShadow: [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.6),
                  blurRadius: 35,
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.local_fire_department, size: 36, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'IGNITE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.forgeFire,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
