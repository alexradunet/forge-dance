import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

Widget scenarioSemanticsBoundary(
  BuildContext context,
  Widget child,
  StoryArgs args,
) {
  return Semantics(
    identifier: 'Widgetbook.ScenarioRoot',
    container: true,
    explicitChildNodes: true,
    child: child,
  );
}
