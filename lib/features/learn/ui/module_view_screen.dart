import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/lesson.dart';
import '../model/lesson_progress.dart';
import '../ui/state/learn_state.dart';
import '../ui/view_model/learn_view_model.dart';

/// Module View Screen (Lesson Path) — renders the lesson catalog combined
/// with the dancer's locally persisted progress.
class ModuleViewScreen extends ConsumerWidget {
  final VoidCallback? onBack;
  final Function(String)? onLessonNavigate;

  const ModuleViewScreen({super.key, this.onBack, this.onLessonNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnState = ref.watch(learnViewModelProvider);

    return Scaffold(
      body: FgBackground(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, _) => FgEmpty(
            icon: Icons.error_outline,
            title: LocaleKeys.unexpectedErrorOccurred.tr(),
            tone: FgEmptyTone.error,
          ),
          data: (state) => _buildPath(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildPath(BuildContext context, WidgetRef ref, LearnState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context, state)),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: LessonPathTimeline(
              nodes: _buildNodes(state),
              onNavigate: (tab) {
                if (tab != 'ignite') return;
                final current = state.currentLesson;
                if (current == null) return;
                ref
                    .read(learnViewModelProvider.notifier)
                    .startLesson(current.id);
                onLessonNavigate?.call(current.id);
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.bottomNavHeight + AppSpacing.lg),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, LearnState state) {
    return AppHeader(
      title: state.activeModule.title,
      subtitle: state.activeModule.subtitle,
      onBack: onBack ?? () => Navigator.of(context).pop(),
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

  LessonNodeState _nodeState(LearnState state, Lesson lesson, Lesson? current) {
    if (state.statusOf(lesson) == LessonStatus.completed) {
      return LessonNodeState.completed;
    }
    if (lesson.id == current?.id && state.canOpenLesson(lesson.id)) {
      return LessonNodeState.current;
    }
    return LessonNodeState.locked;
  }
}
