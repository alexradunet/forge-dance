---
type: Page
title: Forge Design System
description: null
icon: null
createdAt: '2026-01-23T23:01:08.257Z'
creationDate: 2026-01-24 01:01
modificationDate: 2026-01-24 01:01
tags: []
coverImage: null
---

# 🎨 FORGE.DANCE - DESIGN SYSTEM & UI/UX

**Version:** 1.0**Date:** January 2026**Status:** Production Design System

---

## 🎭 BRAND IDENTITY

### Brand Essence

```text
╔════════════════════════════════════════════════╗
║              FORGE.DANCE DNA                   ║
╠════════════════════════════════════════════════╣
║                                                ║
║  🔥 POWERFUL   - Intense, transformative       ║
║  ⚡ DYNAMIC     - Fast-paced, energetic        ║
║  💎 PREMIUM    - High-quality, refined         ║
║  🎮 PLAYFUL    - Gamified, fun                 ║
║  🌍 INCLUSIVE  - All styles, all levels        ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Visual Metaphors

```text
The Forge = Transformation Space
Fire = Energy & Passion
Metal/Steel = Strength & Resilience
Lightning = Speed & Power
Crystal = Clarity & Achievement
Gold = Legendary Status
```

---

## 🎨 COLOR SYSTEM

### Primary Palette

```text
╔════════════════════════════════════════════════╗
║              PRIMARY COLORS                    ║
╠════════════════════════════════════════════════╣
║                                                ║
║  🔥 FORGE FIRE                                 ║
║  #FF4500  ████████  rgb(255, 69, 0)           ║
║  ↑ Primary brand color, CTAs, highlights      ║
║                                                ║
║  ⚡ ELECTRIC BLUE                              ║
║  #00BFFF  ████████  rgb(0, 191, 255)          ║
║  ↑ Secondary actions, progress, energy        ║
║                                                ║
║  💎 CRYSTAL WHITE                              ║
║  #F0F8FF  ████████  rgb(240, 248, 255)        ║
║  ↑ Text on dark backgrounds, highlights       ║
║                                                ║
║  🌑 STEEL GRAY                                 ║
║  #2C2C2C  ████████  rgb(44, 44, 44)           ║
║  ↑ Primary background, surfaces               ║
║                                                ║
║  👑 LEGEND GOLD                                ║
║  #FFD700  ████████  rgb(255, 215, 0)          ║
║  ↑ Achievements, premium features             ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Extended Palette

```text
╔════════════════════════════════════════════════╗
║            ACCENT & UTILITY COLORS             ║
╠════════════════════════════════════════════════╣
║                                                ║
║  ✨ MYSTIC PURPLE                              ║
║  #8B00FF  ████████  rgb(139, 0, 255)          ║
║  ↑ Magic moments, special features            ║
║                                                ║
║  🌿 GROWTH GREEN                               ║
║  #10B981  ████████  rgb(16, 185, 129)         ║
║  ↑ Success states, progress indicators        ║
║                                                ║
║  ❤️ PASSION RED                                ║
║  #DC143C  ████████  rgb(220, 20, 60)          ║
║  ↑ High intensity, warnings                   ║
║                                                ║
║  ☀️ WARNING AMBER                              ║
║  #F59E0B  ████████  rgb(245, 158, 11)         ║
║  ↑ Alerts, attention needed                   ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Dance Style Colors

```text
╔════════════════════════════════════════════════╗
║           STYLE-SPECIFIC COLORS                ║
╠════════════════════════════════════════════════╣
║                                                ║
║  🎤 Hip Hop        #8B00FF  ████████           ║
║  💃 Contemporary   #00BFFF  ████████           ║
║  🩰 Ballet         #EC4899  ████████           ║
║  🎺 Jazz           #F59E0B  ████████           ║
║  🔥 Latin          #EF4444  ████████           ║
║  🌪️ Breaking       #10B981  ████████           ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Neutral Scale

