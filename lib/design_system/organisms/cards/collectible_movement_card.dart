import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';

/// Collectible Movement Card matching deck_15 mockup style
/// Features foil holographic border effect and 3D view toggle
class CollectibleMovementCard extends StatefulWidget {
  final String title;
  final String category;
  final String rhythm;
  final int bpm;
  final List<String> tags;
  final VoidCallback? onFlip;
  final VoidCallback? onComplete;

  const CollectibleMovementCard({
    super.key,
    required this.title,
    this.category = 'Power Move',
    this.rhythm = 'Syncopated',
    this.bpm = 102,
    this.tags = const ['Footwork', 'Foundation'],
    this.onFlip,
    this.onComplete,
  });

  @override
  State<CollectibleMovementCard> createState() => _CollectibleMovementCardState();
}

class _CollectibleMovementCardState extends State<CollectibleMovementCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.forgeFire.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Foil border background
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: const [
                        Color(0xFFFF00CC),
                        Color(0xFF3333FF),
                        Color(0xFF00FFCC),
                        Color(0xFFFF00CC),
                      ],
                      stops: [
                        0.0,
                        _shimmerController.value,
                        _shimmerController.value + 0.3,
                        1.0,
                      ].map((e) => e.clamp(0.0, 1.0)).toList(),
                    ),
                  ),
                );
              },
            ),
            // Inner card
            Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Column(
                  children: [
                    // Hero image area
                    Expanded(
                      flex: 3,
                      child: _buildHeroSection(),
                    ),
                    // Title section
                    _buildTitleSection(),
                    // Info footer
                    _buildInfoFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade900,
            Colors.purple.shade900,
            Colors.grey.shade900,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated blob backgrounds
          Positioned(
            top: -20,
            left: -40,
            child: _buildBlob(Colors.purple.shade500, 180),
          ),
          Positioned(
            top: -10,
            right: -40,
            child: _buildBlob(Colors.blue.shade600, 150),
          ),
          Positioned(
            bottom: -20,
            left: 80,
            child: _buildBlob(Colors.pink.shade600, 160),
          ),
          // Noise overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    const Color(0xFF121212).withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          // 3D View badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.view_in_ar,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '3D View',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forgeFire,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 42,
                    color: Colors.white,
                    letterSpacing: 2,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),
          // Flip button
          GestureDetector(
            onTap: widget.onFlip,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceDark,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.flip_camera_android,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFooter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Wrap(
            spacing: 8,
            children: widget.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.electricBlue.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electricBlue,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Rhythm and BPM info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                // Rhythm visualizer
                Row(
                  children: List.generate(8, (i) {
                    final height = [0.4, 0.7, 1.0, 0.6, 0.3, 0.5, 0.8, 0.5][i];
                    final isActive = i < 4;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      width: 3,
                      height: 24 * height,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.forgeFire
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    );
                  }),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 1,
                  height: 24,
                  color: Colors.white.withOpacity(0.1),
                ),
                // Rhythm label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RHYTHM',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      widget.rhythm,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // BPM
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'BPM',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      widget.bpm.toString(),
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
