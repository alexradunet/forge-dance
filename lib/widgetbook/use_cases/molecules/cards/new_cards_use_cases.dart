import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: WideHeroCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildWideHeroCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: WideHeroCard(
          title: 'Hip-Hop Fundamentals',
          badgeText: '120 VIDEOS',
          viewCount: '24K',
          imageUrl: null,
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: FeatureCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFeatureCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FeatureCard(
          title: 'Breaking Flow Series',
          categoryLabel: 'POWER MOVES',
          accentColor: AppColors.breakingBlue,
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: CompactCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildCompactCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CompactCard(
          title: 'Toprock Basics',
          subtitle: '12 lessons',
          rewardLabel: '+150 XP',
          currentProgress: 4,
          totalProgress: 6,
          actionLabel: 'CONTINUE',
          onAction: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: VerticalCompactCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildVerticalCompactCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 160,
        child: VerticalCompactCard(
          title: 'Power Step',
          badgeText: 'NEW',
          badgeColor: AppColors.forgeFire,
          duration: '4 min',
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: PortraitCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildPortraitCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 280,
        child: PortraitCard(
          title: 'Hip-Hop Workshop',
          subtitle: '4-week intensive',
          badgeText: 'Live',
          participantCount: '128',
          actionLabel: 'Join Now',
          actionIcon: Icons.add,
          onAction: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: TallFeatureCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildTallFeatureCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 280,
        child: TallFeatureCard(
          name: 'Marcus "Flash" Williams',
          nickname: 'Flash',
          tagline: 'Breaking champion with 15 years of experience teaching fundamentals',
          accentColor: AppColors.mysticPurple,
          stats: const [
            TallFeatureCardStat(value: '15+', label: 'Years'),
            TallFeatureCardStat(value: '50K', label: 'Students'),
            TallFeatureCardStat(value: '4.9', label: 'Rating'),
          ],
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: SquareTile,
  path: 'Design System/Molecules/Cards',
)
Widget buildSquareTile(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SquareTile(
            label: 'Hip-Hop',
            icon: Icons.music_note,
            accentColor: AppColors.hipHopPurple,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          SquareTile(
            label: 'Breaking',
            icon: Icons.sports_gymnastics,
            accentColor: AppColors.breakingBlue,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: MediumSquareCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildMediumSquareCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 200,
        child: MediumSquareCard(
          title: 'Popping Basics',
          subtitle: 'Master isolations and hits',
          badgeText: 'Trending',
          badgeColor: AppColors.forgeFire,
          onTap: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Default',
  type: HeroSquareCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildHeroSquareCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SizedBox(
        width: 340,
        child: HeroSquareCard(
          title: 'WEEKLY',
          titleSecondLine: 'CHALLENGE',
          badgeText: 'New',
          seriesLabel: 'Week #12',
          premiumLabel: 'PREMIUM',
          infoItems: const [
            HeroSquareCardInfo(icon: Icons.timer, text: '30 min'),
            HeroSquareCardInfo(icon: Icons.local_fire_department, text: '350 XP'),
          ],
          actionLabel: 'Start Challenge',
          actionIcon: Icons.play_arrow,
          onAction: () {},
        ),
      ),
    ),
  );
}