```text
╔════════════════════════════════════════════════╗
║              GRAY SCALE                        ║
╠════════════════════════════════════════════════╣
║                                                ║
║  Gray 950   #0A0A0A  ██████  Almost black     ║
║  Gray 900   #111827  ██████  Dark bg          ║
║  Gray 800   #1F2937  ██████  Card bg          ║
║  Gray 700   #374151  ██████  Borders          ║
║  Gray 600   #4B5563  ██████  Disabled         ║
║  Gray 500   #6B7280  ██████  Muted text       ║
║  Gray 400   #9CA3AF  ██████  Placeholder      ║
║  Gray 300   #D1D5DB  ██████  Borders light    ║
║  Gray 200   #E5E7EB  ██████  Dividers         ║
║  Gray 100   #F3F4F6  ██████  Light bg         ║
║  Gray 50    #F9FAFB  ██████  Subtle bg        ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Color Usage Guidelines

```typescript
// Tailwind Config
module.exports = {
  theme: {
    extend: {
      colors: {
        forge: {
          fire: '#FF4500',
          electric: '#00BFFF',
          crystal: '#F0F8FF',
          steel: '#2C2C2C',
          gold: '#FFD700',
          mystic: '#8B00FF',
        },
        styles: {
          hiphop: '#8B00FF',
          contemporary: '#00BFFF',
          ballet: '#EC4899',
          jazz: '#F59E0B',
          latin: '#EF4444',
          breaking: '#10B981',
        }
      }
    }
  }
}
```

---

## 📝 TYPOGRAPHY

### Font Families

```text
╔════════════════════════════════════════════════╗
║               FONT SYSTEM                      ║
╠════════════════════════════════════════════════╣
║                                                ║
║  🏆 DISPLAY FONT                               ║
║  Bebas Neue                                    ║
║  → Headers, titles, hero text                 ║
║  → Bold, impactful, attention-grabbing        ║
║                                                ║
║  📖 BODY FONT                                  ║
║  Inter                                         ║
║  → All body text, UI elements                 ║
║  → Clean, readable, modern                    ║
║                                                ║
║  🔢 MONOSPACE FONT                             ║
║  JetBrains Mono                                ║
║  → Stats, timers, numbers                     ║
║  → Code blocks, technical content             ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Type Scale

```text
╔════════════════════════════════════════════════╗
║              TYPE SCALE (Mobile)               ║
╠════════════════════════════════════════════════╣
║                                                ║
║  H1 - 48px   Bebas Neue Bold                   ║
║  "FORGE YOUR LEGEND"                           ║
║  ↑ Page titles, major headings                ║
║                                                ║
║  H2 - 36px   Bebas Neue Bold                   ║
║  "TODAY'S CHALLENGE"                           ║
║  ↑ Section titles, feature headers            ║
║                                                ║
║  H3 - 30px   Inter Semibold                    ║
║  Your Progress                                 ║
║  ↑ Card titles, prominent labels              ║
║                                                ║
║  H4 - 24px   Inter Semibold                    ║
║  Exercise Details                              ║
║  ↑ Subsection headings                        ║
║                                                ║
║  H5 - 20px   Inter Medium                      ║
║  Power Level 2,450                             ║
║  ↑ Component titles                           ║
║                                                ║
║  H6 - 18px   Inter Medium                      ║
║  Workout Stats                                 ║
║  ↑ Small headings                             ║
║                                                ║
║  Body Large - 18px   Inter Regular             ║
║  Primary body text for emphasis                ║
║                                                ║
║  Body - 16px   Inter Regular                   ║
║  Standard body text, descriptions              ║
║                                                ║
║  Body Small - 14px   Inter Regular             ║
║  Secondary text, metadata                      ║
║                                                ║
║  Caption - 12px   Inter Regular                ║
║  Captions, timestamps, hints                   ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Typography in Code

```typescript
// Tailwind Typography Classes
export const typography = {
  h1: 'font-bebas text-5xl font-bold leading-tight',
  h2: 'font-bebas text-4xl font-bold leading-snug',
  h3: 'font-inter text-3xl font-semibold leading-snug',
  h4: 'font-inter text-2xl font-semibold',
  h5: 'font-inter text-xl font-medium',
  h6: 'font-inter text-lg font-medium',
  bodyLarge: 'font-inter text-lg',
  body: 'font-inter text-base',
  bodySmall: 'font-inter text-sm',
  caption: 'font-inter text-xs',
  mono: 'font-jetbrains',
}
// Usage
<Text className={typography.h1}>FORGE YOUR LEGEND</Text>
```

---

## 🎯 SPACING SYSTEM

### Spacing Scale (4px base unit)

```text
╔════════════════════════════════════════════════╗
║            SPACING TOKENS                      ║
╠════════════════════════════════════════════════╣
║                                                ║
║  0   = 0px      ·                              ║
║  1   = 4px      ····                           ║
║  2   = 8px      ········                       ║
║  3   = 12px     ············                   ║
║  4   = 16px     ················               ║
║  5   = 20px     ····················           ║
║  6   = 24px     ························       ║
║  8   = 32px     ································║
║  10  = 40px     (large spacing)                ║
║  12  = 48px     (extra large)                  ║
║  16  = 64px     (section spacing)              ║
║  20  = 80px     (major sections)               ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Component Spacing Examples

