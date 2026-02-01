import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../profile/ui/widgets/profile_stats.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
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
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: AppHeader(
          title: 'MY PROGRESS',
          subtitle: 'Performance Metrics',
          rightSlot: _buildNotificationIcon(),
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
    ]);
  }
}
