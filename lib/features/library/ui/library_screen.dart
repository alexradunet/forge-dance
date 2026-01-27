import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/primary_button.dart';

/// Forge.dance Library Screen
/// Browse exercises and workouts by style and level
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _selectedFilter = 'All Styles';

  final List<String> _filters = [
    'All Styles',
    'Hip Hop',
    'Popping',
    'Break',
    'House',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray950,
      body: CustomScrollView(
        slivers: [
          // Top App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.gray950.withOpacity(0.95),
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.crystalWhite,
              ),
            ),
            title: Text(
              'Library',
              style: AppTheme.h5.copyWith(
                color: AppColors.crystalWhite,
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // Navigate to search
                },
                icon: const Icon(
                  Icons.search,
                  color: AppColors.crystalWhite,
                ),
              ),
            ],
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray950,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.crystalWhite.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: filter != _filters.last ? AppSpacing.md : 0,
                      ),
                      child: _FilterChip(
                        label: filter,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.xxl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Recommended Banner
                _RecommendedBanner(),
                SizedBox(height: AppSpacing.xxxl),

                // The Foundation Section (Level 1-2)
                _LevelSection(
                  title: 'The Foundation',
                  levelRange: 'Level 1-2',
                  levelColor: AppColors.growthGreen,
                  exercises: [
                    _ExerciseData(
                      title: 'Basic Two-Step',
                      style: 'Hip Hop',
                      duration: 3,
                      level: 1,
                      forgePoints: 50,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: false,
                    ),
                    _ExerciseData(
                      title: 'Isolation Drill',
                      style: 'Popping',
                      duration: 5,
                      level: 1,
                      forgePoints: 50,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: false,
                    ),
                    _ExerciseData(
                      title: 'Rhythm 101',
                      style: 'General',
                      duration: 10,
                      level: 2,
                      forgePoints: 75,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: false,
                    ),
                    _ExerciseData(
                      title: 'Bounce Basic',
                      style: 'Hip Hop',
                      duration: 4,
                      level: 2,
                      forgePoints: 75,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: false,
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xxxl),

                // The Forge Section (Level 3-4)
                _LevelSection(
                  title: 'The Forge',
                  levelRange: 'Level 3-4',
                  levelColor: AppColors.warningAmber,
                  exercises: [
                    _ExerciseData(
                      title: 'Adv. Footwork',
                      style: 'House',
                      duration: 8,
                      level: 3,
                      forgePoints: 150,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: false,
                    ),
                    _ExerciseData(
                      title: 'Gliding',
                      style: 'Popping',
                      duration: 6,
                      level: 4,
                      forgePoints: 200,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: false,
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xxxl),

                // The Legend Section (Level 5)
                _LevelSection(
                  title: 'The Legend',
                  levelRange: 'Level 5',
                  levelColor: AppColors.forgeFire,
                  exercises: [
                    _ExerciseData(
                      title: 'Headspin',
                      style: 'Break',
                      duration: 12,
                      level: 5,
                      forgePoints: 500,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
                      isLocked: true,
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.forgeFire
              : AppColors.gray800,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.crystalWhite.withOpacity(0.1),
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: AppColors.crystalWhite,
          ),
        ),
      ),
    );
  }
}

/// Recommended Banner
class _RecommendedBanner extends StatefulWidget {
  @override
  State<_RecommendedBanner> createState() => _RecommendedBannerState();
}

class _RecommendedBannerState extends State<_RecommendedBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.forgeFire.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.forgeFire.withOpacity(
                  0.3 + (_glowController.value * 0.3),
                ),
                blurRadius: 15,
                spreadRadius: -3,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.gray800,
              ),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.gray800,
                        );
                      },
                    ),
                  ),

                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.gray950.withOpacity(0.8),
                          AppColors.gray950,
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: AppSpacing.card,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.forgeFire,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'DAILY CHALLENGE',
                                style: AppTheme.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.crystalWhite,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gray800.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    size: 14,
                                    color: AppColors.forgeFire,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    '+200 FP',
                                    style: AppTheme.caption.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.forgeFire,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'The Moonwalk',
                          style: AppTheme.h4.copyWith(
                            color: AppColors.crystalWhite,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Master the glide. Earn double points today only.',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppColors.crystalWhite.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: 'START CHALLENGE',
                            backgroundColor: AppColors.crystalWhite,
                            textColor: AppColors.gray950,
                            onPressed: () {
                              // Navigate to challenge
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 18,
                              color: AppColors.gray950,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Level Section Widget
class _LevelSection extends StatelessWidget {
  final String title;
  final String levelRange;
  final Color levelColor;
  final List<_ExerciseData> exercises;

  const _LevelSection({
    required this.title,
    required this.levelRange,
    required this.levelColor,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sticky Header
        Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.gray950.withOpacity(0.95),
            border: Border(
              bottom: BorderSide(
                color: AppColors.crystalWhite.withOpacity(0.05),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.h5.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  levelRange,
                  style: AppTheme.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: levelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Exercise Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 3 / 4,
          ),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return _ExerciseCard(
              exercise: exercises[index],
              levelColor: levelColor,
            );
          },
        ),
      ],
    );
  }
}

