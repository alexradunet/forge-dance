import 'package:flutter/material.dart';

import '../../../../design_system/organisms/navigation/app_bottom_nav.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../learning/presentation/pages/learning_path_page.dart';
import '../../../workout/presentation/pages/training_session_page.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
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
    if (_subPage == 'lesson-path') {
      return LearningPathPage(
        onNavigate: (page) {
          setState(() {
            _subPage = page == 'explore' ? null : page;
            if (page == 'explore') _currentIndex = 1;
            if (page == 'training') _subPage = 'training';
          });
        },
      );
    }

    if (_subPage == 'training') {
      return TrainingSessionPage(
        onClose: () {
          setState(() {
            _subPage = null;
          });
        },
      );
    }

    return IndexedStack(
      index: _currentIndex,
      children: [
        const Center(
            child: Text('Collection',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold))),
        ExplorePage(
          onNavigate: (page) {
            setState(() {
              _subPage = page;
            });
          },
        ),
        const HomePage(),
        const Center(
            child: Text('Stats',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold))),
        const Center(
            child: Text('Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
