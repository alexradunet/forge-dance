# Forge.Dance - Atomic Design Architecture

## Overview

This application follows the **Atomic Design** methodology by Brad Frost, organizing components into a hierarchical structure from smallest to largest.

## Directory Structure

```
src/
├── app/
│   ├── components/
│   │   ├── atoms/           # Smallest building blocks
│   │   ├── molecules/       # Groups of atoms
│   │   └── organisms/       # Complex UI components
│   ├── pages/              # Full page components
│   └── App.tsx             # Root component
└── styles/
    ├── fonts.css           # Font imports
    └── theme.css           # Design system tokens
```

## Component Hierarchy

### Atoms
Basic building blocks that can't be broken down further:
- **Icon** - Material Symbols icons wrapper
- **Button** - Button with variants (primary, secondary, ghost, danger)
- **Badge** - Small labels with color variants
- **Avatar** - User profile images with status indicators
- **ProgressBar** - Visual progress indicator
- **PaginationDot** - Navigation dots (circle/bar variants)

### Molecules
Simple groups of atoms functioning together:
- **StatCard** - Icon + value + label combination
- **ModuleCard** - Course/module preview with progress
- **NavButton** - Navigation item with icon and label
- **LessonNode** - Learning path node with status

### Organisms
Complex components made of molecules and atoms:
- **BottomNav** - Complete bottom navigation bar
- **Header** - Page header with back/more actions
- **HeroCard** - Large featured content card
- **MovementCard** - Detailed movement/exercise card

### Pages
Full page layouts:
- **HomePage** - Dashboard with hero, progress, modules
- **ExplorePage** - Browse courses and content
- **StatsPage** - User statistics and activity
- **ProfilePage** - User profile and achievements
- **LearningPathPage** - Lesson progression view
- **MovementDetailPage** - Movement card detail

## Design System

### Colors
```css
--color-forge-fire: #FF4500     /* Primary brand color */
--color-electric-blue: #00BFFF  /* Secondary accent */
--color-legend-gold: #FFD700    /* Achievement/premium */
--color-mystic-purple: #A855F7  /* Special states */

--color-bg-deep: #0A0A0A        /* App background */
--color-surface-dark: #121212   /* Card backgrounds */
--color-surface-card: #1E1E1E   /* Elevated surfaces */

--color-text-main: #FFFFFF      /* Primary text */
--color-text-muted: #A1A1AA     /* Secondary text */
```

### Typography
- **Display/Headers**: Bebas Neue (uppercase, tracking-wide)
- **Body**: Inter (weights 400-900)
- **Monospace**: JetBrains Mono (stats, metrics)

### Spacing
- Small: 0.5rem (8px)
- Medium: 1rem (16px)
- Large: 1.5rem (24px)
- XL: 2rem (32px)

### Border Radius
- Default: 0.5rem
- Large: 0.75rem
- XL: 1rem
- 2XL: 1.5rem
- 3XL: 2rem

## Component Props Pattern

All components follow consistent prop patterns:

```tsx
interface ComponentProps {
  // Content
  children?: React.ReactNode;
  
  // Variants
  variant?: 'primary' | 'secondary' | ...;
  size?: 'sm' | 'md' | 'lg';
  
  // Styling
  className?: string;
  
  // Behavior
  onClick?: () => void;
  disabled?: boolean;
}
```

## State Management

- Local state using React hooks (useState, useEffect)
- No global state management needed for this demo
- Navigation state in App.tsx

## Responsive Design

- Mobile-first approach
- Max-width container: 500px (centered)
- Uses Tailwind responsive utilities
- Touch-optimized interactions

## Accessibility

- Semantic HTML elements
- ARIA labels where needed
- Keyboard navigation support
- High contrast ratios
- Focus states on interactive elements

## Animation Guidelines

- Transitions: 300ms ease
- Hover effects: scale(1.05)
- Active states: scale(0.95)
- Loading states: pulse animation
- Smooth page transitions

## Icon System

Using Material Symbols Outlined:
- Unfilled by default
- `.filled` class for solid icons
- Consistent sizing: text-[20px], text-[24px], text-[28px]

## Best Practices

1. **Component Composition**: Build complex UIs from simple components
2. **Single Responsibility**: Each component does one thing well
3. **Prop Consistency**: Similar components share prop patterns
4. **Style Isolation**: Use Tailwind classes, avoid inline styles
5. **Reusability**: Make components flexible with props
6. **Performance**: Use React.memo for expensive components

## Development Workflow

1. Start with atoms
2. Combine into molecules
3. Build organisms
4. Compose pages
5. Test in isolation
6. Document usage

## Future Enhancements

- Add Storybook for component documentation
- Implement unit tests
- Add animation library (Framer Motion)
- Create form components
- Add data visualization components
- Implement dark/light theme toggle
