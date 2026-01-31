import 'package:flutter/material.dart';

class AppInteractiveCardDeck extends StatefulWidget {
  final List<Widget> cards;
  final Function(int)? onIndexChanged;
  final bool isEnabled;

  const AppInteractiveCardDeck({
    super.key,
    required this.cards,
    this.onIndexChanged,
    this.isEnabled = true,
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
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) return const SizedBox.shrink();

    return PageView.builder(
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
        final isCurrent = index == _currentIndex;
        return AnimatedScale(
          scale: isCurrent ? 1.0 : 0.9,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.cards[index],
          ),
        );
      },
    );
  }
}
