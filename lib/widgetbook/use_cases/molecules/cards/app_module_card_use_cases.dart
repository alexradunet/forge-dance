import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/molecules/cards/app_module_card.dart';
import '../../../../design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppModuleCard,
  path: 'Design System/Molecules/AppModuleCard',
)
Widget buildAppModuleCardShowcase(BuildContext context) {
  const imageUrl =
      'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=400&auto=format&fit=crop';

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('HERO', style: TextStyle(color: Colors.white, fontSize: 10)),
        SizedBox(height: 8),
        AppModuleCard(
          title: 'MASTER HIP HOP',
          category: 'HIP HOP',
          imageUrl: imageUrl,
          progress: 45,
          completedLessons: 4,
          totalLessons: 12,
          type: AppModuleCardType.hero,
          description: 'Level up your dance with pro techniques and movements.',
          duration: '45m',
          badge: 'NEW',
        ),
        SizedBox(height: 32),
        Text('MEDIUM (DEFAULT)',
            style: TextStyle(color: Colors.white, fontSize: 10)),
        SizedBox(height: 8),
        AppModuleCard(
          title: 'Foundation Basics',
          category: 'BREAKING',
          imageUrl: imageUrl,
          progress: 75,
          completedLessons: 9,
          totalLessons: 12,
        ),
        SizedBox(height: 32),
        Text('SMALL', style: TextStyle(color: Colors.white, fontSize: 10)),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppModuleCard(
                title: 'Power Moves',
                category: 'TECHNIQUE',
                imageUrl: imageUrl,
                progress: 20,
                completedLessons: 2,
                totalLessons: 10,
                type: AppModuleCardType.small,
              ),
              SizedBox(width: 16),
              AppModuleCard(
                title: 'Rhythm Sync',
                category: 'CHOREO',
                imageUrl: imageUrl,
                progress: 10,
                completedLessons: 1,
                totalLessons: 10,
                type: AppModuleCardType.small,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
