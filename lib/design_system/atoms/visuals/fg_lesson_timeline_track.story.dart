import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_lesson_timeline_track.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLessonTimelineTrack,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgLessonTimelineTrackPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Container(
        height: 200,
        alignment: Alignment.center,
        child: FgLessonTimelineTrack(
          width: context.knobs.double
              .slider(label: 'Width', initialValue: 2, min: 1, max: 10),
        ),
      ),
    ),
  );
}
