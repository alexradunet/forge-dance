import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/atoms/buttons/fg_menu_button.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_menu_button.stories.g.dart';

const meta = Meta(FgMenuButtonPreview.new);

final $Playground = _Story(name: 'Playground');

class FgMenuButtonPreview extends StatelessWidget {
  const FgMenuButtonPreview({
    super.key,
    this.icon = Icons.more_vert_rounded,
    this.semanticLabel = 'Training options',
    this.isEnabled = true,
  });

  final IconData icon;
  final String semanticLabel;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return FgMenuButton<String>(
      icon: icon,
      semanticLabel: semanticLabel,
      isEnabled: isEnabled,
      items: const [
        FgMenuItem(value: 'save', label: 'Save workout'),
        FgMenuItem(value: 'share', label: 'Share workout'),
        FgMenuItem(value: 'delete', label: 'Delete workout'),
      ],
      onSelected: (_) {},
    );
  }
}
