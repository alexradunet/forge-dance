import 'package:flutter/material.dart';
import '../../organisms/cards/app_interactive_card.dart';

class AppMiniInteractiveCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? level;
  final String backgroundImage;
  final String style;
  final String difficulty;
  final VoidCallback? onTap;

  const AppMiniInteractiveCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    this.subtitle,
    this.level,
    this.style = 'Hip Hop',
    this.difficulty = 'Easy',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppInteractiveCard(
      title: title,
      subtitle: subtitle ?? 'Lesson 1: Foundation',
      backgroundImage: backgroundImage,
      level: level,
      style: style,
      difficulty: difficulty,
      onTap: onTap,
      backTitle: 'PATTERN INFO',
      backSubtitle: 'Rhythm Structure',
      backContent: _buildBackContent(),
    );
  }

  Widget _buildBackContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
          style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
        ),
        const SizedBox(height: 20),
        _buildRhythmBar('Kick', 0.8, Colors.orange),
        const SizedBox(height: 12),
        _buildRhythmBar('Snare', 0.6, Colors.blue),
        const SizedBox(height: 12),
        _buildRhythmBar('Hi-Hat', 0.9, Colors.purple),
      ],
    );
  }

  Widget _buildRhythmBar(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white54, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.4), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
