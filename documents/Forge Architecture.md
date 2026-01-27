---
type: Page
title: Forge Architecture
description: null
icon: null
createdAt: '2026-01-23T23:00:40.160Z'
creationDate: 2026-01-24 01:00
modificationDate: 2026-01-26 01:00
tags: []
coverImage: null
---

# 🏗️ FORGE.DANCE - TECHNICAL ARCHITECTURE

**Version:** 2.0**Date:** January 2026**Status:** Production-Ready Architecture**Stack:** Flutter 3.38 + Firebase

---

## 🆕 FLUTTER 3.38 & DART 3.10 FEATURES

This architecture leverages the latest Flutter and Dart features:

### Dart 3.10 Highlights
- **Dot Shorthands**: Less typing, more coding (e.g., `.start` instead of `MainAxisAlignment.start`)
- **Build Hooks**: Stable! Compile native code or bundle native assets directly with Dart packages
- **New Analyzer Plugin System**: Write custom analysis rules and IDE quick fixes
- **Deprecated Annotation**: Better deprecation management

### Flutter 3.38 Highlights
- **Web Enhancements**: Config file for `flutter run`, proxy support, hot reload for web
- **Framework & UI**: Enhanced `OverlayPortal`, predictive back gesture default on Android
- **iOS Updates**: Full support for iOS 26/Xcode 26, command-line deployment
- **Android Updates**: NDK r28 for 16KB page size compatibility, memory leak fixes, Java 17
- **Tooling**: Big updates to Widget Previewer and IDEs
- **Accessibility**: New `SliverSemantics` widget and better default behaviors

### Usage in Forge.dance
- Dot shorthands for cleaner alignment code (`.start`, `.center`, `.spaceBetween`)
- Build hooks for native video player integration
- Enhanced web support for simple landing page
- Better accessibility for inclusive design
- Improved performance with latest optimizations

---

## 📐 SYSTEM OVERVIEW

### Architecture Philosophy

```text
CORE PRINCIPLES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Speed-to-Market: Fast development, rapid iteration
✅ Mobile-First: Flutter for iOS/Android (single codebase)
✅ Real-Time: Firestore real-time sync, instant updates
✅ Scalable: Firebase auto-scales to millions of users
✅ Cost-Effective: Pay-as-you-go, generous free tier
✅ Developer-Friendly: Flutter 3.38 + Dart 3.10 features
```

### High-Level Architecture

```text
┌─────────────────────────────────────────────┐
│           CLIENT APPLICATIONS               │
├─────────────────────────────────────────────┤
│                                             │
│  📱 Mobile (iOS/Android)                    │
│     Flutter 3.38                            │
│     Dart 3.10 (dot shorthands, build hooks) │
│     Riverpod (state management)             │
│     GoRouter (navigation)                   │
│                                             │
│  🌐 Web Application                         │
│     Flutter Web (simple landing page)       │
│     Focus on marketing/presentation         │
│                                             │
└──────────────────┬──────────────────────────┘
                   │
                   │ HTTPS/WebSocket
                   │
┌──────────────────▼──────────────────────────┐
│         FIREBASE BACKEND                     │
├─────────────────────────────────────────────┤
│                                             │
│  🔐 Authentication                          │
│     Firebase Auth                           │
│     Email/Password, Google, Apple            │
│                                             │
│  💾 Firestore Database                      │
│     Real-time NoSQL                         │
│     Offline persistence                     │
│     Automatic scaling                       │
│                                             │
│  📦 Firebase Storage                        │
│     Video files                              │
│     Images (avatars, thumbnails)            │
│     CDN distribution                        │
│                                             │
│  ⚡ Cloud Functions                         │
│     Serverless backend logic                │
│     Leaderboard updates                     │
│     Background jobs                         │
│                                             │
│  📱 Cloud Messaging (FCM)                   │
│     Push notifications                      │
│     In-app messaging                        │
│                                             │
│  📊 Firebase Analytics                      │
│     User behavior tracking                  │
│     Custom events                           │
│                                             │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│         EXTERNAL SERVICES                   │
├─────────────────────────────────────────────┤
│  💳 Stripe (Payments)                       │
│  🎥 Video hosting (Firebase Storage + CDN)   │
│  📧 Email (Firebase Extensions or SendGrid) │
└─────────────────────────────────────────────┘
```

---

## 🏛️ DETAILED ARCHITECTURE

### 1. Mobile Application (Flutter 3.38)

#### Project Structure

