import 'package:flutter/material.dart';

class AppInteractiveCardDeck extends StatefulWidget {
  final List<Widget> cards;
  final Function(int)? onIndexChanged;
  final bool isEnabled;
  final double viewportFraction;
  final EdgeInsetsGeometry? padding;

  const AppInteractiveCardDeck({
    super.key,
    required this.cards,
    this.onIndexChanged,
    this.isEnabled = true,
    this.viewportFraction = 1.0,
    this.padding,
  });

  @override
  State<AppInteractiveCardDeck> createState() => _AppInteractiveCardDeckState();
}

class _AppInteractiveCardDeckState extends State<AppInteractiveCardDeck>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void didUpdateWidget(AppInteractiveCardDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewportFraction != widget.viewportFraction) {
      _pageController.dispose();
      _pageController =
          PageController(viewportFraction: widget.viewportFraction);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.cards.length,
        physics: widget.isEnabled
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          widget.onIndexChanged?.call(index);
        },
        itemBuilder: (context, index) {
          // If viewportFraction is 1.0, we don't need scaling usually,
          // but we can keep it subtle or remove it.
          // If users want strictly same width, no scaling is better.
          final isCurrent = index == _currentIndex;
          final useScale = widget.viewportFraction < 1.0;

          if (!useScale) {
            return widget.cards[index];
          }

          return AnimatedScale(
            scale: isCurrent ? 1.0 : 0.9,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: widget.cards[index],
          );
        },
      ),
    );
  }
}
