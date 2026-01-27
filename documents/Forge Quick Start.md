---
type: Page
title: Forge Quick Start
description: null
icon: null
createdAt: '2026-01-23T23:01:31.106Z'
creationDate: 2026-01-24 01:01
modificationDate: 2026-01-26 01:00
tags: []
coverImage: null
---

# 🚀 FORGE.DANCE - QUICK START GUIDE

**Get from zero to deployed in 30 days with Flutter 3.38 + Firebase!** ⚡

---

## 📋 PHASE 1: SETUP (Days 1-3)

### Day 1: Environment & Tools Setup

```bash
# ✅ Install Required Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. Flutter SDK (3.38+)
# Download from: https://flutter.dev/docs/get-started/install
# Verify installation:
flutter --version  # Should show 3.38.0 or higher

# 2. Dart SDK (3.10+)
# Comes with Flutter, verify:
dart --version  # Should show 3.10.0 or higher

# 3. Git
# Download from: https://git-scm.com

# 4. VS Code + Extensions
# - Flutter extension
# - Dart extension
# - Firebase extension (optional)

# 5. Android Studio / Xcode
# - Android Studio for Android development
# - Xcode for iOS development (Mac only)
```

### Day 2: Firebase Account Setup

```bash
# ✅ Firebase Setup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. Create Firebase account
# → https://console.firebase.google.com/
# → Create new project: "forge-dance"

# 2. Enable Firebase services:
# → Authentication (Email/Password, Google, Apple)
# → Firestore Database (Start in test mode)
# → Firebase Storage (for videos/images)
# → Cloud Functions (for server logic)
# → Firebase Analytics
# → Cloud Messaging (FCM for push notifications)

# 3. Install Firebase CLI
npm install -g firebase-tools

# 4. Login to Firebase
firebase login

# 5. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 6. Configure Flutter app (we'll do this in Day 3)
```

### Day 3: Project Initialization

```bash
# ✅ Create Flutter Project
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Create project
flutter create forge_dance
cd forge_dance

# Configure Firebase
flutterfire configure
# Select your Firebase project
# Select platforms: iOS, Android, Web

# Install core dependencies
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add firebase_storage
flutter pub add firebase_messaging
flutter pub add firebase_analytics
flutter pub add firebase_functions

# State management
flutter pub add riverpod
flutter pub add riverpod_annotation
flutter pub add riverpod_generator
flutter pub add build_runner

# UI & Navigation
flutter pub add go_router
flutter pub add flutter_svg
flutter pub add cached_network_image

# Video playback
flutter pub add video_player
flutter pub add chewie

# Camera (for AI form analysis)
flutter pub add camera
flutter pub add image_picker

# Animations (using Flutter 3.38 features)
flutter pub add animations

# Utilities
flutter pub add intl
flutter pub add shared_preferences
flutter pub add package_info_plus

# Payments
flutter pub add stripe_flutter

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 💾 PHASE 2: FIREBASE SETUP (Days 4-5)

### Day 4: Firestore Database Structure

```dart
// lib/models/user.dart
class User {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  
  // Gamification
  final int powerLevel;
  final String forgeRank; // EMBER, FLAME, INFERNO, etc.
  final int forgePoints;
  final int totalWods;
  
  // Streaks
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  final int streakShields;
  
  // Preferences
  final String? primaryStyle;
  final int skillLevel;
  final int weeklyGoal;
  
  // Subscription
  final String subscriptionTier; // free, pro, legendary
  final String subscriptionStatus;
  final String? stripeCustomerId;
  
  final DateTime createdAt;
  final DateTime updatedAt;
  
