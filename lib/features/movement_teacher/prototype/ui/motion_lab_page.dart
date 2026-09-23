import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../model/motion_lab_controller.dart';
import 'synthetic_rig_painter.dart';

/// Debug-only interaction prototype. No lessons, storage, rewards or teacher
/// claims. A validated motion asset and renderer are separate release gates.
class MotionLabPage extends StatefulWidget {
  const MotionLabPage({super.key});

  @override
  State<MotionLabPage> createState() => _MotionLabPageState();
}

class _MotionLabPageState extends State<MotionLabPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _controller = MotionLabController();
  late final Ticker _ticker;
  Duration _lastFrame = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = createTicker((elapsed) {
      final delta = elapsed - _lastFrame;
      _lastFrame = elapsed;
      _controller.advance(delta);
    });
    _controller.addListener(_syncPlayback);
  }

  void _syncPlayback() {
    if (_controller.playing && !_ticker.isActive) {
      _lastFrame = Duration.zero;
      _ticker.start();
    } else if (!_controller.playing && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _controller.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_syncPlayback);
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FgImmersiveScaffold(
    title: LocaleKeys.motionLabTitle.tr(),
    bodyBuilder: (context) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.readingContentMax),
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => ListView(
            padding: AppSpacing.allLG,
            children: [
              FgSectionHeading(
                eyebrow: LocaleKeys.motionLabPrototype.tr(),
                title: LocaleKeys.motionLabHeading.tr(),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Essential limitations stay visible, never in a collapsed panel.
              Text(LocaleKeys.motionLabWarning.tr()),
              const SizedBox(height: AppSpacing.lg),
              FgMovementStage(
                semanticLabel: LocaleKeys.motionLabStageDescription.tr(),
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _controller.setYaw(_controller.yaw + details.delta.dx),
                  child: CustomPaint(
                    painter: SyntheticRigPainter(
                      position: _controller.position,
                      yaw: _controller.yaw,
                      foreground: Theme.of(context).forgeColors.onImmersive,
                      accent: Theme.of(context).colorScheme.primary,
                      floor: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(LocaleKeys.motionLabOrientation.tr()),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  FgButton(
                    text:
                        (_controller.playing
                                ? LocaleKeys.motionLabPause
                                : LocaleKeys.motionLabPlay)
                            .tr(),
                    icon: Icon(
                      _controller.playing ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: _controller.togglePlayback,
                  ),
                  for (final speed in MotionLabController.speeds)
                    FgFilterChip(
                      label: '$speed×',
                      isSelected: _controller.speed == speed,
                      onSelected: (_) => _controller.setSpeed(speed),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              FgSlider(
                value: _controller.position,
                min: _controller.rangeStart,
                max: _controller.rangeEnd,
                divisions: 160,
                semanticLabel: LocaleKeys.motionLabTimeline.tr(),
                label: LocaleKeys.motionLabTimeline.tr(),
                valueLabel:
                    '${(_controller.position * MotionLabController.clipSeconds).toStringAsFixed(1)} / 8.0 s',
                semanticFormatterCallback: (value) =>
                    LocaleKeys.motionLabSeconds.tr(
                      args: [
                        (value * MotionLabController.clipSeconds)
                            .toStringAsFixed(1),
                      ],
                    ),
                onChanged: _controller.seek,
              ),
              FgFilterChip(
                label: LocaleKeys.motionLabLoop.tr(),
                isSelected: _controller.loop,
                onSelected: _controller.setLoop,
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final camera in [
                    (LocaleKeys.motionLabFront, 0.0),
                    (LocaleKeys.motionLabSide, 90.0),
                    (LocaleKeys.motionLabBack, 180.0),
                  ])
                    FgFilterChip(
                      label: camera.$1.tr(),
                      isSelected: _controller.yaw == camera.$2,
                      onSelected: (_) => _controller.setYaw(camera.$2),
                    ),
                ],
              ),
              FgSlider(
                value: _controller.yaw,
                min: -180,
                max: 180,
                divisions: 72,
                label: LocaleKeys.motionLabCamera.tr(),
                semanticLabel: LocaleKeys.motionLabCamera.tr(),
                valueLabel: '${_controller.yaw.round()}°',
                onChanged: _controller.setYaw,
              ),
              FgDetails(
                title: LocaleKeys.motionLabAbout.tr(),
                child: Text(LocaleKeys.motionLabScope.tr()),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    ),
  );
}
