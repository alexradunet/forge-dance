import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../organisms/navigation/app_header.dart';

class LearningPathPageTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final List<Widget> children;

  const LearningPathPageTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          _buildGridBackground(),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppHeader(
                  title: title,
                  subtitle: subtitle,
                  onBack: onBack,
                ),
              ),
              // Replaced AppProgressBar with just spacing if needed, or nothing
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                sliver: SliverToBoxAdapter(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      _buildPathLine(children.length),
                      Column(
                        children: children
                            .map((child) => _buildNodeWrapper(child: child))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GridPainter(color: Colors.white.withOpacity(0.02)),
      ),
    );
  }

  Widget _buildPathLine(int nodeCount) {
    // Estimate height based on node count. A bit naive but works for the template visual
    final estimatedHeight = nodeCount * 140.0;

    return Container(
      width: 2,
      height: estimatedHeight > 0 ? estimatedHeight : 800,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.forgeFire,
            AppColors.forgeFire.withOpacity(0.5),
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildNodeWrapper({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: child,
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const step = 32.0;

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
