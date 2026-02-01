import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';

enum LessonNodeType { theory, drill, movement, experiment, boss }

enum LessonNodeState { completed, current, locked }

class LessonNode {
  final String title;
  final LessonNodeType type;
  final LessonNodeState state;
  final String duration;
  final String difficulty;
  final double progress; // 0.0 to 1.0

  const LessonNode({
    required this.title,
    required this.type,
    required this.state,
    required this.duration,
    this.difficulty = 'Beginner',
    this.progress = 0.0,
  });
}

class LessonPathTimeline extends StatelessWidget {
  final List<LessonNode> nodes;
  final Function(String)? onNavigate;

  const LessonPathTimeline({
    super.key,
    required this.nodes,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Central Gradient Line
        Positioned.fill(
          child: Center(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.forgeFire.withOpacity(0.8),
                    AppColors.forgeFire,
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: const [0.0, 0.4, 0.8],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Nodes
        Column(
          children: nodes.map((node) => _buildNode(context, node)).toList(),
        ),
      ],
    );
  }

  Widget _buildNode(BuildContext context, LessonNode node) {
    switch (node.type) {
      case LessonNodeType.boss:
        return _buildBossNode(node);
      case LessonNodeType.movement:
        return _buildMovementNode(context, node);
      default:
        return _buildStandardNode(node);
    }
  }

  Widget _buildStandardNode(LessonNode node) {
    final isCompleted = node.state == LessonNodeState.completed;
    final isLocked = node.state == LessonNodeState.locked;

    // Determine alignment based on visual rhythm or fixed logic
    // For standard nodes in the design:
    // Theory -> Left Text, Center Node
    // Drill/Experiment -> Text alternates or is consistent.
    // Reference image shows Theory L -> R (Text on Left), Drill R -> L (Text on Right)
    // Let's assume alternating for variety if not explicitly strictly defined,
    // but reference 'Theory' text is on the LEFT side (padding-right).
    // The code reference: "absolute right-[55%] ... text-right" -> Text is on Left.

    // Let's default to Text-Left for Theory, Text-Right for Drill/Experiment based on the image locking
    final isTextLeft = node.type == LessonNodeType.theory;

    return Container(
      margin: const EdgeInsets.only(bottom: 48),
      height: 80, // Fixed height for alignment
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgDeep,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? AppColors.forgeFire
                    : Colors.white.withOpacity(0.2),
                width: isCompleted ? 3 : 2,
              ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                          color: AppColors.forgeFire.withOpacity(0.4),
                          blurRadius: 12)
                    ]
                  : null,
            ),
            child: Center(
              child: Icon(
                isCompleted ? Icons.check : Icons.lock,
                color: isCompleted ? AppColors.forgeFire : AppColors.textMuted,
                size: 20,
              ),
            ),
          ),

          // Text Content
          Align(
            alignment:
                isTextLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.45, // Leave space for center
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isTextLeft
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    node.type.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 12,
                      color:
                          isLocked ? AppColors.textMuted : AppColors.forgeFire,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    node.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? AppColors.textMuted : Colors.white,
                      height: 1.2,
                    ),
                    textAlign: isTextLeft ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementNode(BuildContext context, LessonNode node) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      child: Column(
        children: [
          // Card
          GestureDetector(
            onTap: () => onNavigate?.call('ignite'),
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.forgeFire),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: -5,
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image / Banner Area
                  SizedBox(
                    height: 130,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image Placeholdder
                        Image.network(
                          'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
                        ),

                        // Badge
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.forgeFire.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'CURRENT LESSON',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Play Button (Floating)
                        Positioned(
                          top: -40,
                          right: 0,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.forgeFire,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.surfaceCard, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.forgeFire.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 28),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.type.name.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Bebas Neue',
                                fontSize: 12,
                                color: AppColors.forgeFire,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              node.title.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Bebas Neue',
                                fontSize: 24,
                                color: Colors.white,
                                letterSpacing: 1,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.schedule,
                                    size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  node.duration,
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  width: 1,
                                  height: 12,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                Icon(Icons.bar_chart,
                                    size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  node.difficulty,
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Progress
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progress',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                                Text(
                                  '${(node.progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: node.progress,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.forgeFire),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48), // Spacing after card
        ],
      ),
    );
  }

  Widget _buildBossNode(LessonNode node) {
    return Container(
      margin:
          const EdgeInsets.only(top: 24, bottom: 96), // Extra bottom padding
      child: Column(
        children: [
          // Glowing Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surfaceDark,
                  Colors.black,
                ],
              ),
              border: Border.all(color: AppColors.legendGold.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.legendGold.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.legendGold,
                  size: 36,
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child:
                        Icon(Icons.lock, size: 14, color: AppColors.textMuted),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Text
          Text(
            'FINAL CHALLENGE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.legendGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'BOSS SHOWCASE',
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 32,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 160,
            child: Text(
              'Combine all elements to unlock the next module.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
