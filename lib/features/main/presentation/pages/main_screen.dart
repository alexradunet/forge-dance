import 'package:flutter/material.dart';

import '../../../../design_system/organisms/navigation/app_bottom_nav.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../library/presentation/pages/collection_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../workout/presentation/pages/training_session_page.dart';
import '../../../../design_system/templates/learning_path_page_template.dart';
import '../../../../design_system/molecules/learning/app_lesson_node.dart';

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
      return LearningPathPageTemplate(
        title: 'BREAKING 101',
        subtitle: 'Fundamentals • Module 1',
        onBack: () {
          setState(() {
            _subPage = null;
          });
        },
        children: const [
          AppLessonNode(
            title: "History of Bounce",
            type: AppLessonNodeType.theory,
            status: AppLessonNodeStatus.completed,
            duration: "15 min",
          ),
          AppLessonNode(
            title: "Groove Basics",
            type: AppLessonNodeType.movement,
            status: AppLessonNodeStatus.active,
            duration: "25 min",
          ),
          AppLessonNode(
            title: "Timing Drill",
            type: AppLessonNodeType.drill,
            status: AppLessonNodeStatus.locked,
            duration: "20 min",
          ),
          AppLessonNode(
            title: "Flow Lab",
            type: AppLessonNodeType.experiment,
            status: AppLessonNodeStatus.locked,
            duration: "30 min",
          ),
          AppLessonNode(
            title: "The Forge Finale",
            type: AppLessonNodeType.drill,
            status: AppLessonNodeStatus.locked,
            duration: "Boss",
          ),
        ],
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
