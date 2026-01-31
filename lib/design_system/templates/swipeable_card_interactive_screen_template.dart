import 'package:flutter/material.dart';

import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/organisms/navigation/app_header.dart';
import '../../design_system/atoms/progress/app_progress_bar.dart';
import '../../design_system/molecules/navigation/app_floating_action_bar.dart';
import '../../design_system/organisms/cards/app_interactive_card_deck.dart';

/// Template for Interactive Screens with a Swipeable Card Deck
/// Automatically manages progress based on current card index
class SwipeableCardInteractiveScreenTemplate extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Widget> cards;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;
  final Widget? bottomAction;
  final bool showProgress;

  const SwipeableCardInteractiveScreenTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cards,
    this.onBack,
    this.onMenu,
    this.bottomAction,
    this.showProgress = true,
  });

  @override
  State<SwipeableCardInteractiveScreenTemplate> createState() =>
      _SwipeableCardInteractiveScreenTemplateState();
}

class _SwipeableCardInteractiveScreenTemplateState
    extends State<SwipeableCardInteractiveScreenTemplate> {
  int _currentIndex = 0;

  // Consistent padding for aligned elements
  static const double _horizontalPadding = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      extendBody: true,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(color: Colors.white.withOpacity(0.02)),
            ),
          ),

          Column(
            children: [
              // Header
              SafeArea(
                bottom: false,
                child: AppHeader(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  onBack: widget.onBack,
                  rightSlot: widget.onMenu != null
                      ? IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: widget.onMenu,
                        )
                      : null,
                ),
              ),

              // Progress Indicator (Segmented)
              if (widget.showProgress && widget.cards.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: AppProgressBar.segmented(
                    total: widget.cards.length,
                    current: _currentIndex,
                    height: 4,
                    color: AppColors.forgeFire,
                    spacing: 4.0,
                  ),
                ),

              // Main Content (Interactive Deck)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.md,
                    bottom: 100, // Bottom padding for FAB
                  ),
                  child: AppInteractiveCardDeck(
                    cards: widget.cards,
                    // Use viewport fraction 1.0 and explicit padding to ensure precise width matching
                    viewportFraction: 1.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalPadding),
                    onIndexChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          // Floating Action Bar (Bottom Center)
          if (widget.bottomAction != null)
            Positioned(
              left: _horizontalPadding,
              right: _horizontalPadding,
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
              child: AppFloatingActionBar(
                children: [
                  Expanded(child: widget.bottomAction!),
                ],
              ),
            ),
        ],
      ),
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
    const step = 40.0;
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
