import 'package:flutter/widgets.dart';

import '../tokens/app_sizes.dart';

/// Constrains a reading surface without owning padding or scrolling. Place a
/// ListView/CustomScrollView inside it, not around it, for a bounded viewport.
class FgReadingBody extends StatelessWidget {
  const FgReadingBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.readingContentMax),
      child: SizedBox(width: double.infinity, child: child),
    ),
  );
}
