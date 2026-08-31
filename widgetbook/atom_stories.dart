import 'package:widgetbook/widgetbook.dart';

import 'atoms/action_atom_stories.dart';
import 'atoms/feedback_atom_stories.dart';
import 'atoms/identity_atom_stories.dart';
import 'atoms/input_atom_stories.dart';
import 'atoms/visual_atom_stories.dart';

List<WidgetbookNode> buildAtomStories() {
  return [
    WidgetbookCategory(
      name: 'Actions',
      children: buildActionAtomStories(),
    ),
    WidgetbookCategory(
      name: 'Inputs',
      children: buildInputAtomStories(),
    ),
    WidgetbookCategory(
      name: 'Identity',
      children: buildIdentityAtomStories(),
    ),
    WidgetbookCategory(
      name: 'Feedback',
      children: buildFeedbackAtomStories(),
    ),
    WidgetbookCategory(
      name: 'Surfaces & visuals',
      children: buildVisualAtomStories(),
    ),
  ];
}