```text
Card Padding:
┌─────────────────────────┐
│ ← 16px                  │ ← Top padding
│    Content              │
│ ← 16px                  │ ← Bottom padding
└─────────────────────────┘
Stack Spacing (Vertical):
┌─────────────────┐
│   Component 1   │
└─────────────────┘
        ↕ 16px gap
┌─────────────────┐
│   Component 2   │
└─────────────────┘
Grid Gaps:
┌────────┐ ← 12px → ┌────────┐
│  Card  │          │  Card  │
└────────┘          └────────┘
```

---

## 🎨 COMPONENT LIBRARY

### Buttons

```text
╔════════════════════════════════════════════════╗
║               BUTTON VARIANTS                  ║
╠════════════════════════════════════════════════╣
║                                                ║
║  PRIMARY (Filled)                              ║
║  ┌──────────────────────┐                      ║
║  │   START WORKOUT  ⚡  │  ← Forge Fire bg     ║
║  └──────────────────────┘                      ║
║  → Main CTAs, important actions                ║
║                                                ║
║  SECONDARY (Outlined)                          ║
║  ┌──────────────────────┐                      ║
║  │   VIEW DETAILS    →  │  ← Transparent bg   ║
║  └──────────────────────┘     Electric border ║
║  → Secondary actions                           ║
║                                                ║
║  GHOST (Text only)                             ║
║     Skip Exercise  →     ← No border/bg       ║
║  → Tertiary actions, cancel                    ║
║                                                ║
║  ICON BUTTON                                   ║
║  ┌──────┐                                      ║
║  │  ⏸  │  ← Square with icon                  ║
║  └──────┘                                      ║
║  → Compact actions, toolbars                   ║
║                                                ║
║  FAB (Floating Action)                         ║
║     ┌────┐                                     ║
║     │ + │  ← Circular, floating                ║
║     └────┘                                     ║
║  → Primary floating action                     ║
║                                                ║
╚════════════════════════════════════════════════╝
```

#### Button Implementation

```tsx
// Button.tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost' | 'icon'
  size?: 'sm' | 'md' | 'lg'
  icon?: React.ReactNode
  children: React.ReactNode
  onPress: () => void
}
const buttonVariants = {
  primary: 'bg-forge-fire text-white active:bg-forge-fire/90',
  secondary: 'bg-transparent border-2 border-forge-electric text-forge-electric',
  ghost: 'bg-transparent text-forge-electric',
  icon: 'bg-gray-800 text-white w-12 h-12 rounded-lg',
}
const buttonSizes = {
  sm: 'px-4 py-2 text-sm',
  md: 'px-6 py-3 text-base',
  lg: 'px-8 py-4 text-lg',
}
export function Button({
  variant = 'primary',
  size = 'md',
  icon,
  children,
  onPress,
}: ButtonProps) {
  return (
    <TouchableOpacity
      onPress={onPress}
      className={`
        ${buttonVariants[variant]}
        ${buttonSizes[size]}
        rounded-xl
        font-semibold
        flex-row items-center justify-center gap-2
        active:scale-95
        transition-transform
      `}
    >
      {icon}
      <Text className="font-semibold">{children}</Text>
    </TouchableOpacity>
  )
}
```

### Cards

