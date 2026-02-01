import 'package:flutter/material.dart';

import '../../../../design_system/organisms/navigation/app_bottom_nav.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../library/presentation/pages/collection_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../workout/presentation/pages/training_session_page.dart';
import '../../../learn/ui/module_view_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Default to Home
  String? _subPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNav(
              currentIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                  // The AppBottomNav widget itself needs to be updated to reflect the new label/icon for index 3.
                  // This change is internal to AppBottomNav and cannot be made from MainScreen directly.
                  // Assuming AppBottomNav will be updated to show 'Workout' with Icons.fitness_center for index 3.
                  _subPage = null; // Clear sub-page on tab change
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_subPage == 'training') {
      return TrainingSessionPage(
        onClose: () {
          setState(() {
            _subPage = null;
          });
        },
      );
    }

    if (_subPage == 'lesson-path') {
      return ModuleViewScreen(
        onBack: () {
          setState(() {
            _subPage = null;
          });
        },
      );
    }

    return IndexedStack(
      index: _currentIndex,
      children: [
        const CollectionPage(),
        ExplorePage(
          onNavigate: (page) {
            setState(() {
              if (page == 'home') {
                _currentIndex = 2;
                _subPage = null;
              } else {
                _subPage = page;
              }
            });
          },
        ),
        HomePage(
          onNavigate: (page) {
            setState(() {
              if (page == 'explore') {
                _currentIndex = 1;
              } else {
                _subPage = page;
              }
            });
          },
        ),
        TrainingSessionPage(
          onClose: () {
            setState(() {
              _currentIndex = 2; // Go back to Home
            });
          },
        ),
        const ProfilePage(),
      ],
    );
  }
}
