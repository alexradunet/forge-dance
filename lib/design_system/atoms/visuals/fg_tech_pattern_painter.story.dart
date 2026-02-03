import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_tech_pattern_painter.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgTechPatternPainter, // Associates with the painter class
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgTechPatternPainterPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: CustomPaint(
        size: const Size(300, 300),
        painter: FgTechPatternPainter(
          color: context.knobs.color(
            label: 'Color',
            initialValue: Colors.white,
          ),
          opacity: context.knobs.double.slider(
            label: 'Opacity',
            initialValue: 0.2,
            min: 0,
            max: 1,
          ),
          spacing: context.knobs.double.slider(
            label: 'Spacing',
            initialValue: 20,
            min: 10,
            max: 50,
          ),
          isGrid: context.knobs.boolean(
            label: 'Is Grid',
            initialValue: false,
          ),
        ),
      ),
    ),
  );
}