  User({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.powerLevel = 0,
    this.forgeRank = 'EMBER',
    this.forgePoints = 0,
    this.totalWods = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastWorkoutDate,
    this.streakShields = 0,
    this.primaryStyle,
    this.skillLevel = 1,
    this.weeklyGoal = 3,
    this.subscriptionTier = 'free',
    this.subscriptionStatus = 'active',
    this.stripeCustomerId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // Firestore serialization
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      avatarUrl: data['avatarUrl'],
      powerLevel: data['powerLevel'] ?? 0,
      forgeRank: data['forgeRank'] ?? 'EMBER',
      forgePoints: data['forgePoints'] ?? 0,
      totalWods: data['totalWods'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      lastWorkoutDate: data['lastWorkoutDate']?.toDate(),
      streakShields: data['streakShields'] ?? 0,
      primaryStyle: data['primaryStyle'],
      skillLevel: data['skillLevel'] ?? 1,
      weeklyGoal: data['weeklyGoal'] ?? 3,
      subscriptionTier: data['subscriptionTier'] ?? 'free',
      subscriptionStatus: data['subscriptionStatus'] ?? 'active',
      stripeCustomerId: data['stripeCustomerId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'powerLevel': powerLevel,
      'forgeRank': forgeRank,
      'forgePoints': forgePoints,
      'totalWods': totalWods,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastWorkoutDate': lastWorkoutDate != null 
        ? Timestamp.fromDate(lastWorkoutDate!) 
        : null,
      'streakShields': streakShields,
      'primaryStyle': primaryStyle,
      'skillLevel': skillLevel,
      'weeklyGoal': weeklyGoal,
      'subscriptionTier': subscriptionTier,
      'subscriptionStatus': subscriptionStatus,
      'stripeCustomerId': stripeCustomerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

```dart
// lib/models/wod.dart
class WOD {
  final String id;
  final String title;
  final String? description;
  final String danceStyle;
  final int difficulty; // 1-10
  final int durationMinutes;
  final int forgePointsReward;
  final String requiredRank;
  final List<Exercise> exercises;
  final String? videoPreviewUrl;
  final String? thumbnailUrl;
  final DateTime? date; // For daily WODs
  final bool isFeatured;
  final bool isPremium;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  WOD({
    required this.id,
    required this.title,
    this.description,
    required this.danceStyle,
    required this.difficulty,
    required this.durationMinutes,
    required this.forgePointsReward,
    this.requiredRank = 'EMBER',
    required this.exercises,
    this.videoPreviewUrl,
    this.thumbnailUrl,
    this.date,
    this.isFeatured = false,
    this.isPremium = false,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory WOD.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WOD(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      danceStyle: data['danceStyle'] ?? '',
      difficulty: data['difficulty'] ?? 1,
      durationMinutes: data['durationMinutes'] ?? 0,
      forgePointsReward: data['forgePointsReward'] ?? 0,
      requiredRank: data['requiredRank'] ?? 'EMBER',
      exercises: (data['exercises'] as List?)
        ?.map((e) => Exercise.fromMap(e))
        .toList() ?? [],
      videoPreviewUrl: data['videoPreviewUrl'],
      thumbnailUrl: data['thumbnailUrl'],
      date: data['date']?.toDate(),
      isFeatured: data['isFeatured'] ?? false,
      isPremium: data['isPremium'] ?? false,
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'danceStyle': danceStyle,
      'difficulty': difficulty,
      'durationMinutes': durationMinutes,
      'forgePointsReward': forgePointsReward,
      'requiredRank': requiredRank,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'videoPreviewUrl': videoPreviewUrl,
      'thumbnailUrl': thumbnailUrl,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'isFeatured': isFeatured,
      'isPremium': isPremium,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Day 5: Seed Sample Data

```dart
// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Seed sample WODs
  Future<void> seedSampleData() async {
    final wodsRef = _firestore.collection('wods');
    
    // Sample WOD 1
    await wodsRef.doc('wod-001').set({
      'title': 'Hip Hop Thunder Strike',
      'description': 'Explosive hip hop fundamentals focusing on rhythm and isolation',
      'danceStyle': 'hip_hop',
      'difficulty': 5,
      'durationMinutes': 45,
      'forgePointsReward': 500,
      'requiredRank': 'EMBER',
      'exercises': [
        {'id': 'ex-001', 'name': 'Chest Pops', 'duration': 45},
        {'id': 'ex-002', 'name': 'Body Waves', 'duration': 45},
      ],
      'date': Timestamp.fromDate(DateTime(2026, 1, 25)),
      'isFeatured': true,
      'isPremium': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Sample WOD 2
    await wodsRef.doc('wod-002').set({
      'title': 'Contemporary Flow',
      'description': 'Graceful movements and emotional expression',
      'danceStyle': 'contemporary',
      'difficulty': 6,
      'durationMinutes': 50,
      'forgePointsReward': 600,
      'requiredRank': 'EMBER',
      'exercises': [
        {'id': 'ex-003', 'name': 'Floor Work', 'duration': 60},
        {'id': 'ex-004', 'name': 'Lyrical Turns', 'duration': 45},
      ],
      'date': Timestamp.fromDate(DateTime(2026, 1, 26)),
      'isFeatured': false,
      'isPremium': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Seed achievements
    final achievementsRef = _firestore.collection('achievements');
    await achievementsRef.doc('ach-001').set({
      'name': 'First Steps',
      'description': 'Complete your first WOD',
      'requirementType': 'wods_completed',
      'requirementValue': 1,
      'forgePoints': 50,
    });
    
    await achievementsRef.doc('ach-002').set({
      'name': 'Week Warrior',
      'description': 'Maintain a 7-day streak',
      'requirementType': 'streak',
      'requirementValue': 7,
      'forgePoints': 100,
    });
  }
}
```

---

## ⚡ PHASE 3: AUTHENTICATION & CORE SERVICES (Days 6-10)

### Day 6-7: Authentication Service

```dart
// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Sign up with email
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Update display name
    await credential.user?.updateDisplayName(username);
    
    // Create user document in Firestore
    await _createUserDocument(credential.user!.uid, email, username);
    
    return credential;
  }
  
  // Sign in with email
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    // Implementation using google_sign_in package
    // ...
  }
  
  // Create user document
  Future<void> _createUserDocument(
    String userId,
    String email,
    String username,
  ) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.set({
      'email': email,
      'username': username,
      'powerLevel': 0,
      'forgeRank': 'EMBER',
      'forgePoints': 0,
      'totalWods': 0,
      'currentStreak': 0,
      'longestStreak': 0,
      'streakShields': 0,
      'skillLevel': 1,
      'weeklyGoal': 3,
      'subscriptionTier': 'free',
      'subscriptionStatus': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// Riverpod provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
```

### Day 8-9: WOD Service

```dart
// lib/services/wod_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import '../models/wod.dart';

class WODService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get today's WOD
  Stream<WOD?> getTodayWOD() {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return _firestore
        .collection('wods')
        .where('date', isEqualTo: Timestamp.fromDate(DateTime.parse('${todayStr}T00:00:00')))
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return WOD.fromFirestore(snapshot.docs.first);
    });
  }
  
  // Get WOD by ID
  Future<WOD?> getWODById(String id) async {
    final doc = await _firestore.collection('wods').doc(id).get();
    if (!doc.exists) return null;
    return WOD.fromFirestore(doc);
  }
  
  // Complete WOD
  Future<void> completeWOD({
    required String userId,
    required String wodId,
    required int durationSeconds,
    required int gravityModifier,
    int? rating,
    String? notes,
  }) async {
    final batch = _firestore.batch();
    
    // Get WOD details
    final wodDoc = await _firestore.collection('wods').doc(wodId).get();
    final wod = WOD.fromFirestore(wodDoc);
    
    // Calculate forge points
    final forgePoints = (wod.forgePointsReward * gravityModifier).floor();
    
    // Create workout session
    final sessionRef = _firestore.collection('workout_sessions').doc();
    batch.set(sessionRef, {
      'userId': userId,
      'wodId': wodId,
      'completedAt': FieldValue.serverTimestamp(),
      'durationSeconds': durationSeconds,
      'gravityModifier': gravityModifier,
      'forgePointsEarned': forgePoints,
      'rating': rating,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Update user stats
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'powerLevel': FieldValue.increment(forgePoints),
      'totalWods': FieldValue.increment(1),
      'forgePoints': FieldValue.increment(forgePoints),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Update streak
    final today = DateTime.now();
    final streakRef = _firestore
        .collection('streak_days')
        .doc('${userId}_${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}');
    batch.set(streakRef, {
      'userId': userId,
      'date': Timestamp.fromDate(today),
      'completed': true,
    });
    
    await batch.commit();
  }
}

// Riverpod provider
final wodServiceProvider = Provider<WODService>((ref) {
  return WODService();
});
```

### Day 10: Navigation Setup (Using GoRouter)

```dart
// lib/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/wod/wod_detail_screen.dart';
import '../screens/wod/wod_player_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isOnboarding = state.uri.path == '/onboarding';
      final isAuth = state.uri.path == '/login' || state.uri.path == '/signup';
      
      if (!isLoggedIn && !isAuth) {
        return '/login';
      }
      
      if (isLoggedIn && isAuth) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/wod/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WODDetailScreen(wodId: id);
        },
      ),
      GoRoute(
        path: '/wod/:id/player',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WODPlayerScreen(wodId: id);
        },
      ),
    ],
  );
});
```

---

## 📱 PHASE 4: CORE SCREENS (Days 11-20)

### Day 11-12: Home Screen (Using Flutter 3.38 Features)

```dart
// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../../services/wod_service.dart';
import '../../widgets/wod_card.dart';
import '../../widgets/power_level_widget.dart';
import '../../widgets/streak_counter_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWOD = ref.watch(todayWODProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // forge-steel
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔥 THE FORGE',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: const Color(0xFFF0F8FF), // forge-crystal
                        fontFamily: 'Bebas Neue',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Where Legends Are Made',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Today's WOD
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: todayWOD.when(
                  data: (wod) => wod != null
                    ? WODCard(wod: wod)
                    : const Text('No WOD for today'),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ),
            ),
            
            // Progress Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Progress',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const PowerLevelWidget(),
                    const SizedBox(height: 16),
                    const StreakCounterWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider for today's WOD
