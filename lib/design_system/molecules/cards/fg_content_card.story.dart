import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgContentCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFgContentCardPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FgContentCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Advanced HIIT Training'),
            subtitle: context.knobs.string(
                label: 'Subtitle',
                initialValue: 'High intensity cardio module'),
            imageUrl: context.knobs.string(
                label: 'Image URL',
                initialValue: 'https://picsum.photos/400/300'),
            variant: context.knobs.list(
              label: 'Variant',
              options: FgContentCardVariant.values,
              initialOption: FgContentCardVariant.standard,
            ),
            progress: context.knobs.doubleOrNull
                .slider(label: 'Progress', initialValue: 0.7, min: 0, max: 1),
            rating: context.knobs.doubleOrNull
                .slider(label: 'Rating', initialValue: 4.5, min: 0, max: 5),
            tags: ['Cardio', 'Advanced'], // Simplified for knobs
            footerLabel: '7/10 Lessons',
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgContentCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFgContentCardShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Standard (Vertical)',
            child: FgContentCard(
              title: 'Full Body Groove',
              subtitle: 'Learn the basics of rhythm and movement.',
              imageUrl: 'https://picsum.photos/id/10/400/300',
              tags: const ['Beginner', 'Dance'],
              progress: 0.45,
              footerLabel: '3/8 Modules',
            ),
          ),
          _Section(
            title: 'Compact',
            child: Row(
              children: [
                FgContentCard.compact(
                  title: 'Quick Hit',
                  tags: const ['Power'],
                  imageUrl: 'https://picsum.photos/id/30/200/200',
                  progress: 0.8,
                  footerLabel: '4/5 Lessons',
                ),
                const SizedBox(width: 16),
                FgContentCard.compact(
                  title: 'Power Up',
                  tags: const ['Technique'],
                  imageUrl: 'https://picsum.photos/id/40/200/200',
                  progress: 0,
                  footerLabel: '0/6 Lessons',
                ),
              ],
            ),
          ),
          _Section(
            title: 'Hero',
            child: FgContentCard.hero(
              title: 'Master Class: Hip Hop',
              subtitle: 'Join the world champion for an exclusive session.',
              imageUrl: 'https://picsum.photos/id/50/800/600',
              tags: const ['Exclusive', 'Pro'],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h5.copyWith(color: Colors.white)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