/// Exercise Card Widget
class _ExerciseCard extends StatelessWidget {
  final _ExerciseData exercise;
  final Color levelColor;

  const _ExerciseCard({
    required this.exercise,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: exercise.isLocked
          ? null
          : () {
              // Navigate to exercise detail
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: exercise.level == 5
              ? Border.all(
                  color: AppColors.forgeFire.withOpacity(0.4),
                  width: 1,
                )
              : null,
          boxShadow: exercise.level == 5
              ? [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  exercise.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.gray800,
                      child: const Center(
                        child: Icon(
                          Icons.music_note,
                          size: 32,
                          color: AppColors.gray600,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),

              // Level Badge
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: levelColor,
                    shape: BoxShape.circle,
                    boxShadow: exercise.level >= 3
                        ? [
                            BoxShadow(
                              color: levelColor.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${exercise.level}',
                      style: AppTheme.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: exercise.level >= 3
                            ? AppColors.crystalWhite
                            : AppColors.gray950,
                      ),
                    ),
                  ),
                ),
              ),

              // Forge Points Badge
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: exercise.level == 5
                        ? AppColors.forgeFire.withOpacity(0.2)
                        : Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: exercise.level == 5
                        ? Border.all(
                            color: AppColors.forgeFire.withOpacity(0.4),
                            width: 1,
                          )
                        : Border.all(
                            color: AppColors.crystalWhite.withOpacity(0.1),
                            width: 1,
                          ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt,
                        size: 10,
                        color: exercise.level == 5
                            ? AppColors.forgeFire
                            : AppColors.forgeFire,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${exercise.forgePoints}',
                        style: AppTheme.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: exercise.level == 5
                              ? AppColors.forgeFire
                              : AppColors.crystalWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lock Icon (if locked)
              if (exercise.isLocked)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.crystalWhite.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.lock,
                      size: 20,
                      color: AppColors.crystalWhite.withOpacity(0.8),
                    ),
                  ),
                ),

              // Title and Metadata
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.crystalWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${exercise.style} • ${exercise.duration} min',
                      style: AppTheme.caption.copyWith(
                        color: exercise.isLocked
                            ? AppColors.forgeFire
                            : AppColors.crystalWhite.withOpacity(0.5),
                        fontWeight: exercise.isLocked
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Exercise Data Model
class _ExerciseData {
  final String title;
  final String style;
  final int duration;
  final int level;
  final int forgePoints;
  final String imageUrl;
  final bool isLocked;

  _ExerciseData({
    required this.title,
    required this.style,
    required this.duration,
    required this.level,
    required this.forgePoints,
    required this.imageUrl,
    required this.isLocked,
  });
}
