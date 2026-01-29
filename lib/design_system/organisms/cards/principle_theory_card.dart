import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';

/// Principle Theory Card matching deck_17 mockup style
/// Features scan line animation, grid overlay, and Pro Tip section
class PrincipleTheoryCard extends StatefulWidget {
  final String moduleLabel;
  final String moduleTitle;
  final String principleTitle;
  final String highlightWord;
  final String keyConcept;
  final String difficulty;
  final int difficultyLevel; // 1-3
  final String proTip;
  final VoidCallback? onFlip;
  final VoidCallback? onConfirm;

  const PrincipleTheoryCard({
    super.key,
    this.moduleLabel = 'Module 4',
    this.moduleTitle = 'Biomechanics',
    this.principleTitle = 'THE PHYSICS OF',
    this.highlightWord = 'BALANCE',
    this.keyConcept = 'Center of Gravity (COG)',
    this.difficulty = 'Advanced',
    this.difficultyLevel = 3,
    this.proTip = '"Imagine a plumb line dropping from your navel to the floor. Keep it between your hands."',
    this.onFlip,
    this.onConfirm,
  });

  @override
  State<PrincipleTheoryCard> createState() => _PrincipleTheoryCardState();
}

class _PrincipleTheoryCardState extends State<PrincipleTheoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Back cards (stacked deck effect)
        Positioned(
          top: 8,
          left: 20,
          right: 20,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 12,
          right: 12,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
          ),
        ),
        // Main card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.forgeFire.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.forgeFire.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              children: [
                // Image section with scan line
                Expanded(
                  child: _buildImageSection(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background with gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                const Color(0xFF1E1E1E),
              ],
            ),
          ),
        ),
        // Grid overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(),
          ),
        ),
        // Scan line animation
        AnimatedBuilder(
          animation: _scanController,
          builder: (context, child) {
            return Positioned(
              top: _scanController.value * MediaQuery.of(context).size.height * 0.5,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.forgeFire.withOpacity(
                    (1 - (_scanController.value - 0.5).abs() * 2) * 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forgeFire.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Live render badge
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'LIVE RENDER',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Flip button
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: widget.onFlip,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Center(
                child: Icon(
                  Icons.flip_camera_android,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // Title overlay
        Positioned(
          left: 16,
          right: 16,
          bottom: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PRINCIPLE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.principleTitle,
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 40,
                  color: Colors.white,
                  letterSpacing: 2,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              Text(
                widget.highlightWord,
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 40,
                  color: AppColors.forgeFire,
                  letterSpacing: 2,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        // Info panel
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildInfoPanel(),
        ),
      ],
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          // Accent line
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.cyan.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Key concept and difficulty row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KEY CONCEPT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.keyConcept,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'DIFFICULTY',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.difficulty,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.forgeFire,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          children: List.generate(3, (i) {
                            return Container(
                              margin: const EdgeInsets.only(left: 2),
                              width: 4,
                              height: 12,
                              decoration: BoxDecoration(
                                color: i < widget.difficultyLevel
                                    ? AppColors.forgeFire
                                    : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: i < widget.difficultyLevel
                                    ? [
                                        BoxShadow(
                                          color: AppColors.forgeFire.withOpacity(0.6),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Pro tip section
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.legendGold.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border(
                left: BorderSide(
                  color: AppColors.legendGold,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 12,
                      color: AppColors.legendGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'PRO TIP',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.legendGold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.proTip,
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
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

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 20.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