```text
╔════════════════════════════════════════════════╗
║                CARD VARIANTS                   ║
╠════════════════════════════════════════════════╣
║                                                ║
║  WOD CARD (Featured)                           ║
║  ┌────────────────────────────────────────┐   ║
║  │ ┌──────────────────────────────────┐   │   ║
║  │ │     [Hero Image/Video]           │   │   ║
║  │ └──────────────────────────────────┘   │   ║
║  │                                        │   ║
║  │ 🔥 Hip Hop Thunder Strike              │   ║
║  │ Level 5 • 45 min                       │   ║
║  │                                        │   ║
║  │ Focus: Rhythm & Isolation              │   ║
║  │                                        │   ║
║  │ ┌──────────────────────────────────┐   │   ║
║  │ │    START WORKOUT  ⚡             │   │   ║
║  │ └──────────────────────────────────┘   │   ║
║  └────────────────────────────────────────┘   ║
║                                                ║
║  EXERCISE CARD (Library)                       ║
║  ┌─────────────────────┐                       ║
║  │ [Thumbnail]         │                       ║
║  │ Chest Pops          │                       ║
║  │ Hip Hop • Level 3   │                       ║
║  │ ⏱ 45 seconds        │                       ║
║  └─────────────────────┘                       ║
║                                                ║
║  STATS CARD                                    ║
║  ┌─────────────────────────────────────────┐  ║
║  │ 🔥 Current Streak                       │  ║
║  │                                         │  ║
║  │        7 DAYS                           │  ║
║  │   ████████████░░░░░░ 70%                │  ║
║  │                                         │  ║
║  │ Next milestone: 14 days                 │  ║
║  └─────────────────────────────────────────┘  ║
║                                                ║
╚════════════════════════════════════════════════╝
```

#### Card Implementation

```tsx
// WODCard.tsx
interface WODCardProps {
  wod: {
    id: string
    title: string
    style: string
    difficulty: number
    duration: number
    thumbnailUrl: string
    forgePoints: number
  }
  onPress: () => void
}
export function WODCard({ wod, onPress }: WODCardProps) {
  return (
    <TouchableOpacity
      onPress={onPress}
      className="
        bg-gray-800 rounded-2xl overflow-hidden
        active:scale-98 transition-transform
      "
    >
      {/* Hero Image */}
      <Image
        source={{ uri: wod.thumbnailUrl }}
        className="w-full h-48"
        resizeMode="cover"
      />
      
      {/* Content */}
      <View className="p-6">
        <View className="flex-row items-center gap-2 mb-2">
          <Text className="text-2xl">🔥</Text>
          <Text className="text-white text-xl font-bebas">
            {wod.title}
          </Text>
        </View>
        
        <Text className="text-gray-400 mb-4">
          Level {wod.difficulty} • {wod.duration} min • {wod.style}
        </Text>
        
        <View className="flex-row items-center justify-between mb-4">
          <Text className="text-forge-gold font-semibold">
            +{wod.forgePoints} FP
          </Text>
          <View className="flex-row gap-1">
            {[...Array(wod.difficulty)].map((_, i) => (
              <View key={i} className="w-2 h-6 bg-forge-fire rounded-full" />
            ))}
          </View>
        </View>
        
        <Button variant="primary" onPress={onPress}>
          START WORKOUT
        </Button>
      </View>
    </TouchableOpacity>
  )
}
```

### Input Fields

```text
╔════════════════════════════════════════════════╗
║              INPUT VARIANTS                    ║
╠════════════════════════════════════════════════╣
║                                                ║
║  TEXT INPUT                                    ║
║  ┌─────────────────────────────────────────┐  ║
║  │ 📧 Email                                │  ║
║  │ your@email.com                          │  ║
║  └─────────────────────────────────────────┘  ║
║                                                ║
║  PASSWORD INPUT                                ║
║  ┌─────────────────────────────────────────┐  ║
║  │ 🔒 Password                             │  ║
║  │ ••••••••                           👁   │  ║
║  └─────────────────────────────────────────┘  ║
║                                                ║
║  SEARCH INPUT                                  ║
║  ┌─────────────────────────────────────────┐  ║
║  │ 🔍 Search exercises...                  │  ║
║  └─────────────────────────────────────────┘  ║
║                                                ║
║  ERROR STATE                                   ║
║  ┌─────────────────────────────────────────┐  ║
║  │ 📧 Email                                │  ║
║  │ invalid-email                      ⚠️   │  ║
║  └─────────────────────────────────────────┘  ║
║  Invalid email format                          ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Progress Indicators

```text
╔════════════════════════════════════════════════╗
║           PROGRESS INDICATORS                  ║
╠════════════════════════════════════════════════╣
║                                                ║
║  LINEAR PROGRESS BAR                           ║
║  ████████████░░░░░░░░ 60%                      ║
║                                                ║
║  CIRCULAR PROGRESS                             ║
║     ╭───────╮                                  ║
║     │  60%  │                                  ║
║     ╰───────╯                                  ║
║                                                ║
║  LEVEL PROGRESS                                ║
║  Level 5                                       ║
║  ████████████████▓▓▓▓ 80%                      ║
║  320 FP to Level 6                             ║
║                                                ║
║  STREAK CALENDAR                               ║
║   M  T  W  T  F  S  S                          ║
║   ✅ ✅ ✅ ⭕ ✅ ⭕ ⭕                              ║
║                                                ║
╚════════════════════════════════════════════════╝
```

---

## 🎭 ANIMATION SYSTEM

### Motion Principles

```text
╔════════════════════════════════════════════════╗
║           ANIMATION GUIDELINES                 ║
╠════════════════════════════════════════════════╣
║                                                ║
║  ⚡ FAST - 100-200ms                           ║
║  → Micro-interactions, hovers, taps           ║
║                                                ║
║  🎯 STANDARD - 300ms                           ║
║  → Screen transitions, modal appearances      ║
║                                                ║
║  🌊 SLOW - 500ms+                              ║
║  → Complex animations, celebrations           ║
║                                                ║
║  EASING FUNCTIONS:                             ║
║  → ease-in-out (default)                      ║
║  → spring (interactive elements)              ║
║  → linear (progress bars)                     ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Animation Examples