```text
forge_dance/
├── lib/
│   ├── main.dart            # App entry point
│   ├── firebase_options.dart # Auto-generated Firebase config
│   │
│   ├── models/              # Data models
│   │   ├── user.dart
│   │   ├── wod.dart
│   │   ├── exercise.dart
│   │   ├── workout_session.dart
│   │   └── achievement.dart
│   │
│   ├── services/            # Business logic
│   │   ├── auth_service.dart
│   │   ├── wod_service.dart
│   │   ├── user_service.dart
│   │   ├── firestore_service.dart
│   │   └── storage_service.dart
│   │
│   ├── providers/           # Riverpod providers
│   │   ├── auth_provider.dart
│   │   ├── wod_provider.dart
│   │   └── user_provider.dart
│   │
│   ├── router/              # Navigation
│   │   └── app_router.dart  # GoRouter configuration
│   │
│   ├── screens/             # UI screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── onboarding_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── wod/
│   │   │   ├── wod_detail_screen.dart
│   │   │   └── wod_player_screen.dart
│   │   ├── library/
│   │   │   └── library_screen.dart
│   │   ├── progress/
│   │   │   └── progress_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   │
│   ├── widgets/             # Reusable widgets
│   │   ├── ui/
│   │   │   ├── forge_button.dart
│   │   │   ├── forge_card.dart
│   │   │   └── forge_input.dart
│   │   ├── forge/
│   │   │   ├── wod_card.dart
│   │   │   ├── power_level_widget.dart
│   │   │   └── streak_counter_widget.dart
│   │   └── video/
│   │       └── video_player_widget.dart
│   │
│   ├── theme/               # App theming
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   │
│   └── utils/               # Utilities
│       ├── constants.dart
│       ├── extensions.dart
│       └── validators.dart
│
├── test/                    # Unit & widget tests
├── web/                     # Web-specific code
│   └── index.html
├── android/                 # Android-specific
├── ios/                     # iOS-specific
├── pubspec.yaml             # Dependencies
└── README.md
```

#### Key Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0
  firebase_messaging: ^15.0.0
  firebase_analytics: ^11.0.0
  firebase_functions: ^5.0.0
  
  # State Management (Riverpod)
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  riverpod_generator: ^2.3.0
  
  # Navigation
  go_router: ^13.0.0
  
  # UI
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  
  # Video
  video_player: ^2.8.0
  chewie: ^1.7.0
  
  # Camera (for AI form analysis)
  camera: ^0.11.0
  image_picker: ^1.0.0
  
  # Animations (Flutter 3.38)
  animations: ^2.0.0
  
  # Utilities
  intl: ^0.19.0
  shared_preferences: ^2.2.0
  package_info_plus: ^5.0.0
  
  # Payments
  stripe_flutter: ^10.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
```

#### Core Screens Implementation

**Home Screen (Today's WOD) - Using Flutter 3.38 & Dart 3.10**

```dart
// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/wod_provider.dart';
import '../../widgets/forge/wod_card.dart';
import '../../widgets/forge/power_level_widget.dart';
import '../../widgets/forge/streak_counter_widget.dart';

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
                  crossAxisAlignment: .start, // Dart 3.10 dot shorthand!
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
                    ? WODCard(
                        wod: wod,
                        onTap: () => context.push('/wod/${wod.id}'),
                      )
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
                  crossAxisAlignment: .start,
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
```

**WOD Player - Using Video Player**

```dart
// lib/screens/wod/wod_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../providers/wod_provider.dart';

class WODPlayerScreen extends ConsumerStatefulWidget {
  final String wodId;
  
