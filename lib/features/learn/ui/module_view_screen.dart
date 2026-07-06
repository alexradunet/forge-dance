import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/organisms/lessons/lesson_path_timeline.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';
import '../../common/ui/widgets/common_error.dart';
import '../model/lesson.dart';
import '../model/lesson_progress.dart';
import '../ui/state/learn_state.dart';
import '../ui/view_model/learn_view_model.dart';

/// Module View Screen (Lesson Path) — renders the lesson catalog combined
/// with the signed-in user's Firestore progress.
class ModuleViewScreen extends ConsumerWidget {
  final VoidCallback? onBack;
  final Function(String)? onLessonNavigate;

  const ModuleViewScreen({
    super.key,
    this.onBack,
    this.onLessonNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, __) => const CommonError(),
          data: (state) => _buildPath(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildPath(BuildContext context, WidgetRef ref, LearnState state) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(context, state),
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
                  nodes: _buildNodes(state),
                  onNavigate: (tab) {
                    if (tab == 'ignite') {
                      final current = state.currentLesson;
                      if (current != null) {
                        ref
                            .read(learnViewModelProvider.notifier)
                            .startLesson(current.id);
                      }
                      onLessonNavigate?.call('lesson-player');
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
    );
  }

  Widget _buildHeader(BuildContext context, LearnState state) {
    return AppHeader(
      title: state.activeModule.title,
      subtitle: state.activeModule.subtitle,
      onBack: onBack ?? () => Navigator.of(context).pop(),
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

  List<LessonNode> _buildNodes(LearnState state) {
    final current = state.currentLesson;
    return [
      for (final lesson in state.activeModule.lessons)
        LessonNode(
          title: lesson.title,
          type: _nodeType(lesson.type),
          state: _nodeState(state, lesson, current),
          duration: lesson.duration,
          difficulty: lesson.difficulty,
          progress: state.lessonProgressOf(lesson),
        ),
    ];
  }

  LessonNodeType _nodeType(LessonType type) {
    switch (type) {
      case LessonType.theory:
        return LessonNodeType.theory;
      case LessonType.drill:
        return LessonNodeType.drill;
      case LessonType.movement:
        return LessonNodeType.movement;
      case LessonType.experiment:
        return LessonNodeType.experiment;
      case LessonType.boss:
        return LessonNodeType.boss;
    }
  }

  LessonNodeState _nodeState(
    LearnState state,
    Lesson lesson,
    Lesson? current,
  ) {
    if (state.statusOf(lesson) == LessonStatus.completed) {
      return LessonNodeState.completed;
    }
    if (lesson.id == current?.id) return LessonNodeState.current;
    return LessonNodeState.locked;
  }
}