```typescript
// Reanimated 2 Animations
// Button Press
const scale = useSharedValue(1)
const animatedStyle = useAnimatedStyle(() => ({
  transform: [{ scale: scale.value }]
}))
const handlePress = () => {
  scale.value = withSequence(
    withTiming(0.95, { duration: 100 }),
    withSpring(1)
  )
}
// Screen Transition
const translateX = useSharedValue(300)
useEffect(() => {
  translateX.value = withTiming(0, { duration: 300 })
}, [])
// Level Up Animation
const levelUpScale = useSharedValue(0)
const levelUpOpacity = useSharedValue(0)
function triggerLevelUp() {
  levelUpScale.value = withSequence(
    withTiming(1.2, { duration: 200 }),
    withSpring(1)
  )
  levelUpOpacity.value = withSequence(
    withTiming(1, { duration: 200 }),
    withDelay(2000, withTiming(0, { duration: 300 }))
  )
}
```

### Celebration Animations

```text
WORKOUT COMPLETE:
┌────────────────────────────────┐
│                                │
│         ✨ 🎉 ✨              │
│                                │
│     WORKOUT COMPLETE!          │
│                                │
│    +500 FORGE POINTS           │
│                                │
│  Power Level: 2,450 → 2,950    │
│                                │
└────────────────────────────────┘
↑ Scale + bounce animation
↑ Confetti particles burst
↑ Counter animates up
```

---

## 📱 RESPONSIVE DESIGN

### Breakpoints

