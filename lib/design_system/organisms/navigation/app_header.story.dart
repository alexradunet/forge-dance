import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/navigation/app_header.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppHeader,
  path: 'Design System/Organisms/Navigation',
)
Widget buildAppHeaderPlayground(BuildContext context) {
  return FgBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          AppHeader(
            title:
                context.knobs.string(label: 'Title', initialValue: 'WORKOUT'),
            subtitle: context.knobs.string(
                label: 'Subtitle', initialValue: 'High Intensity Interval'),
            isTransparent:
                context.knobs.boolean(label: 'Transparent', initialValue: true),
            onBack: context.knobs
                    .boolean(label: 'Show Back Button', initialValue: true)
                ? () {}
                : null,
            rightSlot: context.knobs
                    .boolean(label: 'Show Right Slot', initialValue: true)
                ? IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  )
                : null,
          ),
          const Expanded(child: Center(child: Text("Page Content"))),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppHeader,
  path: 'Design System/Organisms/Navigation',
)
Widget buildAppHeaderShowcase(BuildContext context) {
  return FgBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 20),
          AppHeader(
            title: 'HOME DASHBOARD',
            subtitle: 'Welcome Back',
            rightSlot: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 50),
          AppHeader(
            title: 'LESSON PLAYER',
            onBack: () {},
          ),
        ],
      ),
    ),
  );
}
