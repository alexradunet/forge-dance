import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../tokens/app_colors.dart';
import '../visuals/fg_shimmer.dart';

/// A robust image component with caching, shimmer loading, and error states.
class FgImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? aspectRatio;
  final Widget? placeholder;
  final Widget? errorWidget;

  const FgImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.aspectRatio,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          FgShimmer.rect(
            width: width,
            height: height,
            borderRadius: borderRadius == null
                ? 0
                : 0, // Shimmer handles its own radius if needed, but we clip outside
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: AppColors.gray800,
            child: const Icon(Icons.broken_image, color: AppColors.textMuted),
          ),
    );

    if (aspectRatio != null) {
      imageWidget = AspectRatio(
        aspectRatio: aspectRatio!,
        child: imageWidget,
      );
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
