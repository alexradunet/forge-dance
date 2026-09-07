import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../atoms/visuals/fg_background.dart';
import '../organisms/navigation/app_header.dart';
import '../theme/app_themes.dart';
import '../theme/forge_theme_extensions.dart';

/// The dark editorial surface used by FORGE's learning and practice flows.
/// Build content inside [bodyBuilder] so Material controls and text resolve
/// against the same palette even when the device or utility theme is light.
class FgImmersiveScaffold extends StatelessWidget {
  const FgImmersiveScaffold({
    super.key,
    required this.bodyBuilder,
    this.title,
    this.onBack,
  });

  final WidgetBuilder bodyBuilder;
  final String? title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => _ImmersiveTheme(
    builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Theme.of(context).forgeColors.immersiveBackground,
        body: FgBackground(
          child: Material(
            type: MaterialType.transparency,
            child: title == null
                ? bodyBuilder(context)
                : Column(
                    children: [
                      AppHeader(
                        title: title!,
                        onBack:
                            onBack ?? () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(child: bodyBuilder(context)),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );

  /// Dialogs use the same surface even when pushed onto the root navigator.
  static Future<T?> showModal<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => _ImmersiveTheme(builder: builder),
  );
}

class _ImmersiveTheme extends StatelessWidget {
  const _ImmersiveTheme({required this.builder});
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Theme(
    data: MediaQuery.highContrastOf(context)
        ? AppThemes.highContrastDark
        : AppThemes.dark,
    child: ForgeSurfaceScope(
      surface: ForgeSurface.immersive,
      child: Builder(builder: builder),
    ),
  );
}
