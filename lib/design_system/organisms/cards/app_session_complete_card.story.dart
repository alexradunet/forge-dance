import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/app_session_complete_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppSessionCompleteCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildAppSessionCompleteCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 600,
          width: 350,
          child: AppSessionCompleteCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'SESSION COMPLETE'),
            subtitle: context.knobs.string(
                label: 'Subtitle', initialValue: 'Great work! You crushed it.'),
          ),
        ),
      ),
    ),
  );
}
