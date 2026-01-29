import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/principle_theory_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PrincipleTheoryCard,
  path: '[Organisms]/Cards',
)
Widget buildPrincipleTheoryCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 560,
          width: 340,
          child: PrincipleTheoryCard(
            moduleLabel: 'Module 4',
            moduleTitle: 'Biomechanics',
            principleTitle: 'THE PHYSICS OF',
            highlightWord: 'BALANCE',
            keyConcept: 'Center of Gravity (COG)',
            difficulty: 'Advanced',
            difficultyLevel: 3,
            proTip: '"Imagine a plumb line dropping from your navel to the floor. Keep it between your hands."',
            onFlip: () {},
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Beginner',
  type: PrincipleTheoryCard,
  path: '[Organisms]/Cards',
)
Widget buildPrincipleTheoryCardBeginner(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 560,
          width: 340,
          child: PrincipleTheoryCard(
            moduleLabel: 'Module 1',
            moduleTitle: 'Foundations',
            principleTitle: 'THE ART OF',
            highlightWord: 'POSTURE',
            keyConcept: 'Neutral Spine Alignment',
            difficulty: 'Beginner',
            difficultyLevel: 1,
            proTip: '"Stack your shoulders over your hips, and your hips over your ankles."',
            onFlip: () {},
          ),
        ),
      ),
    ),
  );
}
