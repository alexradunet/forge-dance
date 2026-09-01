import 'package:flutter/material.dart';

import '../../theme/forge_theme_extensions.dart';
import '../../tokens/app_sizes.dart';

enum FgAvatarTone { primary, reward, success, neutral }

/// Theme-aware identity avatar with optional status and count badges.
class FgAvatar extends StatelessWidget {
  const FgAvatar({
    super.key,
    this.imageUrl,
    this.imageProvider,
    this.initials,
    this.level,
    this.isOnline = false,
    this.notificationCount,
    this.tone = FgAvatarTone.primary,
    this.isLoading = false,
    this.semanticLabel,
  }) : _size = AppSizes.avatarXl;

  const FgAvatar.large({
    super.key,
    this.imageUrl,
    this.initials,
    this.imageProvider,
    this.level,
    this.isOnline = false,
    this.notificationCount,
    this.tone = FgAvatarTone.primary,
    this.isLoading = false,
    this.semanticLabel,
  }) : _size = AppSizes.avatarXxl;

  const FgAvatar.medium({
    super.key,
    this.imageUrl,
    this.initials,
    this.level,
    this.imageProvider,
    this.isOnline = false,
    this.notificationCount,
    this.tone = FgAvatarTone.primary,
    this.isLoading = false,
    this.semanticLabel,
  }) : _size = AppSizes.avatarLg;

  const FgAvatar.small({
    super.key,
    this.imageUrl,
    this.initials,
    this.level,
    this.isOnline = false,
    this.imageProvider,
    this.notificationCount,
    this.tone = FgAvatarTone.primary,
    this.isLoading = false,
    this.semanticLabel,
  }) : _size = AppSizes.avatarMd;

  final String? imageUrl;
  final String? initials;
  final int? level;
  final bool isOnline;
  final int? notificationCount;
  final FgAvatarTone tone;
  final bool isLoading;
  final String? semanticLabel;
  final ImageProvider<Object>? imageProvider;
  final double _size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    final borderColor = switch (tone) {
      FgAvatarTone.primary => scheme.primary,
      FgAvatarTone.reward => forgeColors.reward,
      FgAvatarTone.success => forgeColors.success,
      FgAvatarTone.neutral => scheme.outline,
    };

    Widget avatar = Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: ClipOval(
        child: isLoading
            ? ColoredBox(color: scheme.surfaceContainerHighest)
            : _AvatarContent(
                imageUrl: imageUrl,
                imageProvider: imageProvider,
                initials: initials,
                size: _size,
              ),
      ),
    );

    if (level != null) {
      avatar = Badge.count(
        count: level!,
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
        child: avatar,
      );
    }
    if (notificationCount != null && notificationCount! > 0) {
      avatar = Badge.count(
        count: notificationCount!,
        alignment: Alignment.topLeft,
        backgroundColor: scheme.error,
        textColor: scheme.onError,
        child: avatar,
      );
    }
    if (isOnline) {
      avatar = Badge(
        alignment: Alignment.bottomRight,
        smallSize: AppSizes.iconXs,
        backgroundColor: forgeColors.success,
        child: avatar,
      );
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(child: avatar),
    );
  }
}

class _AvatarContent extends StatelessWidget {
  const _AvatarContent({
    required this.imageUrl,
    required this.initials,
    required this.imageProvider,
    required this.size,
  });

  final String? imageUrl;
  final String? initials;
  final double size;
  final ImageProvider<Object>? imageProvider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fallback = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: initials == null
            ? Icon(
                Icons.person_rounded,
                size: size * 0.55,
                color: scheme.onSurfaceVariant,
              )
            : Text(
                initials!.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );

    if (imageProvider != null) {
      return Image(
        image: imageProvider!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    if (imageUrl == null || imageUrl!.isEmpty) return fallback;

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
