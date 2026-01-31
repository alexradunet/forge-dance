import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import '../../../../features/explore/presentation/pages/explore_page.dart';
import '../../../../features/learning/presentation/pages/learning_path_page.dart';

@widgetbook.UseCase(
  name: 'Explore Hub',
  type: ExplorePage,
)
Widget buildExplorePageUseCase(BuildContext context) {
  return ExplorePage(
    onNavigate: (page) => print('Navigate to $page'),
  );
}

@widgetbook.UseCase(
  name: 'Learning Path',
  type: LearningPathPage,
)
Widget buildLearningPathPageUseCase(BuildContext context) {
  return LearningPathPage(
    onNavigate: (page) => print('Navigate to $page'),
  );
}