```text
╔════════════════════════════════════════════════╗
║              BREAKPOINTS                       ║
╠════════════════════════════════════════════════╣
║                                                ║
║  Mobile      320px - 767px                     ║
║  → Single column                               ║
║  → Bottom tab navigation                       ║
║  → Full-width components                       ║
║                                                ║
║  Tablet      768px - 1023px                    ║
║  → Two columns                                 ║
║  → Side navigation option                      ║
║  → Larger cards                                ║
║                                                ║
║  Desktop     1024px+                           ║
║  → Three+ columns                              ║
║  → Sidebar navigation                          ║
║  → Multi-panel views                           ║
║  → Hover interactions                          ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Layout Patterns

```text
MOBILE LAYOUT (Portrait):
┌─────────────────────┐
│      Header         │
├─────────────────────┤
│                     │
│     Content         │
│    (Scrollable)     │
│                     │
│                     │
├─────────────────────┤
│    Tab Bar          │
└─────────────────────┘
TABLET LAYOUT:
┌───────┬─────────────┐
│ Side  │   Content   │
│ Nav   │             │
│       │             │
│       │             │
│       │             │
└───────┴─────────────┘
DESKTOP LAYOUT:
┌───┬─────────┬───────┐
│ N │ Main    │ Side  │
│ a │ Content │ Panel │
│ v │         │       │
│   │         │       │
└───┴─────────┴───────┘
```

---

## 🎯 ICONOGRAPHY

### Icon System

```text
╔════════════════════════════════════════════════╗
║               ICON LIBRARY                     ║
╠════════════════════════════════════════════════╣
║                                                ║
║  Source: Lucide React                          ║
║  Style: 2px stroke, rounded corners            ║
║  Sizes: 16px, 20px, 24px, 32px                 ║
║                                                ║
║  NAVIGATION ICONS:                             ║
║  🏠 Home         → House                       ║
║  📚 Library      → BookOpen                    ║
║  📈 Progress     → TrendingUp                  ║
║  👥 Social       → Users                       ║
║  👤 Profile      → User                        ║
║                                                ║
║  ACTION ICONS:                                 ║
║  ▶️ Play         → Play                        ║
║  ⏸ Pause        → Pause                       ║
║  ⏭ Skip         → SkipForward                 ║
║  🔄 Repeat       → Repeat                      ║
║  ⚙️ Settings     → Settings                    ║
║  🔍 Search       → Search                      ║
║                                                ║
║  STATUS ICONS:                                 ║
║  ✅ Complete     → CheckCircle                 ║
║  ❌ Error        → XCircle                     ║
║  ⚠️ Warning      → AlertTriangle               ║
║  ℹ️ Info         → Info                        ║
║                                                ║
║  GAMIFICATION:                                 ║
║  🔥 Streak       → Flame                       ║
║  ⚡ Power        → Zap                         ║
║  🏆 Achievement  → Trophy                      ║
║  ⭐ Star         → Star                        ║
║                                                ║
╚════════════════════════════════════════════════╝
```

### Custom Icons (SVG)

```tsx
// ForgeIcon.tsx
export function ForgeIcon({ size = 24, color = 'currentColor' }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
    >
      <path
        d="M12 2L2 7L12 12L22 7L12 2Z"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M2 17L12 22L22 17"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M2 12L12 17L22 12"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  )
}
```

---

## 🎨 DARK MODE (Primary Theme)

### Dark Mode Colors

```text
╔════════════════════════════════════════════════╗
║            DARK MODE PALETTE                   ║
╠════════════════════════════════════════════════╣
║                                                ║
║  Background Layers:                            ║
║  ┌──────────────────────────────────────────┐ ║
║  │ bg-gray-950  #0A0A0A  ██████  Base       │ ║
║  │ bg-gray-900  #111827  ██████  Surface    │ ║
║  │ bg-gray-800  #1F2937  ██████  Card       │ ║
║  │ bg-gray-700  #374151  ██████  Elevated  │ ║
║  └──────────────────────────────────────────┘ ║
║                                                ║
║  Text Colors:                                  ║
║  → Primary:   #F9FAFB (Gray 50)                ║
║  → Secondary: #9CA3AF (Gray 400)               ║
║  → Muted:     #6B7280 (Gray 500)               ║
║                                                ║
║  Borders:                                      ║
║  → Default:   #374151 (Gray 700)               ║
║  → Subtle:    #1F2937 (Gray 800)               ║
║                                                ║
╚════════════════════════════════════════════════╝
```

---

## 🎬 SCREEN DESIGNS

### 1. Splash Screen

```text
┌─────────────────────────────────┐
│                                 │
│                                 │
│                                 │
│         ╭─────────╮             │
│         │  🔥⚡💎  │             │
│         ╰─────────╯             │
│                                 │
│        FORGE.DANCE              │
│                                 │
│    Where Legends Are Forged     │
│                                 │
│         ● ● ● ◯                 │ ← Loading
│                                 │
│                                 │
│                                 │
└─────────────────────────────────┘
```

### 2. Home Screen

```text
┌─────────────────────────────────────┐
│  Good Morning, Alex! 🌟        🔔  │
├─────────────────────────────────────┤
│                                     │
│  🔥 TODAY'S FORGE CHALLENGE         │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │   [Hero Video/Image]          │  │
│  │                               │  │
│  │ Hip Hop Thunder Strike        │  │
│  │ Level 5 • 45 min              │  │
│  │                               │  │
│  │ Focus: Rhythm & Isolation     │  │
│  │                               │  │
│  │ ┌───────────────────────────┐ │  │
│  │ │  START WORKOUT  ⚡        │ │  │
│  │ └───────────────────────────┘ │  │
│  └───────────────────────────────┘  │
│                                     │
│  Your Progress                      │
│  ┌───────────────────────────────┐  │
│  │ 🔥 Streak: 7 days              │  │
│  │ ████████████░░░░ 80%           │  │
│  │ Level 5 → Level 6              │  │
│  └───────────────────────────────┘  │
│                                     │
│  Quick Actions                      │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ 📹   │ │ 💪   │ │ 🎯   │        │
│  │Review│ │Custom│ │Goals │        │
│  └──────┘ └──────┘ └──────┘        │
│                                     │
├─────────────────────────────────────┤
│  🏠  📚  📈  👥  👤                  │
│ Home Lib Stats Social You           │
└─────────────────────────────────────┘
```

### 3. Workout Player

```text
┌─────────────────────────────────────┐
│  ✕                             ⏸   │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│       [Video Player]                │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│  Chest Pops                         │
│                                     │
│          00:28                      │
│    ████████████░░░░░░ 60%           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Tips: Focus on quick         │   │
│  │ contractions, like catching  │   │
│  │ something on your chest      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Next: Arm Waves                    │
│                                     │
│  ┌─────────┐     ┌─────────┐       │
│  │  Skip   │     │  Next   │       │
│  └─────────┘     └─────────┘       │
└─────────────────────────────────────┘
```

### 4. Profile & Progress

```text
┌─────────────────────────────────────┐
│  ← Your Profile              ⚙️     │
├─────────────────────────────────────┤
│                                     │
│        ┌─────────┐                  │
│        │   👤    │                  │
│        │  Alex   │                  │
│        └─────────┘                  │
│                                     │
│       @alexdances                   │
│     Level 5 • Hip Hop               │
│                                     │
│  ┌─────────────────────────────┐   │
│  │      Edit Profile           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │      POWER LEVEL            │   │
│  │                             │   │
│  │        ⚡ 2,450 ⚡            │   │
│  │                             │   │
│  │  ▰▰▰▰▰▰▰▰▱▱▱▱▱▱ 65%         │   │
│  │  Next: 3,000 (INFERNO)      │   │
│  └─────────────────────────────┘   │
│                                     │
│  This Month                         │
│  ┌─────────────────────────────┐   │
│  │     📊 Activity Chart        │   │
│  │ 30┤                          │   │
│  │ 20┤    ▓▓                    │   │
│  │ 10┤ ▓▓ ▓▓ ▓▓    ▓▓           │   │
│  │  0└────────────────────────  │   │
│  │   M  T  W  T  F  S  S        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Stats                              │
│  🔥 Current Streak:  8 days         │
│  📅 Total WODs:      45             │
│  ⏱ Practice Time:   22.5h           │
│  💪 Favorite Style: Hip Hop         │
│                                     │
│  Achievements                       │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │  🏆  │ │  🎯  │ │  ⭐  │        │
│  │ Week │ │First │ │Level │        │
│  │Warrior│ │Steps │ │ Up  │        │
│  └──────┘ └──────┘ └──────┘        │
│                                     │
└─────────────────────────────────────┘
```

### 5. Leaderboard

```text
┌─────────────────────────────────────┐
│  ← Leaderboard            🌍 Global │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ [Global] Style  Local  Friends│  │
│  └───────────────────────────────┘  │
│                                     │
│  🥇 1. @dancequeen                  │
│     👤 Sarah M.                     │
│     ⚡ 156,780 FP                   │
│     ───────────────────────────     │
│                                     │
│  🥈 2. @hiphophero                  │
│     👤 Marcus L.                    │
│     ⚡ 142,350 FP                   │
│     ───────────────────────────     │
│                                     │
│  🥉 3. @breakmaster                 │
│     👤 Jamie K.                     │
│     ⚡ 138,920 FP                   │
│     ───────────────────────────     │
│                                     │
│  ...                                │
│                                     │
│  ▼ 23. YOU                          │
│     👤 Alex D.                      │
│     ⚡ 98,450 FP                    │
│     ═══════════════════════════     │
│                                     │
│  Next Tournament:                   │
│  🏆 Weekend Warrior Challenge       │
│  Starts in 2 days                   │
│  ┌─────────────────────────────┐   │
│  │      JOIN TOURNAMENT        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 🎨 DESIGN TOKENS (Code)

