import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'cypher_navigation.stories.g.dart';

const meta = Meta(CypherNavigationPreview.new);
final $Navigation = _Story(
  name: 'Whole labels, selected destination and status contrast',
);

class CypherNavigationPreview extends StatefulWidget {
  const CypherNavigationPreview({super.key});
  @override
  State<CypherNavigationPreview> createState() =>
      _CypherNavigationPreviewState();
}

class _CypherNavigationPreviewState extends State<CypherNavigationPreview> {
  int _selected = 2;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppBottomNav(
        currentIndex: _selected,
        onTabChange: (value) => setState(() => _selected = value),
      ),
      const SizedBox(height: AppSpacing.lg),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final color in FgBadgeColor.values)
            for (final variant in FgBadgeVariant.values)
              FgBadge(text: color.name, color: color, variant: variant),
        ],
      ),
    ],
  );
}