final todayWODProvider = StreamProvider<WOD?>((ref) {
  final wodService = ref.watch(wodServiceProvider);
  return wodService.getTodayWOD();
});
```

### Day 13-15: WOD Card Widget (Using Dot Shorthands from Dart 3.10)

```dart
// lib/widgets/wod_card.dart
import 'package:flutter/material.dart';
import '../models/wod.dart';

class WODCard extends StatelessWidget {
  final WOD wod;
  final VoidCallback? onTap;
  
  const WODCard({
    super.key,
    required this.wod,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F2937), // gray-800
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: .start, // Dart 3.10 dot shorthand!
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: wod.thumbnailUrl != null
                ? Image.network(
                    wod.thumbnailUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Icon(Icons.video_library, size: 64),
                  ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          wod.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Bebas Neue',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Level ${wod.difficulty} • ${wod.durationMinutes} min • ${wod.danceStyle}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4500), // forge-fire
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'START WORKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Day 16-18: WOD Player Screen

```dart
// lib/screens/wod/wod_player_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:riverpod/riverpod.dart';

class WODPlayerScreen extends ConsumerStatefulWidget {
  final String wodId;
  
  const WODPlayerScreen({
    super.key,
    required this.wodId,
  });
  
  @override
  ConsumerState<WODPlayerScreen> createState() => _WODPlayerScreenState();
}

class _WODPlayerScreenState extends ConsumerState<WODPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int _currentExerciseIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadVideo();
  }
  
  Future<void> _loadVideo() async {
    // Get WOD and current exercise
    final wod = await ref.read(wodServiceProvider).getWODById(widget.wodId);
    if (wod == null || wod.exercises.isEmpty) return;
    
    final exercise = wod.exercises[_currentExerciseIndex];
    
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(exercise.videoUrl),
    );
    
    await _videoController!.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoController!.value.aspectRatio,
    );
    
    setState(() {});
  }
  
  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _chewieController != null
        ? Stack(
            children: [
              // Video player
              Center(
                child: Chewie(controller: _chewieController!),
              ),
              
              // Exercise info overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Exercise Name', // Get from current exercise
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Skip exercise
                            },
                            child: const Text('Skip'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Complete exercise
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4500),
                            ),
                            child: const Text('Complete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator()),
    );
  }
}
```

---

## 🌐 PHASE 5: SIMPLE WEB LANDING PAGE (Days 19-20)

### Day 19: Basic Landing Page

```dart
// web/index.html (keep simple for now)
<!DOCTYPE html>
<html>
<head>
  <title>forge.dance - Where Legends Are Forged</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
  <div id="app"></div>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

```dart
// web/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const ForgeWebApp());
}

class ForgeWebApp extends StatelessWidget {
  const ForgeWebApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'forge.dance',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF4500),
        scaffoldBackgroundColor: const Color(0xFF2C2C2C),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text(
              'FORGE.DANCE',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F8FF),
                fontFamily: 'Bebas Neue',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Where Legends Are Forged',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Link to app stores
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4500),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Download App',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 PHASE 6: DEPLOYMENT (Days 21-23)

### Day 21: Firebase Functions Setup

```bash
# Initialize Firebase Functions
cd functions
firebase init functions

# Install dependencies
cd functions
npm install
```

```typescript
// functions/src/index.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Cloud Function to update leaderboard
export const updateLeaderboard = functions.firestore
  .document('workout_sessions/{sessionId}')
  .onCreate(async (snap, context) => {
    const session = snap.data();
    const userId = session.userId;
    
    // Update user's leaderboard entry
    const userRef = admin.firestore().collection('users').doc(userId);
    const userDoc = await userRef.get();
    const user = userDoc.data();
    
    await admin.firestore().collection('leaderboard').doc(userId).set({
      userId: userId,
      username: user?.username,
      avatarUrl: user?.avatarUrl,
      totalForgePoints: user?.forgePoints || 0,
      totalWorkouts: user?.totalWods || 0,
      powerLevel: user?.powerLevel || 0,
      forgeRank: user?.forgeRank || 'EMBER',
      currentStreak: user?.currentStreak || 0,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
  });
```

### Day 22: Build & Deploy Mobile Apps

```bash
# Build for Android
flutter build apk --release
# or
flutter build appbundle --release

# Build for iOS (requires Mac)
flutter build ios --release

# Deploy to Firebase App Distribution (for testing)
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_ANDROID_APP_ID \
  --groups "testers"
```

### Day 23: Deploy Web

```bash
# Build web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Or deploy to any static hosting
# The build/web folder contains the static files
```

---

## 📊 PHASE 7: TESTING & LAUNCH (Days 24-30)

### Day 24-26: Testing

```bash
# ✅ Testing Checklist
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☐ User signup flow
☐ Login flow
☐ View today's WOD
☐ Complete workout
☐ Check power level updates
☐ Check streak tracking
☐ Test on multiple devices
☐ Test offline mode (Firestore offline persistence)
☐ Performance testing
☐ Security audit (Firebase Security Rules)
```

### Day 27-28: Beta Launch

```bash
# 1. Set up Firebase App Distribution
# 2. Invite 50-100 beta users
# 3. Collect feedback
# 4. Fix critical bugs
# 5. Monitor Firebase Analytics
```

### Day 29: Pre-Launch Marketing

```bash
# ✅ Marketing Checklist
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☐ Update forge.dance landing page
☐ Create social media accounts
☐ Post teaser content
☐ Reach out to dance influencers
☐ Prepare press release
☐ Set up Product Hunt launch
☐ Prepare app store listings
```

### Day 30: PUBLIC LAUNCH! 🎉

```bash
# Launch Day Tasks:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☐ Submit to App Store (iOS)
☐ Submit to Google Play (Android)
☐ Product Hunt launch (6am PT)
☐ Social media announcements
☐ Email press releases
☐ Monitor Firebase performance
☐ Respond to user feedback
☐ Celebrate! 🔥⚡💎
```

---

## 🔧 ESSENTIAL COMMANDS REFERENCE

### Development

```bash
# Run Flutter app
flutter run

# Run on specific device
flutter run -d chrome        # Web
flutter run -d ios           # iOS simulator
flutter run -d android       # Android emulator

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
# Quit: Press 'q' in terminal

# Generate code (Riverpod, etc.)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Firebase

```bash
# Login
firebase login

# Initialize project
firebase init

# Deploy functions
firebase deploy --only functions

# Deploy hosting
firebase deploy --only hosting

# View logs
firebase functions:log
```

### Building

```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

---

## 📦 ENVIRONMENT VARIABLES

### Firebase Configuration

```dart
// lib/firebase_options.dart (auto-generated by flutterfire configure)
// This file is generated automatically, don't edit manually
```

### App Configuration

```dart
// lib/config/app_config.dart
class AppConfig {
  static const String appName = 'forge.dance';
  static const String appVersion = '1.0.0';
  
  // Stripe
  static const String stripePublishableKey = 'pk_test_...';
  
  // Analytics
  static const bool enableAnalytics = true;
}
```

---

## 🎯 CRITICAL SUCCESS FACTORS

### Week 1 Goals

```text
☐ Flutter SDK installed (3.38+)
☐ Firebase project created
☐ Flutter app initialized
☐ Firebase configured
☐ Basic navigation working
☐ Authentication flow working
```

### Week 2 Goals

```text
☐ Firestore database structure created
☐ Sample data seeded
☐ Home screen displaying today's WOD
☐ WOD detail screen working
☐ Basic workout completion flow
```

### Week 3 Goals

```text
☐ WOD player with video working
☐ Progress tracking functional
☐ Power level updates working
☐ Streak tracking working
☐ Web landing page deployed
```

### Week 4 Goals

```text
☐ Beta testing complete
☐ Critical bugs fixed
☐ Marketing materials ready
☐ App store listings prepared
☐ Public launch executed
☐ First 100 users acquired
```

---

## 🆘 TROUBLESHOOTING

### Common Issues

```bash
# Issue: Flutter not found
# Add Flutter to PATH:
export PATH="$PATH:/path/to/flutter/bin"

# Issue: Firebase not configured
flutterfire configure

# Issue: Build errors
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Issue: iOS build fails
cd ios
pod install
cd ..

# Issue: Android build fails
cd android
./gradlew clean
cd ..
```

---

## 📞 GETTING HELP

### Resources

```text
📚 Documentation:
- Flutter: https://docs.flutter.dev/
- Firebase: https://firebase.google.com/docs
- Dart 3.10: https://dart.dev/guides/whats-new
- Flutter 3.38: https://docs.flutter.dev/release/breaking-changes

💬 Community:
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Reddit: r/FlutterDev

🐛 Bug Reports:
- Flutter: https://github.com/flutter/flutter/issues
- Firebase: https://firebase.google.com/support
```

---

## 🎉 YOU'RE READY!

```text
╔════════════════════════════════════════════════╗
║                                                ║
║         🔥 FORGE YOUR LEGEND! ⚡               ║
║                                                ║
║  You now have everything you need:             ║
║                                                ║
║  ✅ Complete business plan                     ║
║  ✅ Full technical architecture                ║
║  ✅ Design system & UI specs                   ║
║  ✅ 30-day Flutter + Firebase guide            ║
║                                                ║
║  Next step: Start Day 1! 🚀                    ║
║                                                ║
║  Remember: Done is better than perfect.        ║
║  Ship fast, iterate, and keep forging! 💪      ║
║                                                ║
╚════════════════════════════════════════════════╝
```

**LET'S BUILD SOMETHING LEGENDARY!** 🔥⚡💎
