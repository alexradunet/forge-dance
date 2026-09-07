import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_immersive_scaffold.stories.g.dart';

const meta = Meta(FgImmersiveScaffold.new);

final $Playground = _Story(
  name: 'Immersive feature surfaces',
  args: _Args(
    title: NullableStringArg('FORGE method'),
    onBack: Arg.fixed(() {}),
    bodyBuilder: Arg.fixed(_content),
  ),
  scenarios: [
    _Scenario(
      name: 'Practice controls',
      args: _Args.fixed(
        title: 'Daily practice',
        onBack: _back,
        bodyBuilder: _content,
      ),
    ),
    _Scenario(
      name: 'Long editorial heading',
      args: _Args.fixed(
        title: 'Coordinate movement with musical phrasing',
        onBack: _back,
        bodyBuilder: _content,
      ),
    ),
  ],
);

void _back() {}

Widget _content(BuildContext context) => ListView(
  padding: AppSpacing.allLG,
  children: [
    FgCard(
      immersive: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your current capability',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Practice and assessment use the same dark surface, readable text and warm accent.',
          ),
          const SizedBox(height: AppSpacing.lg),
          FgButton(text: 'Start practice', onPressed: _back),
          const SizedBox(height: AppSpacing.sm),
          FgButton(
            text: 'View requirements',
            variant: FgButtonVariant.secondary,
            onPressed: _back,
          ),
        ],
      ),
    ),
    const SizedBox(height: AppSpacing.lg),
    FgInput(label: 'Practice notes', placeholder: 'What felt clearer today?'),
    const SizedBox(height: AppSpacing.lg),
    FgButton(
      text: 'Preview confirmation',
      variant: FgButtonVariant.ghost,
      onPressed: () => FgImmersiveScaffold.showModal<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Private recording'),
          content: const Text(
            'Dialogs retain the same palette as the practice screen.',
          ),
          actions: [
            FgButton(text: 'Close', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    ),
  ],
);