### Complete Tailwind Configuration

```javascript
// tailwind.config.js
module.exports = {
  content: [
    './app/**/*.{js,jsx,ts,tsx}',
    './components/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        forge: {
          fire: '#FF4500',
          'fire-dark': '#DC3A00',
          'fire-light': '#FF6B33',
          electric: '#00BFFF',
          'electric-dark': '#0099CC',
          'electric-light': '#33CCFF',
          crystal: '#F0F8FF',
          steel: '#2C2C2C',
          'steel-light': '#3A3A3A',
          gold: '#FFD700',
          mystic: '#8B00FF',
        },
        styles: {
          hiphop: '#8B00FF',
          contemporary: '#00BFFF',
          ballet: '#EC4899',
          jazz: '#F59E0B',
          latin: '#EF4444',
          breaking: '#10B981',
        },
      },
      fontFamily: {
        bebas: ['Bebas Neue', 'sans-serif'],
        inter: ['Inter', 'sans-serif'],
        jetbrains: ['JetBrains Mono', 'monospace'],
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
        '128': '32rem',
      },
      borderRadius: {
        '4xl': '2rem',
      },
      animation: {
        'forge-glow': 'glow 2s ease-in-out infinite',
        'float': 'float 3s ease-in-out infinite',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        glow: {
          '0%, 100%': { 
            boxShadow: '0 0 20px rgba(255, 69, 0, 0.5)' 
          },
          '50%': { 
            boxShadow: '0 0 40px rgba(255, 69, 0, 0.8)' 
          },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
      },
      boxShadow: {
        'forge': '0 0 30px rgba(255, 69, 0, 0.3)',
        'electric': '0 0 30px rgba(0, 191, 255, 0.3)',
        'gold': '0 0 30px rgba(255, 215, 0, 0.3)',
      },
    },
  },
  plugins: [],
}
```

