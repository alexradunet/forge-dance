import 'package:flutter/material.dart';

import '../../design_system.dart';

/// Quiet, bounded viewport for an instructional visual. Playback, camera, and
/// the current cue stay outside this surface so they never obscure the feet.
class FgMovementStage extends StatelessWidget {
  const FgMovementStage({
    super.key,
    required this.child,
    required this.semanticLabel,
  });

  final Widget child;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: semanticLabel,
    child: ExcludeSemantics(
      child: Material(
        color: context.forgeSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.small,
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: AppSizes.movementStageHeight,
          width: double.infinity,
          child: RepaintBoundary(child: child),
        ),
      ),
    ),
  );
}
