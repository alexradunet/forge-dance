import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/app_interactive_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/app_atomic_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Base Interactive',
  type: AppInteractiveCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildAppInteractiveCardBase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: SizedBox(
        width: 340,
        height: 520,
        child: AppInteractiveCard(
          title: 'BASIC BOUNCE',
          backgroundImage:
              'https://images.unsplash.com/photo-1535531492719-751aa1995c97?q=80&w=400&auto=format&fit=crop',
          level: 'BEGINNER',
          tags: const ['HIP HOP', 'FOUNDATION'],
          backContent: const Center(
            child: Text(
              'Back content for detail information.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: const Center(
            child: Text(
              'Footer Detail Section',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Atomic Card',
  type: AppAtomicCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildAppAtomicCard(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: SizedBox(
        width: 340,
        height: 520,
        child: AppAtomicCard(
          title: 'POWER TOP',
          category: 'BREAKING',
          level: 'ADVANCED',
          bodyPart: 'CORE',
          intensity: 'HIGH',
          imageUrl:
              'https://images.unsplash.com/photo-1547153760-18fc86324498?q=80&w=400&auto=format&fit=crop',
        ),
      ),
    ),
  );
}
