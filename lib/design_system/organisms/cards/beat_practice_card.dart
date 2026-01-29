import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';

/// Beat Practice Card matching deck_11 mockup style
/// Features holo-foil effect, tap zone, and interactive rhythm display
class BeatPracticeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String rhythm;
  final int bpm;
  final int currentStreak;
  final VoidCallback? onTap;
  final VoidCallback? onFlip;
  final VoidCallback? onComplete;

  const BeatPracticeCard({
    super.key,
    this.title = 'BEAT',
    this.subtitle = 'PRACTICE',
    this.rhythm = 'Syncopated 8ths',
    this.bpm = 112,
    this.currentStreak = 12,
    this.onTap,
    this.onFlip,
    this.onComplete,
  });

  @override
  State<BeatPracticeCard> createState() => _BeatPracticeCardState();
}

class _BeatPracticeCardState extends State<BeatPracticeCard>
    with TickerProviderStateMixin {
  late AnimationController _blobController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _blobController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background with animated blobs
            _buildBackground(),
            // Holo-foil overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Positioned.fill(
              child: Column(
                children: [
                  // Flip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildFlipButton(),
                    ),
                  ),
                  // Title section
                  _buildTitleSection(),
                  // Tap zone
                  Expanded(
                    child: _buildTapZone(),
                  ),
                  // Info footer
                  _buildInfoFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _blobController,
      builder: (context, child) {
        return Stack(
          children: [
            // Base gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade900,
                    Colors.black,
                    Colors.grey.shade900,
                  ],
                ),
              ),
            ),
            // Animated blobs
            Positioned(
              top: -40 + 30 * _blobController.value,
              left: -40 - 20 * _blobController.value,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      blurRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 100 - 20 * _blobController.value,
              right: -40 + 30 * _blobController.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -20 + 15 * _blobController.value,
              left: 40 + 20 * _blobController.value,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      blurRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlipButton() {
    return GestureDetector(
      onTap: widget.onFlip,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
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
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 56,
              color: Colors.white,
              letterSpacing: 8,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 56,
              color: Colors.white.withOpacity(0.5),
              letterSpacing: 8,
              height: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapZone() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseScale = 1 + 0.1 * _pulseController.value;
        final ringOpacity = 0.1 + 0.2 * (1 - _pulseController.value);

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ping rings
              Transform.scale(
                scale: 1.4 * pulseScale,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange.withOpacity(ringOpacity * 0.3),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.2 * pulseScale,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange.withOpacity(ringOpacity),
                    ),
                  ),
                ),
              ),
              // Main tap zone
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: Colors.orange,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.25),
                        blurRadius: 50,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 36,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TAP ZONE',
                        style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Rhythm
          Expanded(
            child: Column(
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
                const SizedBox(height: 4),
                Text(
                  widget.rhythm,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.1),
          ),
          // BPM
          Expanded(
            child: Column(
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
                const SizedBox(height: 4),
                Text(
                  widget.bpm.toString(),
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 28,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.1),
          ),
          // Streak
          Expanded(
            child: Column(
              children: [
                Text(
                  'STREAK',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.currentStreak.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
