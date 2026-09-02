import 'package:flutter/widgets.dart';
import 'package:forge_dance/features/home/presentation/pages/home_page.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/preview_data/screen_preview_providers.dart';
import 'package:widgetbook_workspace/story_setup.dart';

part 'home_page.stories.g.dart';

const meta = Meta(HomePagePreview.new);

final $FreshDancer = _Story(
  name: 'Fresh Dancer',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewLearnCondition.freshDancer),
);

final $Loaded = _Story(
  name: 'Loaded',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewLearnCondition.loaded),
);

final $ModuleComplete = _Story(
  name: 'Module Complete',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewLearnCondition.moduleComplete),
);

final $Loading = _Story(
  name: 'Loading',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewLearnCondition.loading),
);

final $Error = _Story(
  name: 'Error',
  setup: scenarioSemanticsBoundary,
  args: _Args.fixed(condition: PreviewLearnCondition.error),
);

class HomePagePreview extends StatelessWidget {
  const HomePagePreview({
    super.key,
    this.condition = PreviewLearnCondition.loaded,
  });

  final PreviewLearnCondition condition;

  @override
  Widget build(BuildContext context) {
    return buildHomePreview(condition: condition, child: const HomePage());
  }
}
