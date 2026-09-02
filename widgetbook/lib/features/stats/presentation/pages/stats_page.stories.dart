import 'package:flutter/widgets.dart';
import 'package:forge_dance/features/stats/presentation/pages/stats_page.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/preview_data/screen_preview_providers.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'stats_page.stories.g.dart';

const meta = Meta(StatsPagePreview.new);

final $NewDancer = _Story(
  name: 'New Dancer',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewStatsCondition.newDancer),
);

final $Loaded = _Story(
  name: 'Loaded',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewStatsCondition.loaded),
);

final $MaxLevel = _Story(
  name: 'Max Level',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewStatsCondition.maxLevel),
);

final $Loading = _Story(
  name: 'Loading',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewStatsCondition.loading),
);

final $Error = _Story(
  name: 'Error',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewStatsCondition.error),
);

class StatsPagePreview extends StatelessWidget {
  const StatsPagePreview({
    super.key,
    this.condition = PreviewStatsCondition.loaded,
  });

  final PreviewStatsCondition condition;

  @override
  Widget build(BuildContext context) {
    return buildStatsPreview(condition: condition, child: const StatsPage());
  }
}
