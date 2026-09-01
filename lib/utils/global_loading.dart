import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../generated/locale_keys.g.dart';

class Global {
  static OverlayEntry? overlayEntry;

  static void showLoading(BuildContext context) {
    if (overlayEntry != null) return;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final label = LocaleKeys.loadingLabel.tr();
        return Semantics(
          label: label,
          liveRegion: true,
          scopesRoute: true,
          namesRoute: true,
          child: ExcludeSemantics(
            child: Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 0.68),
                ),
                const Center(child: FgSpinner()),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  static void hideLoading() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