---

## 📐 LAYOUT GRID

### Mobile Grid System (375px width)

```text
|← 16px →|← 343px (content) →|← 16px →|
|  margin |                   |  margin |
12 Column Grid:
|←→|←→|←→|←→|←→|←→|←→|←→|←→|←→|←→|←→|
 ~28px per column with 8px gutters
```

### Component Sizing

```text
┌─────────────────────────────────────┐
│ Button Heights:                     │
│ Small:  32px (py-2)                 │
│ Medium: 44px (py-3)                 │
│ Large:  56px (py-4)                 │
│                                     │
│ Card Padding:                       │
│ Compact: 12px (p-3)                 │
│ Default: 16px (p-4)                 │
│ Spacious: 24px (p-6)                │
│                                     │
│ Border Radius:                      │
│ Small:  8px (rounded-lg)            │
│ Medium: 12px (rounded-xl)           │
│ Large:  16px (rounded-2xl)          │
│                                     │
└─────────────────────────────────────┘
```

---

## ✅ DESIGN CHECKLIST

### Before Development

```text
UI DESIGN CHECKLIST:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☐ Color palette finalized
☐ Typography system defined
☐ Component library created
☐ Icon set selected
☐ Animation principles established
☐ Responsive breakpoints defined
☐ Dark mode colors set
☐ Spacing system implemented
☐ Design tokens in code
☐ All screens designed in Figma
ACCESSIBILITY CHECKLIST:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☐ Color contrast > 4.5:1
☐ Touch targets > 44x44px
☐ Focus states visible
☐ Screen reader labels
☐ Keyboard navigation
☐ Reduced motion support
MOBILE OPTIMIZATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
☐ Thumb-friendly zones
☐ Bottom navigation reachable
☐ Swipe gestures intuitive
☐ Loading states smooth
☐ Offline state designed
```

---

## 🎯 DESIGN SYSTEM STATUS

```text
╔════════════════════════════════════════════════╗
║         DESIGN SYSTEM COMPLETE ✅              ║
╠════════════════════════════════════════════════╣
║                                                ║
║  ✅ Brand Identity                             ║
║  ✅ Color System                               ║
║  ✅ Typography                                 ║
║  ✅ Spacing & Layout                           ║
║  ✅ Component Library                          ║
║  ✅ Animation System                           ║
║  ✅ Responsive Design                          ║
║  ✅ Icon Library                               ║
║  ✅ Screen Designs                             ║
║  ✅ Design Tokens                              ║
║                                                ║
║  Status: READY FOR DEVELOPMENT 🚀              ║
║                                                ║
╚════════════════════════════════════════════════╝
```

---

**Design System Version:** 1.0**Last Updated:** January 2026**Ready to Forge!** 🔥⚡💎

