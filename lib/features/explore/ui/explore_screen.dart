import 'package:flutter/material.dart';

import '/design_system/tokens/app_colors.dart';

/// Model for a learning module
class LearningModule {
  final String title;
  final String category;
  final String? imageUrl;
  final double progress;
  final int lessonsCount;
  final bool isNew;
  final bool isPremium;

  const LearningModule({
    required this.title,
    required this.category,
    this.imageUrl,
    this.progress = 0.0,
    this.lessonsCount = 0,
    this.isNew = false,
    this.isPremium = false,
  });
}

/// Module card for explore page
class ModuleCard extends StatelessWidget {
  final LearningModule module;
  final VoidCallback? onTap;

  const ModuleCard({
    super.key,
    required this.module,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/thumbnail
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade900.withOpacity(0.5),
                    Colors.blue.shade900.withOpacity(0.3),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder icon
                  Center(
                    child: Icon(
                      Icons.directions_run,
                      size: 48,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  // Badges
                  if (module.isNew || module.isPremium)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: module.isPremium
                              ? AppColors.legendGold.withOpacity(0.9)
                              : AppColors.forgeFire,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          module.isPremium ? 'PRO' : 'NEW',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${module.lessonsCount} Lessons',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (module.progress > 0) ...[
                    const SizedBox(height: 8),
                    // Progress bar
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: module.progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.forgeFire,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Explore Screen matching dashboard_5 mockup
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background
          _buildBackgroundGradients(),
          // Content
          _buildMainContent(context),
          // Bottom nav
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
              top: -100,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple.withOpacity(0.1),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXPLORE',
                      style: TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: 36,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover new moves and techniques',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Fundamentals section
        SliverToBoxAdapter(
          child: _buildModuleSection(
            title: 'Fundamentals',
            subtitle: 'Build your foundation',
            modules: _getFundamentalsModules(),
          ),
        ),
        // Street Style section
        SliverToBoxAdapter(
          child: _buildModuleSection(
            title: 'Street Style',
            subtitle: 'Express yourself',
            modules: _getStreetModules(),
          ),
        ),
        // Choreography section
        SliverToBoxAdapter(
          child: _buildModuleSection(
            title: 'Choreography',
            subtitle: 'Learn routines',
            modules: _getChoreographyModules(),
          ),
        ),
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 120),
        ),
      ],
    );
  }

  Widget _buildModuleSection({
    required String title,
    required String subtitle,
    required List<LearningModule> modules,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: 22,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forgeFire,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: modules.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return ModuleCard(module: modules[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<LearningModule> _getFundamentalsModules() {
    return const [
      LearningModule(
        title: 'Breaking 101',
        category: 'Fundamentals',
        lessonsCount: 12,
        progress: 0.33,
      ),
      LearningModule(
        title: 'Top Rock Basics',
        category: 'Fundamentals',
        lessonsCount: 8,
        progress: 0.75,
      ),
      LearningModule(
        title: 'Footwork Flow',
        category: 'Fundamentals',
        lessonsCount: 10,
        isNew: true,
      ),
    ];
  }

  List<LearningModule> _getStreetModules() {
    return const [
      LearningModule(
        title: 'Hip Hop Groove',
        category: 'Street',
        lessonsCount: 15,
      ),
      LearningModule(
        title: 'Locking Basics',
        category: 'Street',
        lessonsCount: 9,
        isPremium: true,
      ),
      LearningModule(
        title: 'Popping 101',
        category: 'Street',
        lessonsCount: 11,
        isPremium: true,
      ),
    ];
  }

  List<LearningModule> _getChoreographyModules() {
    return const [
      LearningModule(
        title: 'Beginner Routine',
        category: 'Choreo',
        lessonsCount: 6,
        progress: 0.5,
      ),
      LearningModule(
        title: 'Intermediate Flow',
        category: 'Choreo',
        lessonsCount: 8,
        isNew: true,
      ),
    ];
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
            color: const Color(0xFF121212).withOpacity(0.95),
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
              _buildNavItem(Icons.explore, 'Explore', true),
              _buildIgniteButton(),
              _buildNavItem(Icons.bar_chart, 'Stats', false),
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
