import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';

/// Decorative editorial photography. The parent supplies bounded geometry;
/// adjacent copy describes its purpose, not the photographed person's identity.
class FgPhoto extends StatelessWidget {
  const FgPhoto({
    super.key,
    required this.image,
    this.alignment = Alignment.center,
  });

  final ImageProvider image;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Image(
      image: image,
      fit: BoxFit.cover,
      alignment: alignment,
      errorBuilder: (_, _, _) => ColoredBox(
        color: Theme.of(context).forgeColors.immersiveSurface,
        child: Center(
          child: Icon(
            Icons.music_note_outlined,
            size: AppSizes.iconHuge,
            color: Theme.of(context).forgeColors.onImmersiveMuted,
          ),
        ),
      ),
    ),
  );
}
