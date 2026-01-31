import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';

class AppProgressSegments extends StatelessWidget {
  final int total;
  final int current; // 0-indexed
  final Color? activeColor;
  final bool isCumulative;

  const AppProgressSegments({
    super.key,
    required this.total,
    required this.current,
    this.activeColor,
    this.isCumulative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < total; i++) ...[
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: (isCumulative ? i <= current : i == current)
                      ? (activeColor ?? AppColors.forgeFire)
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: (isCumulative ? i <= current : i == current) &&
                          !isCumulative
                      ? [
                          BoxShadow(
                            color: (activeColor ?? AppColors.forgeFire)
                                .withOpacity(0.5),
                            blurRadius: 8,
                          )
                        ]
                      : null,
                ),
              ),
            ),
            if (i < total - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

// Helper to allow gap in Row (simulated)
extension RowGap on Row {
  Row withGap(double space) {
    final List<Widget> childrenWithGaps = [];
    for (int i = 0; i < children.length; i++) {
      childrenWithGaps.add(children[i]);
      if (i < children.length - 1) {
        childrenWithGaps.add(SizedBox(width: space));
      }
    }
    return Row(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: childrenWithGaps,
    );
  }
}
