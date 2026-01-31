import 'package:flutter/material.dart';

/// A carousel widget for cycling through elements.
///
/// Wraps a [PageView] with standardized physics and optional scaling effects.
class FgCarousel extends StatefulWidget {
  final List<Widget> items;
  final ValueChanged<int>? onIndexChanged;
  final bool isEnabled;
  final double viewportFraction;
  final EdgeInsetsGeometry? padding;
  final bool enableScaleEffect;

  const FgCarousel({
    super.key,
    required this.items,
    this.onIndexChanged,
    this.isEnabled = true,
    this.viewportFraction = 1.0,
    this.padding,
    this.enableScaleEffect = false,
  });

  @override
  State<FgCarousel> createState() => _FgCarouselState();
}

class _FgCarouselState extends State<FgCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void didUpdateWidget(FgCarousel oldWidget) {
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
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
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
          if (!widget.enableScaleEffect) {
            return widget.items[index];
          }

          final isCurrent = index == _currentIndex;

          return AnimatedScale(
            scale: isCurrent ? 1.0 : 0.9,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: widget.items[index],
          );
        },
      ),
    );
  }
}
