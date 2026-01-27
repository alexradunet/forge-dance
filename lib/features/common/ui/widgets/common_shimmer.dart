import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '/extensions/build_context_extension.dart';
import '/theme/app_colors.dart';

class CommonShimmer extends StatelessWidget {
  final Widget child;

  const CommonShimmer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          context.isDarkMode ? AppColors.gray950.withOpacity(0.66) : AppColors.gray950.withOpacity(0.1),
      highlightColor:
          context.isDarkMode ? AppColors.gray950.withOpacity(0.33) : AppColors.gray950.withOpacity(0),
      child: child,
    );
  }
}
