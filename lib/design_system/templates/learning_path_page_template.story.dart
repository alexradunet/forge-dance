import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/templates/learning_path_page_template.dart';

@widgetbook.UseCase(
  name: 'Standard Path',
  type: LearningPathPageTemplate,
  path: 'Design System/Templates',
)
Widget buildLearningPathTemplate(BuildContext context) {
  return LearningPathPageTemplate(
    title: 'Hip Hop Foundations',
    subtitle: 'Module 1 • Path',
    onBack: () {},
    children: const [
      AppLessonNode(
        title: "History of Bounce",
        type: AppLessonNodeType.theory,
        status: AppLessonNodeStatus.completed,
        duration: "15 min",
      ),
      // Active Node Highlight Concept
      Column(
        children: [
          AppLessonNode(
            title: "Groove Basics",
            type: AppLessonNodeType.movement,
            status: AppLessonNodeStatus.active,
            duration: "25 min",
          ),
          SizedBox(height: 16),
          // Contextual Info Card for Active Lesson
          // In a real app this might be a separate molecule or organism
          Card(
            color: AppColors.surfaceDark,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Current Objective: Master the bounce',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          )
        ],
      ),
      AppLessonNode(
        title: "Timing Drill",
        type: AppLessonNodeType.drill,
        status: AppLessonNodeStatus.locked,
        duration: "20 min",
      ),
      AppLessonNode(
        title: "Flow Lab",
        type: AppLessonNodeType.experiment,
        status: AppLessonNodeStatus.locked,
        duration: "30 min",
      ),
      // Boss Challenge/Finale Node Placeholder
      Opacity(
        opacity: 0.5,
        child: AppLessonNode(
          title: "The Forge Finale",
          type: AppLessonNodeType.drill, // Placeholder type
          status: AppLessonNodeStatus.locked,
          duration: "Boss",
        ),
      ),
    ],
  );
}
