import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../atoms/buttons/fg_button.dart';

/// BPM widget molecule - Tempo control with slider and +/- buttons
class BPMWidget extends StatefulWidget {
  final int initialBPM;
  final ValueChanged<int>? onBPMChanged;
  final int minBPM;
  final int maxBPM;

  const BPMWidget({
    super.key,
    this.initialBPM = 128,
    this.onBPMChanged,
    this.minBPM = 60,
    this.maxBPM = 200,
  });

  @override
  State<BPMWidget> createState() => _BPMWidgetState();
}

class _BPMWidgetState extends State<BPMWidget> {
  late int _bpm;

  @override
  void initState() {
    super.initState();
    _bpm = widget.initialBPM;
  }

  void _decrement() {
    if (_bpm > widget.minBPM) {
      setState(() => _bpm--);
      widget.onBPMChanged?.call(_bpm);
    }
  }

  void _increment() {
    if (_bpm < widget.maxBPM) {
      setState(() => _bpm++);
      widget.onBPMChanged?.call(_bpm);
    }
  }

  void _onSliderChanged(double value) {
    setState(() => _bpm = value.round());
    widget.onBPMChanged?.call(_bpm);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_bpm - widget.minBPM) / (widget.maxBPM - widget.minBPM);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                    color: AppColors.forgeFire,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Tempo Control',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.crystalWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Text(
                '$_bpm',
                style: AppTheme.h2.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              Text(
                ' BPM',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              FgButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
                backgroundColor: AppColors.gray800,
                textColor: AppColors.crystalWhite,
                size: FgButtonSize.md,
                shape: FgButtonShape.circle,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.gray950,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Background track
                      Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(vertical: 22.5),
                        decoration: BoxDecoration(
                          color: AppColors.gray700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Progress track
                      Container(
                        height: 3,
                        width:
                            MediaQuery.of(context).size.width * progress * 0.6,
                        margin: const EdgeInsets.symmetric(vertical: 22.5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.forgeFire.withOpacity(0.5),
                              AppColors.forgeFire,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Slider
                      Slider(
                        value: _bpm.toDouble(),
                        min: widget.minBPM.toDouble(),
                        max: widget.maxBPM.toDouble(),
                        onChanged: _onSliderChanged,
                        activeColor: AppColors.forgeFire,
                        inactiveColor: Colors.transparent,
                        thumbColor: AppColors.crystalWhite,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              FgButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
                backgroundColor: AppColors.gray800,
                textColor: AppColors.crystalWhite,
                size: FgButtonSize.md,
                shape: FgButtonShape.circle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