  const WODPlayerScreen({super.key, required this.wodId});
  
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
                      const Text(
                        'Exercise Name',
                        style: TextStyle(
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
  
  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
```

---

### 2. Web Application (Flutter Web - Simple Landing Page)

#### Project Structure

```text
forge_dance/
├── web/
│   ├── index.html            # Web entry point
│   └── main.dart             # Web-specific main
├── lib/
│   └── web/                  # Web-specific screens
│       └── landing_page.dart
└── (shared with mobile app)
```

#### Web Configuration

```dart
// web/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '../lib/web/landing_page.dart';

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
```

#### Landing Page (Simple Marketing Site)

```dart
// lib/web/landing_page.dart
import 'package:flutter/material.dart';

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

### 3. Backend Services (Firebase Cloud Functions)

#### Cloud Functions Structure

```text
functions/
├── src/
│   ├── index.ts              # Main entry point
│   ├── functions/
│   │   ├── leaderboard.ts    # Leaderboard updates
│   │   ├── achievements.ts   # Achievement checking
│   │   ├── notifications.ts # Push notifications
│   │   └── analytics.ts     # Analytics events
│   └── lib/
│       ├── firestore.ts      # Firestore helpers
│       └── utils.ts          # Utilities
├── package.json
└── tsconfig.json
```

#### Cloud Functions Example

```typescript
// functions/src/index.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Update leaderboard when workout is completed
export const updateLeaderboard = functions.firestore
  .document('workout_sessions/{sessionId}')
  .onCreate(async (snap, context) => {
    const session = snap.data();
    const userId = session.userId;
    
    // Get user data
    const userRef = admin.firestore().collection('users').doc(userId);
    const userDoc = await userRef.get();
    const user = userDoc.data();
    
    if (!user) return;
    
    // Update leaderboard
    await admin.firestore().collection('leaderboard').doc(userId).set({
      userId: userId,
      username: user.username,
      avatarUrl: user.avatarUrl,
      totalForgePoints: user.forgePoints || 0,
      totalWorkouts: user.totalWods || 0,
      powerLevel: user.powerLevel || 0,
      forgeRank: user.forgeRank || 'EMBER',
      currentStreak: user.currentStreak || 0,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
    
    // Check for achievements
    await checkAchievements(userId, user);
  });

// Check and award achievements
async function checkAchievements(userId: string, user: any) {
  const achievementsRef = admin.firestore().collection('achievements');
  const userAchievementsRef = admin.firestore()
    .collection('users')
    .doc(userId)
    .collection('achievements');
  
  // Get all achievements
  const achievements = await achievementsRef.get();
  
  for (const achievementDoc of achievements.docs) {
    const achievement = achievementDoc.data();
    const achievementId = achievementDoc.id;
    
    // Check if already unlocked
    const existing = await userAchievementsRef.doc(achievementId).get();
    if (existing.exists) continue;
    
    // Check requirement
    let unlocked = false;
    switch (achievement.requirementType) {
      case 'wods_completed':
        unlocked = (user.totalWods || 0) >= achievement.requirementValue;
        break;
      case 'streak':
        unlocked = (user.currentStreak || 0) >= achievement.requirementValue;
        break;
      case 'power_level':
        unlocked = (user.powerLevel || 0) >= achievement.requirementValue;
        break;
    }
    
    if (unlocked) {
      // Award achievement
      await userAchievementsRef.doc(achievementId).set({
        unlockedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      // Add forge points
      await admin.firestore().collection('users').doc(userId).update({
        forgePoints: admin.firestore.FieldValue.increment(
          achievement.forgePoints || 0
        ),
      });
      
      // Send notification
      await sendAchievementNotification(userId, achievement);
    }
  }
}
```

#### WOD Routes

```typescript
// workers/api/routes/wods.ts
import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'
const app = new Hono()
// Get today's WOD
app.get('/today', async (c) => {
  const db = c.env.DB
  const today = new Date().toISOString().split('T')[0]
  
  const wod = await db
    .prepare(`
      SELECT * FROM wods 
      WHERE date = ? 
      LIMIT 1
    `)
    .bind(today)
    .first()
  
  if (!wod) {
    return c.json({ error: 'No WOD found for today' }, 404)
  }
  
  return c.json({ wod })
})
// Get WOD by ID
app.get('/:id', async (c) => {
  const id = c.req.param('id')
  const db = c.env.DB
  
  const wod = await db
    .prepare('SELECT * FROM wods WHERE id = ?')
    .bind(id)
    .first()
  
  if (!wod) {
    return c.json({ error: 'WOD not found' }, 404)
  }
  
  return c.json({ wod })
})
// Complete WOD
app.post(
  '/:id/complete',
  zValidator('json', z.object({
    duration_seconds: z.number(),
    gravity_modifier: z.number().min(1).max(100),
    rating: z.number().min(1).max(5).optional(),
    notes: z.string().optional(),
  })),
  async (c) => {
    const id = c.req.param('id')
    const payload = c.get('jwtPayload')
    const userId = payload.sub
    const data = c.req.valid('json')
    
    const db = c.env.DB
    
    // Get WOD details
    const wod = await db
      .prepare('SELECT * FROM wods WHERE id = ?')
      .bind(id)
      .first()
    
    if (!wod) {
      return c.json({ error: 'WOD not found' }, 404)
    }
    
    // Calculate forge points
    const basePoints = wod.forge_points_reward
    const bonusMultiplier = data.gravity_modifier
    const forgePoints = Math.floor(basePoints * bonusMultiplier)
    
    // Record session
    await db.batch([
      // Insert workout session
      db.prepare(`
        INSERT INTO workout_sessions 
        (id, user_id, wod_id, duration_seconds, gravity_modifier, forge_points_earned, rating, notes)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `).bind(
        crypto.randomUUID(),
        userId,
        id,
        data.duration_seconds,
        data.gravity_modifier,
        forgePoints,
        data.rating || null,
        data.notes || null
      ),
      
      // Update user stats
      db.prepare(`
        UPDATE users 
        SET 
          power_level = power_level + ?,
          total_wods = total_wods + 1,
          forge_points = forge_points + ?
        WHERE id = ?
      `).bind(forgePoints, forgePoints, userId),
      
      // Update streak
      db.prepare(`
        INSERT INTO streak_days (user_id, date)
        VALUES (?, ?)
        ON CONFLICT DO NOTHING
      `).bind(userId, new Date().toISOString().split('T')[0])
    ])
    
    // TODO: Trigger leaderboard update via Queue
    
    return c.json({ 
      success: true, 
      forgePoints,
      newPowerLevel: await getUserPowerLevel(db, userId)
    })
  }
)
export default app
```

---

### 4. Database Layer (Firestore)

#### Firestore Collections Structure

```dart
// Firestore Collections:
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// users/{userId}
{
  email: string,
  username: string,
  avatarUrl: string?,
  powerLevel: number,
  forgeRank: string, // EMBER, FLAME, INFERNO, etc.
  forgePoints: number,
  totalWods: number,
  currentStreak: number,
  longestStreak: number,
  lastWorkoutDate: timestamp?,
  streakShields: number,
  primaryStyle: string?,
  skillLevel: number,
  weeklyGoal: number,
  subscriptionTier: string, // free, pro, legendary
  subscriptionStatus: string,
  stripeCustomerId: string?,
  createdAt: timestamp,
  updatedAt: timestamp,
}

// wods/{wodId}
{
  title: string,
  description: string?,
  danceStyle: string,
  difficulty: number, // 1-10
  durationMinutes: number,
  forgePointsReward: number,
  requiredRank: string,
  exercises: array<{
    id: string,
    name: string,
    videoUrl: string,
    duration: number,
  }>,
  videoPreviewUrl: string?,
  thumbnailUrl: string?,
  date: timestamp?, // For daily WODs
  isFeatured: boolean,
  isPremium: boolean,
  createdBy: string?,
  createdAt: timestamp,
  updatedAt: timestamp,
}

// workout_sessions/{sessionId}
{
  userId: string,
  wodId: string,
  completedAt: timestamp,
  durationSeconds: number,
  gravityModifier: number,
  forgePointsEarned: number,
  rating: number?, // 1-5
  notes: string?,
  createdAt: timestamp,
}

// achievements/{achievementId}
{
  name: string,
  description: string?,
  requirementType: string, // wods_completed, streak, power_level
  requirementValue: number,
  forgePoints: number?,
  rarity: string, // common, rare, epic, legendary
  createdAt: timestamp,
}

// users/{userId}/achievements/{achievementId}
{
  unlockedAt: timestamp,
}

// streak_days/{userId_date}
{
  userId: string,
  date: timestamp,
  completed: boolean,
}

// leaderboard/{userId}
{
  userId: string,
  username: string,
  avatarUrl: string?,
  totalForgePoints: number,
  totalWorkouts: number,
  powerLevel: number,
  forgeRank: string,
  currentStreak: number,
  updatedAt: timestamp,
}
```

#### Firestore Security Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read their own data, admins can read all
    match /users/{userId} {
      allow read: if request.auth != null && 
        (request.auth.uid == userId || isAdmin());
      allow write: if request.auth != null && 
        request.auth.uid == userId;
    }
    
    // WODs are readable by all authenticated users
    match /wods/{wodId} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
    
    // Workout sessions are private to user
    match /workout_sessions/{sessionId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Leaderboard is readable by all
    match /leaderboard/{userId} {
      allow read: if request.auth != null;
      allow write: if false; // Only Cloud Functions can write
    }
    
    function isAdmin() {
      return request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

#### SQL Schema (Reference - for understanding data structure)

```sql
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- USERS TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE NOT NULL,
  avatar_url TEXT,
  
  -- Gamification
  power_level INTEGER DEFAULT 0,
  forge_rank TEXT DEFAULT 'EMBER',
  forge_points INTEGER DEFAULT 0,
  total_wods INTEGER DEFAULT 0,
  
  -- Streaks
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_workout_date TEXT,
  streak_shields INTEGER DEFAULT 0,
  
  -- Preferences
  primary_style TEXT,
  skill_level INTEGER DEFAULT 1,
  weekly_goal INTEGER DEFAULT 3,
  
  -- Subscription
  subscription_tier TEXT DEFAULT 'free', -- free, pro, legendary
  subscription_status TEXT DEFAULT 'active',
  stripe_customer_id TEXT,
  
  -- Metadata
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_power_level ON users(power_level DESC);
CREATE INDEX idx_users_subscription ON users(subscription_tier, subscription_status);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- WODS TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE wods (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  
  -- Classification
  dance_style TEXT NOT NULL, -- hip_hop, ballet, contemporary, etc.
  difficulty INTEGER NOT NULL CHECK(difficulty BETWEEN 1 AND 10),
  duration_minutes INTEGER NOT NULL,
  
  -- Gamification
  forge_points_reward INTEGER NOT NULL,
  required_rank TEXT DEFAULT 'EMBER',
  
  -- Content
  exercises TEXT NOT NULL, -- JSON array
  video_preview_url TEXT,
  thumbnail_url TEXT,
  
  -- Scheduling
  date TEXT, -- YYYY-MM-DD for daily WODs
  is_featured INTEGER DEFAULT 0,
  is_premium INTEGER DEFAULT 0,
  
  -- Metadata
  created_by TEXT, -- user_id of creator
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);
CREATE INDEX idx_wods_date ON wods(date);
CREATE INDEX idx_wods_style ON wods(dance_style);
CREATE INDEX idx_wods_difficulty ON wods(difficulty);
CREATE INDEX idx_wods_featured ON wods(is_featured, date);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- EXERCISES TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE exercises (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  
  -- Classification
  category TEXT NOT NULL, -- fundamentals, technique, flexibility, choreography
  dance_style TEXT NOT NULL,
  difficulty INTEGER NOT NULL CHECK(difficulty BETWEEN 1 AND 10),
  
  -- Content
  video_url TEXT NOT NULL,
  thumbnail_url TEXT,
  duration_seconds INTEGER,
  
  -- Instructions
  instructions TEXT, -- JSON array of steps
  common_mistakes TEXT, -- JSON array
  tips TEXT, -- JSON array
  
  -- Metadata
  created_at INTEGER DEFAULT (unixepoch())
);
CREATE INDEX idx_exercises_category ON exercises(category);
CREATE INDEX idx_exercises_style ON exercises(dance_style);
CREATE INDEX idx_exercises_difficulty ON exercises(difficulty);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- WORKOUT SESSIONS TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE workout_sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  wod_id TEXT NOT NULL REFERENCES wods(id),
  
  -- Session data
  completed_at INTEGER DEFAULT (unixepoch()),
  duration_seconds INTEGER NOT NULL,
  gravity_modifier INTEGER DEFAULT 1,
  
  -- Rewards
  forge_points_earned INTEGER NOT NULL,
  
  -- Feedback
  rating INTEGER CHECK(rating BETWEEN 1 AND 5),
  notes TEXT,
  
  -- Metadata
  created_at INTEGER DEFAULT (unixepoch())
);
CREATE INDEX idx_sessions_user ON workout_sessions(user_id, completed_at DESC);
CREATE INDEX idx_sessions_wod ON workout_sessions(wod_id);
CREATE INDEX idx_sessions_date ON workout_sessions(completed_at);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ACHIEVEMENTS TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE achievements (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT, -- emoji or asset path
  
  -- Requirements
  requirement_type TEXT NOT NULL, -- streak, wods_completed, power_level, etc.
  requirement_value INTEGER,
  
  -- Rewards
  forge_points INTEGER,
  unlocks_gear TEXT, -- JSON array of gear IDs
  
  -- Metadata
  rarity TEXT DEFAULT 'common', -- common, rare, epic, legendary
  created_at INTEGER DEFAULT (unixepoch())
);
CREATE TABLE user_achievements (
  user_id TEXT NOT NULL REFERENCES users(id),
  achievement_id TEXT NOT NULL REFERENCES achievements(id),
  unlocked_at INTEGER DEFAULT (unixepoch()),
  PRIMARY KEY (user_id, achievement_id)
);
CREATE INDEX idx_user_achievements ON user_achievements(user_id);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- STREAKS TABLE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE streak_days (
  user_id TEXT NOT NULL REFERENCES users(id),
  date TEXT NOT NULL, -- YYYY-MM-DD
  completed INTEGER DEFAULT 1,
  PRIMARY KEY (user_id, date)
);
CREATE INDEX idx_streaks_user_date ON streak_days(user_id, date DESC);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- LEADERBOARD TABLE (Materialized)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE leaderboard (
  user_id TEXT PRIMARY KEY REFERENCES users(id),
  username TEXT NOT NULL,
  avatar_url TEXT,
  
  -- Stats
  total_forge_points INTEGER NOT NULL,
  total_workouts INTEGER NOT NULL,
  power_level INTEGER NOT NULL,
  forge_rank TEXT NOT NULL,
  current_streak INTEGER NOT NULL,
  
  -- Ranking
  global_rank INTEGER,
  style_rank INTEGER, -- rank within primary style
  
  -- Metadata
  updated_at INTEGER DEFAULT (unixepoch())
);
CREATE INDEX idx_leaderboard_rank ON leaderboard(global_rank);
CREATE INDEX idx_leaderboard_points ON leaderboard(total_forge_points DESC);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SOCIAL FEATURES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE follows (
  follower_id TEXT NOT NULL REFERENCES users(id),
  following_id TEXT NOT NULL REFERENCES users(id),
  created_at INTEGER DEFAULT (unixepoch()),
  PRIMARY KEY (follower_id, following_id)
);
CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- NOTIFICATIONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  
  type TEXT NOT NULL, -- achievement, streak, friend, level_up, etc.
  title TEXT NOT NULL,
  message TEXT,
  data TEXT, -- JSON
  
  read INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch())
);
CREATE INDEX idx_notifications_user ON notifications(user_id, read, created_at DESC);
```

#### Database Migrations

```typescript
// migrations/0001_initial_schema.ts
export default {
  async up(db: D1Database) {
    await db.batch([
      db.prepare(/* CREATE TABLE users ... */),
      db.prepare(/* CREATE TABLE wods ... */),
      // ... all CREATE TABLE statements
    ])
  },
  
  async down(db: D1Database) {
    await db.batch([
      db.prepare('DROP TABLE IF EXISTS notifications'),
      db.prepare('DROP TABLE IF EXISTS follows'),
      // ... reverse order
    ])
  }
}
```

---

### 5. Real-Time Features (Durable Objects)

#### Live Leaderboard Durable Object

```typescript
// durable-objects/LiveLeaderboard.ts
export class LiveLeaderboard {
  state: DurableObjectState
  env: Env
  sessions: Set<WebSocket>
  
  constructor(state: DurableObjectState, env: Env) {
    this.state = state
    this.env = env
    this.sessions = new Set()
  }
  
  async fetch(request: Request) {
    // WebSocket upgrade
    if (request.headers.get('Upgrade') === 'websocket') {
      const pair = new WebSocketPair()
      const [client, server] = Object.values(pair)
      
      await this.handleSession(server)
      
      return new Response(null, {
        status: 101,
        webSocket: client,
      })
    }
    
    return new Response('Expected WebSocket', { status: 400 })
  }
  
  async handleSession(ws: WebSocket) {
    this.state.acceptWebSocket(ws)
    this.sessions.add(ws)
    
    // Send current leaderboard
    const leaderboard = await this.getLeaderboard()
    ws.send(JSON.stringify({
      type: 'leaderboard',
      data: leaderboard
    }))
  }
  
  async webSocketMessage(ws: WebSocket, message: string) {
    const data = JSON.parse(message)
    
    switch (data.type) {
      case 'workout_complete':
        await this.handleWorkoutComplete(data)
        break
      
      case 'subscribe':
        // Subscribe to specific leaderboard (global, style, etc.)
        break
    }
  }
  
  async handleWorkoutComplete(data: any) {
    // Update leaderboard in D1
    await this.env.DB.prepare(`
      UPDATE leaderboard
      SET 
        total_forge_points = total_forge_points + ?,
        total_workouts = total_workouts + 1,
        updated_at = ?
      WHERE user_id = ?
    `).bind(data.forgePoints, Date.now(), data.userId).run()
    
    // Recalculate rankings
    await this.recalculateRankings()
    
    // Broadcast updated leaderboard
    const leaderboard = await this.getLeaderboard()
    this.broadcast({
      type: 'leaderboard_update',
      data: leaderboard
    })
  }
  
  async recalculateRankings() {
    // Update global_rank based on total_forge_points
    await this.env.DB.prepare(`
      UPDATE leaderboard
      SET global_rank = (
        SELECT COUNT(*) + 1
        FROM leaderboard AS l2
        WHERE l2.total_forge_points > leaderboard.total_forge_points
      )
    `).run()
  }
  
  async getLeaderboard(limit = 100) {
    const result = await this.env.DB.prepare(`
      SELECT 
        user_id,
        username,
        avatar_url,
        total_forge_points,
        power_level,
        forge_rank,
        global_rank
      FROM leaderboard
      ORDER BY global_rank ASC
      LIMIT ?
    `).bind(limit).all()
    
    return result.results
  }
  
  broadcast(message: any) {
    const msg = JSON.stringify(message)
    this.sessions.forEach(ws => {
      try {
        ws.send(msg)
      } catch (err) {
        this.sessions.delete(ws)
      }
    })
  }
  
  async webSocketClose(ws: WebSocket) {
    this.sessions.delete(ws)
  }
}
```

---

### 6. Video Storage & Streaming (Firebase Storage + CDN)

#### Video Upload & Management

```dart
// lib/services/storage_service.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload video file
  Future<String> uploadVideo({
    required File videoFile,
    required String path, // e.g., 'exercises/ex-001/video.mp4'
    Function(double)? onProgress,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(
      videoFile,
      SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      ),
    );
    
    // Listen to progress
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
    });
    
    await uploadTask;
    return await ref.getDownloadURL();
  }
  
  // Upload thumbnail image
  Future<String> uploadThumbnail({
    required File imageFile,
    required String path,
  }) async {
    final ref = _storage.ref().child(path);
    await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await ref.getDownloadURL();
  }
  
  // Get download URL (public or signed)
  Future<String> getDownloadUrl(String path) async {
    final ref = _storage.ref().child(path);
    return await ref.getDownloadURL();
  }
  
  // Delete file
  Future<void> deleteFile(String path) async {
    final ref = _storage.ref().child(path);
    await ref.delete();
  }
}
```

---

### 7. Authentication System (Firebase Auth)

#### Firebase Authentication

```dart
// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
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
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }
    
    final GoogleSignInAuthentication googleAuth = 
      await googleUser.authentication;
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await _auth.signInWithCredential(credential);
    
    // Create user document if new user
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _createUserDocument(
        userCredential.user!.uid,
        userCredential.user!.email!,
        userCredential.user!.displayName ?? 'User',
      );
    }
    
    return userCredential;
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
    await _googleSignIn.signOut();
  }
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

---

### 8. Payment Integration (Stripe)

```typescript
// lib/stripe.ts
import Stripe from 'stripe'
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)
export async function createCheckoutSession(
  userId: string,
  priceId: string,
  successUrl: string,
  cancelUrl: string
) {
  const session = await stripe.checkout.sessions.create({
    customer: await getOrCreateCustomer(userId),
    line_items: [{ price: priceId, quantity: 1 }],
    mode: 'subscription',
    success_url: successUrl,
    cancel_url: cancelUrl,
  })
  
  return session
}
export async function handleWebhook(
  request: Request,
  webhookSecret: string
) {
  const signature = request.headers.get('stripe-signature')!
  const body = await request.text()
  
  const event = stripe.webhooks.constructEvent(
    body,
    signature,
    webhookSecret
  )
  
  switch (event.type) {
    case 'checkout.session.completed':
      await handleSubscriptionCreated(event.data.object)
      break
    
    case 'customer.subscription.deleted':
      await handleSubscriptionCanceled(event.data.object)
      break
  }
}
async function handleSubscriptionCreated(session: any) {
  // Update user subscription in D1
  await db.prepare(`
    UPDATE users
    SET 
      subscription_tier = ?,
      subscription_status = 'active',
      stripe_customer_id = ?
    WHERE id = ?
  `).bind(
    session.metadata.tier,
    session.customer,
    session.metadata.userId
  ).run()
}
```

---

## 🚀 DEPLOYMENT & CI/CD

### Firebase Deployment

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize project
firebase init

# Deploy Functions
firebase deploy --only functions

# Deploy Hosting (web)
firebase deploy --only hosting

# Deploy everything
firebase deploy
```

### GitHub Actions CI/CD

```yaml
# .github/workflows/deploy.yml
name: Deploy to Firebase
on:
  push:
    branches: [main]
jobs:
  deploy-functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run build --prefix functions
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: forge-dance
  
  build-mobile:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.0'
      - run: flutter pub get
      - run: flutter build apk --release
      - run: flutter build ios --release --no-codesign
      - uses: actions/upload-artifact@v3
        with:
          name: mobile-builds
          path: |
            build/app/outputs/flutter-apk/app-release.apk
            build/ios/iphoneos/Runner.app
```

---

## 📊 MONITORING & ANALYTICS

### Application Monitoring

```typescript
// lib/monitoring.ts
import { PostHog } from 'posthog-node'
const posthog = new PostHog(
  process.env.POSTHOG_API_KEY!,
  { host: 'https://app.posthog.com' }
)
export function trackEvent(
  userId: string,
  event: string,
  properties?: Record<string, any>
) {
  posthog.capture({
    distinctId: userId,
    event,
    properties: {
      ...properties,
      timestamp: new Date().toISOString(),
    },
  })
}
// Key events to track
export const EVENTS = {
  USER_SIGNED_UP: 'user_signed_up',
  WOD_STARTED: 'wod_started',
  WOD_COMPLETED: 'wod_completed',
  LEVEL_UP: 'level_up',
  ACHIEVEMENT_UNLOCKED: 'achievement_unlocked',
  SUBSCRIPTION_STARTED: 'subscription_started',
  SUBSCRIPTION_CANCELED: 'subscription_canceled',
}
```

### Performance Monitoring

```typescript
// lib/performance.ts
export class PerformanceMonitor {
  static async measure<T>(
    name: string,
    fn: () => Promise<T>
  ): Promise<T> {
    const start = Date.now()
    try {
      const result = await fn()
      const duration = Date.now() - start
      
      // Log to analytics
      this.logMetric(name, duration, 'success')
      
      return result
    } catch (error) {
      const duration = Date.now() - start
      this.logMetric(name, duration, 'error')
      throw error
    }
  }
  
  static logMetric(
    name: string,
    duration: number,
    status: string
  ) {
    // Send to CloudflareAnalytics or PostHog
    console.log(`[PERF] ${name}: ${duration}ms (${status})`)
  }
}
```

---

## 🔒 SECURITY BEST PRACTICES

### Rate Limiting

```typescript
// middleware/rateLimit.ts
import { Context } from 'hono'
const RATE_LIMITS = {
  '/api/wods': { requests: 100, window: 60 }, // 100 req/min
  '/auth/login': { requests: 5, window: 300 }, // 5 req/5min
}
export async function rateLimit(c: Context, next: () => Promise<void>) {
  const key = `rate_limit:${c.req.path}:${getUserId(c)}`
  const kv = c.env.KV
  
  const current = await kv.get(key)
  const count = current ? parseInt(current) : 0
  
  const limit = RATE_LIMITS[c.req.path] || { requests: 1000, window: 60 }
  
  if (count >= limit.requests) {
    return c.json({ error: 'Rate limit exceeded' }, 429)
  }
  
  await kv.put(
    key,
    (count + 1).toString(),
    { expirationTtl: limit.window }
  )
  
  await next()
}
```

### Input Validation

```typescript
// All inputs validated with Zod
import { z } from 'zod'
const WorkoutCompleteSchema = z.object({
  duration_seconds: z.number().min(1).max(7200),
  gravity_modifier: z.number().min(1).max(100),
  rating: z.number().min(1).max(5).optional(),
  notes: z.string().max(500).optional(),
})
// Usage
const data = WorkoutCompleteSchema.parse(await c.req.json())
```

---

## 📈 SCALABILITY CONSIDERATIONS

### Caching Strategy

```typescript
// lib/cache.ts
export class Cache {
  static async get<T>(
    kv: KVNamespace,
    key: string
  ): Promise<T | null> {
    const cached = await kv.get(key, 'json')
    return cached as T | null
  }
  
  static async set<T>(
    kv: KVNamespace,
    key: string,
    value: T,
    ttl = 3600
  ) {
    await kv.put(key, JSON.stringify(value), { expirationTtl: ttl })
  }
  
  static async delete(kv: KVNamespace, key: string) {
    await kv.delete(key)
  }
}
// Cache today's WOD (refreshes daily)
const wodKey = `wod:today:${new Date().toISOString().split('T')[0]}`
let wod = await Cache.get(kv, wodKey)
if (!wod) {
  wod = await db.prepare(/* ... */).first()
  await Cache.set(kv, wodKey, wod, 86400) // 24 hours
}
```

### Database Query Optimization

```sql
-- Use indexes effectively
CREATE INDEX idx_sessions_user_date 
ON workout_sessions(user_id, completed_at DESC);
-- Materialize expensive queries
CREATE TABLE daily_stats AS
SELECT 
  DATE(completed_at) as date,
  COUNT(*) as total_workouts,
  SUM(forge_points_earned) as total_points
FROM workout_sessions
GROUP BY DATE(completed_at);
```

---

## 🎯 NEXT STEPS

1. ✅ Review architecture document

2. 🏗️ Set up development environment (Flutter 3.38 + Firebase)

3. 📱 Initialize Flutter project with Firebase

4. ⚡ Set up Firebase services (Auth, Firestore, Storage, Functions)

5. 💾 Create Firestore collections and security rules

6. 🎥 Set up Firebase Storage for videos

7. 🚀 Build MVP features with Flutter

**Architecture Status:** Production-Ready ✅  
**Stack:** Flutter 3.38 + Dart 3.10 + Firebase  
**Focus:** Speed to market, rapid iteration, scalable infrastructure

---
