/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        'forge-fire': '#FF4500',
        'electric-blue': '#00BFFF',
        'legend-gold': '#FFD700',
        'mystic-purple': '#A855F7',
        'bg-deep': '#0A0A0A',
        'surface-dark': '#121212',
        'surface-card': '#1E1E1E',
        'surface-light': '#2C2C2C',
        'text-main': '#FFFFFF',
        'text-muted': '#A1A1AA',
        'text-dark': '#71717A',
      },
      fontFamily: {
        title: ['Bebas Neue', 'sans-serif'],
        body: ['Inter', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      borderRadius: {
        'DEFAULT': '0.5rem',
        'lg': '0.75rem',
        'xl': '1rem',
        '2xl': '1.5rem',
        '3xl': '2rem',
      },
      boxShadow: {
        'glow-primary': '0 0 25px rgba(255, 69, 0, 0.4)',
        'glow-intense': '0 0 35px rgba(255, 69, 0, 0.6)',
        'glow-blue': '0 0 20px rgba(0, 191, 255, 0.3)',
        'card': '0 4px 20px rgba(0, 0, 0, 0.5)',
      },
      animation: {
        'beat': 'beat 1s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'shimmer': 'shimmer 2s linear infinite',
      },
      keyframes: {
        beat: {
          '0%, 100%': { transform: 'scale(1)', opacity: '0.5' },
          '50%': { transform: 'scale(1.3)', opacity: '1' },
        },
        shimmer: {
          '0%': { backgroundPosition: '200% center' },
          '100%': { backgroundPosition: '-200% center' },
        },
      },
    },
  },
  plugins: [],
}
