import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../design_system/organisms/navigation/app_header.dart';

/// Step data for WOD session
class WodStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final String duration;
  final bool isCompleted;
  final bool isCurrent;

  const WodStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.duration,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

/// Daily WOD Session Screen matching dashboard_2 mockup
class WodSessionScreen extends StatelessWidget {
  final String wodTitle;
  final String wodSubtitle;
  final int bpm;

  const WodSessionScreen({
    super.key,
    this.wodTitle = 'GROOVE FOUNDATIONS',
    this.wodSubtitle = 'Technical Prep',
    this.bpm = 98,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Hero background
          _buildHeroBackground(),
          // Content
          CustomScrollView(
            slivers: [
              // Header with back button
              SliverToBoxAdapter(
                child: _buildHeader(context),
              ),
              // Hero section
              SliverToBoxAdapter(
                child: _buildHeroSection(),
              ),
              // Steps timeline
              SliverToBoxAdapter(
                child: _buildStepsTimeline(),
              ),
              // BPM control
              SliverToBoxAdapter(
                child: _buildBpmControl(),
              ),
              // Spacer for button
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
          // Start button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStartButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900.withOpacity(0.8),
              AppColors.bgDeep,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Abstract shapes
            Positioned(
              top: -50,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.forgeFire.withOpacity(0.2),
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

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      title: 'DAILY WOD',
      isTransparent: true,
      onBack: () => Navigator.of(context).pop(),
      rightSlot: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert, color: Colors.white),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wodSubtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.electricBlue,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            wodTitle,
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 42,
              color: Colors.white,
              letterSpacing: 2,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.timer, '25 min'),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.bolt, '+150 FP'),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.local_fire_department, 'Day 14'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsTimeline() {
    final steps = [
      WodStep(
        title: 'Theory',
        subtitle: 'Build the mindset',
        icon: Icons.self_improvement,
        duration: '5 min',
        isCompleted: false,
        isCurrent: true,
      ),
      WodStep(
        title: 'Drill',
        subtitle: 'Master the moves',
        icon: Icons.fitness_center,
        duration: '10 min',
      ),
      WodStep(
        title: 'Movement',
        subtitle: 'Put it together',
        icon: Icons.directions_run,
        duration: '8 min',
      ),
      WodStep(
        title: 'Recovery',
        subtitle: 'Cool down & reflect',
        icon: Icons.spa,
        duration: '2 min',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SESSION FLOW',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                final isLast = index == steps.length - 1;

                return Expanded(
                  child: Row(
                    children: [
                      _buildStepNode(step),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepNode(WodStep step) {
    final isActive = step.isCurrent;

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.forgeFire.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            border: Border.all(
              color: isActive
                  ? AppColors.forgeFire
                  : Colors.white.withOpacity(0.2),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.forgeFire.withOpacity(0.3),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              step.icon,
              size: 22,
              color: isActive ? AppColors.forgeFire : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          step.title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppColors.textMuted,
          ),
        ),
        Text(
          step.duration,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildBpmControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // BPM display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BPM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  bpm.toString(),
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Controls
            Row(
              children: [
                _buildBpmButton(Icons.remove, () {}),
                const SizedBox(width: 16),
                _buildBpmButton(Icons.add, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBpmButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.bgDeep,
          ],
        ),
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.forgeFire, const Color(0xFFE03E00)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.forgeFire.withOpacity(0.5),
              blurRadius: 25,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'START SESSION',
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 2,
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
}
