import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

part 'fg_practice_meter.stories.g.dart';

const meta = Meta(FgPracticeMeter.new);

final $Meter = _Story(
  name: 'Quiet practice readout',
  args: _Args(
    elapsed: StringArg('00:00'),
    elapsedSemanticLabel: StringArg('0 active practice seconds'),
    target: StringArg('Target: 3 min'),
    status: StringArg('Ready'),
    metadata: StringArg('60 BPM · counts 1–8'),
    progress: DoubleArg(0),
  ),
  scenarios: [
    _Scenario(
      name: 'Active phrase',
      args: _Args(
        elapsed: StringArg('01:12'),
        elapsedSemanticLabel: StringArg('72 active practice seconds'),
        status: StringArg('Count 4'),
        activeCount: IntArg(4),
        progress: DoubleArg(0.4),
      ),
    ),
    _Scenario(
      name: 'Paused partial phrase',
      args: _Args(
        elapsed: StringArg('01:12'),
        elapsedSemanticLabel: StringArg('72 active practice seconds'),
        status: StringArg('Paused'),
        metadata: StringArg('60 BPM · counts 3–6'),
        firstCount: IntArg(3),
        lastCount: IntArg(6),
        progress: DoubleArg(0.4),
      ),
    ),
    _Scenario(
      name: 'Count-in',
      args: _Args(status: StringArg('Count-in: 4')),
    ),
  ],
);
