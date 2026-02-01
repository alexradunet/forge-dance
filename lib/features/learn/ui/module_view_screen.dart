import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/organisms/lessons/lesson_path_timeline.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import 'lesson_player_screen.dart';

/// Module View Screen matching dashboard_4 mockup (Lesson Path)
class ModuleViewScreen extends StatelessWidget {
  final String moduleTitle;
  final String moduleSubtitle;
  final VoidCallback? onBack;

  const ModuleViewScreen({
    super.key,
    this.moduleTitle = 'Hip Hop Foundations',
    this.moduleSubtitle = 'Module 1 • Path',
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(context),
                ),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),

                // Lesson path
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LessonPathTimeline(
                      nodes: _getMockLessons(),
                      onNavigate: (tab) {
                        debugPrint('Navigate to: $tab');
                        if (tab == 'ignite') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LessonPlayerScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                // Bottom Spacing (FAB area)
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),

            // FAB (Location / Map)
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.surfaceCard,
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      title: moduleTitle,
      subtitle: moduleSubtitle,
      onBack: onBack ?? () => Navigator.of(context).pop(),
      // Use standard AppHeader left slot for back button, and right slot for option
      rightSlot: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: IconButton(
          icon: const Icon(Icons.more_vert, size: 20),
          color: AppColors.textMuted,
          onPressed: () {},
        ),
      ),
    );
  }

  List<LessonNode> _getMockLessons() {
    return const [
      LessonNode(
        title: 'History of Hip Hop',
        type: LessonNodeType.theory,
        state: LessonNodeState.completed,
        duration: '5 min',
      ),
      LessonNode(
        title: 'Groove Basics',
        type: LessonNodeType.movement,
        state: LessonNodeState.current,
        duration: '15 min',
        progress: 0.0,
      ),
      LessonNode(
        title: 'Bounce & Rock',
        type: LessonNodeType.drill,
        state: LessonNodeState.locked,
        duration: '10 min',
      ),
      LessonNode(
        title: 'Freestyle Session',
        type: LessonNodeType.experiment,
        state: LessonNodeState.locked,
        duration: '20 min',
      ),
      LessonNode(
        title: 'Boss Showcase',
        type: LessonNodeType.boss,
        state: LessonNodeState.locked,
        duration: '',
      ),
    ];
  }
}
