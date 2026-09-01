import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../constants/assets.dart';
import '../../../../design_system/atoms/avatars/fg_avatar.dart';
import '../../../../extensions/string_extension.dart';

/// Resolves persisted profile image locations into the Forge avatar primitive.
class Avatar extends StatelessWidget {
  const Avatar({super.key, this.url, this.semanticLabel});

  final String? url;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return FgAvatar.large(
      imageProvider: _imageProvider(),
      tone: FgAvatarTone.reward,
      semanticLabel: semanticLabel,
    );
  }

  ImageProvider<Object> _imageProvider() {
    if (url?.isUrl ?? false) {
      return CachedNetworkImageProvider(url.orEmpty());
    }
    if (url != null && File(url!).existsSync()) {
      return FileImage(File(url!));
    }
    return const AssetImage(Assets.avatar);
  }
}
