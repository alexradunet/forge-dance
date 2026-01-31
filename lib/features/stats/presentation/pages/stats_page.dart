import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/molecules/progress/radial_progress_ring.dart';
import '../../../../design_system/molecules/charts/activity_heatmap.dart';
import '../../../../design_system/molecules/charts/weekly_performance_chart.dart';
import '../../../profile/ui/widgets/profile_stats.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          _buildBackgroundGradients(),
          _buildMainContent(context),
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
                const Text(
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
                      icon: const Icon(
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
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
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
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
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
                SizedBox(width: 16),
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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: WeeklyPerformanceChart(
              data: generateMockPerformanceData(),
              title: 'PERFORMANCE',
            ),
          ),
        ),
      ],
    );
  }
}
