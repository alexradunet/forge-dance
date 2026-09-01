import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/constants.dart';
import '/design_system/design_system.dart';
import '/generated/locale_keys.g.dart';

class OfflineContainer extends ConsumerStatefulWidget {
  const OfflineContainer({super.key, required this.child});

  final Widget? child;

  @override
  ConsumerState<OfflineContainer> createState() => _OfflineContainerState();
}

class _OfflineContainerState extends ConsumerState<OfflineContainer> {
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (Platform.isIOS) return;

    setState(() {
      _isOffline = result.contains(ConnectivityResult.none);
    });
    debugPrint(
      '${Constants.tag} [_OfflineContainerState._updateConnectionStatus] '
      '$result => ${_isOffline ? 'offline' : 'online'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          if (_isOffline)
            Semantics(
              liveRegion: true,
              label: LocaleKeys.offline.tr(),
              child: ExcludeSemantics(
                child: ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.signal_wifi_connected_no_internet_4,
                            size: AppSizes.iconSm,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Text(
                              LocaleKeys.offline.tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: widget.child ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
