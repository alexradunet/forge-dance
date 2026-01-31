import { Icon } from '@/app/components/atoms/Icon';
import { Header } from '@/app/components/organisms/Header';
import { motion } from 'motion/react';
import { useState } from 'react';

interface AchievementsPageProps {
  onNavigate?: (page: string) => void;
}

interface Achievement {
  id: string;
  name: string;
  description: string;
  icon: string;
  color: string;
  glowColor: string;
  isUnlocked: boolean;
  unlockedDate?: string;
  category: 'training' | 'streak' | 'mastery' | 'social' | 'special';
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
}

const achievements: Achievement[] = [
  {
    id: '1',
    name: 'Groove Master',
    description: 'Complete 100 training sessions',
    icon: 'stars',
    color: 'text-yellow-400',
    glowColor: 'rgba(250,204,21,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 15, 2026',
    category: 'training',
    rarity: 'epic'
  },
  {
    id: '2',
    name: 'Perfect Week',
    description: 'Train 7 days in a row',
    icon: 'calendar_today',
    color: 'text-electric-blue',
    glowColor: 'rgba(0,191,255,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 10, 2026',
    category: 'streak',
    rarity: 'rare'
  },
  {
    id: '3',
    name: 'Inferno Streak',
    description: 'Maintain a 100-day streak',
    icon: 'whatshot',
    color: 'text-forge-fire',
    glowColor: 'rgba(255,69,0,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 5, 2026',
    category: 'streak',
    rarity: 'legendary'
  },
  {
    id: '4',
    name: 'First Steps',
    description: 'Complete your first training session',
    icon: 'footprint',
    color: 'text-green-400',
    glowColor: 'rgba(74,222,128,0.3)',
    isUnlocked: true,
    unlockedDate: 'Dec 1, 2025',
    category: 'training',
    rarity: 'common'
  },
  {
    id: '5',
    name: 'Knowledge Seeker',
    description: 'Review 50 learning cards',
    icon: 'menu_book',
    color: 'text-mystic-purple',
    glowColor: 'rgba(168,85,247,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 20, 2026',
    category: 'mastery',
    rarity: 'rare'
  },
  {
    id: '6',
    name: 'Hip-Hop Hero',
    description: 'Master 25 Hip-Hop moves',
    icon: 'music_note',
    color: 'text-yellow-400',
    glowColor: 'rgba(250,204,21,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 12, 2026',
    category: 'mastery',
    rarity: 'epic'
  },
  {
    id: '7',
    name: 'Early Bird',
    description: 'Train before 7 AM 10 times',
    icon: 'wb_sunny',
    color: 'text-orange-400',
    glowColor: 'rgba(251,146,60,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 8, 2026',
    category: 'special',
    rarity: 'rare'
  },
  {
    id: '8',
    name: 'Night Owl',
    description: 'Train after 10 PM 10 times',
    icon: 'nightlight',
    color: 'text-blue-400',
    glowColor: 'rgba(96,165,250,0.3)',
    isUnlocked: true,
    unlockedDate: 'Jan 18, 2026',
    category: 'special',
    rarity: 'rare'
  },
  {
    id: '9',
    name: 'Rhythm King',
    description: 'Achieve perfect timing 100 times',
    icon: 'timer',
    color: 'text-yellow-400',
    glowColor: 'rgba(250,204,21,0.3)',
    isUnlocked: false,
    category: 'mastery',
    rarity: 'legendary'
  },
  {
    id: '10',
    name: 'Social Butterfly',
    description: 'Share 20 achievements',
    icon: 'share',
    color: 'text-pink-400',
    glowColor: 'rgba(244,114,182,0.3)',
    isUnlocked: false,
    category: 'social',
    rarity: 'rare'
  },
  {
    id: '11',
    name: 'Dedication',
    description: 'Train 30 days in a row',
    icon: 'favorite',
    color: 'text-red-400',
    glowColor: 'rgba(248,113,113,0.3)',
    isUnlocked: false,
    category: 'streak',
    rarity: 'epic'
  },
  {
    id: '12',
    name: 'Breaking Beginner',
    description: 'Learn 10 breaking moves',
    icon: 'sports_gymnastics',
    color: 'text-electric-blue',
    glowColor: 'rgba(0,191,255,0.3)',
    isUnlocked: false,
    category: 'mastery',
    rarity: 'common'
  },
  {
    id: '13',
    name: 'Freestyle Master',
    description: 'Complete 50 freestyle sessions',
    icon: 'air',
    color: 'text-cyan-400',
    glowColor: 'rgba(34,211,238,0.3)',
    isUnlocked: false,
    category: 'training',
    rarity: 'epic'
  },
  {
    id: '14',
    name: 'Collection Curator',
    description: 'Favorite 100 cards',
    icon: 'collections_bookmark',
    color: 'text-mystic-purple',
    glowColor: 'rgba(168,85,247,0.3)',
    isUnlocked: false,
    category: 'mastery',
    rarity: 'rare'
  },
  {
    id: '15',
    name: 'Speed Demon',
    description: 'Complete a session in under 20 minutes',
    icon: 'speed',
    color: 'text-forge-fire',
    glowColor: 'rgba(255,69,0,0.3)',
    isUnlocked: false,
    category: 'special',
    rarity: 'rare'
  },
  {
    id: '16',
    name: 'Marathon Dancer',
    description: 'Train for 2 hours straight',
    icon: 'schedule',
    color: 'text-yellow-400',
    glowColor: 'rgba(250,204,21,0.3)',
    isUnlocked: false,
    category: 'special',
    rarity: 'legendary'
  }
];

const rarityColors = {
  common: 'border-green-500/30',
  rare: 'border-electric-blue/30',
  epic: 'border-mystic-purple/30',
  legendary: 'border-yellow-400/30'
};

export const AchievementsPage = ({ onNavigate }: AchievementsPageProps) => {
  const unlockedCount = achievements.filter(a => a.isUnlocked).length;
  const totalCount = achievements.length;
  const [spinningId, setSpinningId] = useState<string | null>(null);

  const handleAchievementClick = (id: string) => {
    setSpinningId(id);
    setTimeout(() => setSpinningId(null), 600);
  };

  return (
    <main className="flex-1 flex flex-col z-10 overflow-hidden relative w-full max-w-md mx-auto">
      {/* Background gradient effects */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-0">
        <div className="absolute top-[-15%] right-[-20%] w-[400px] h-[400px] bg-yellow-400/10 rounded-full blur-[100px]" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[300px] h-[300px] bg-mystic-purple/5 rounded-full blur-[80px]" />
      </div>

      <Header
        title="ACHIEVEMENTS"
        leftSlot={
          <button
            onClick={() => onNavigate?.('profile')}
            className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-white/10 transition-colors text-text-muted hover:text-white"
          >
            <Icon name="arrow_back" className="text-2xl" />
          </button>
        }
      />

      <div className="flex-1 overflow-y-auto overflow-x-hidden scrollbar-hide pb-6 relative z-10">
        {/* Progress Section */}
        <div className="bg-surface-card border border-white/5 rounded-2xl p-6 shadow-lg mx-6 mt-6 mb-6">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-2xl font-bold text-white tracking-tight">
                {unlockedCount} / {totalCount}
              </h2>
              <p className="text-xs text-text-muted mt-1">Achievements Unlocked</p>
            </div>
            <div className="w-20 h-20 rounded-full bg-gradient-to-b from-surface-dark to-black border border-yellow-400/30 flex items-center justify-center relative shadow-lg">
              <div className="absolute inset-0 bg-yellow-500/10 rounded-full blur-xl" />
              <Icon name="emoji_events" filled className="text-4xl text-yellow-400 drop-shadow-[0_0_10px_rgba(250,204,21,0.5)]" />
            </div>
          </div>
          
          {/* Progress Bar */}
          <div className="w-full bg-white/5 rounded-full h-2 overflow-hidden">
            <motion.div
              initial={{ width: 0 }}
              animate={{ width: `${(unlockedCount / totalCount) * 100}%` }}
              transition={{ duration: 1, ease: 'easeOut' }}
              className="h-full bg-gradient-to-r from-forge-fire via-yellow-400 to-electric-blue rounded-full"
            />
          </div>
        </div>

        {/* Achievements Grid */}
        <div className="px-6">
          <div className="grid grid-cols-2 gap-4">
            {achievements.map((achievement, index) => (
              <motion.div
                key={achievement.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
                onClick={() => achievement.isUnlocked && handleAchievementClick(achievement.id)}
                className={`relative group ${
                  achievement.isUnlocked ? 'cursor-pointer' : 'opacity-50 grayscale'
                }`}
              >
                <div className={`bg-surface-dark rounded-2xl p-4 border ${
                  achievement.isUnlocked 
                    ? `${rarityColors[achievement.rarity]} group-hover:border-forge-fire/50` 
                    : 'border-white/5'
                } transition-all shadow-lg`}>
                  {/* Icon */}
                  <div className={`w-16 h-16 mx-auto rounded-full bg-gradient-to-b from-surface-dark to-black border ${
                    achievement.isUnlocked 
                      ? 'border-white/10' 
                      : 'border-white/5'
                  } flex items-center justify-center relative mb-3`}>
                    {achievement.isUnlocked && (
                      <div 
                        className="absolute inset-0 rounded-full blur-xl opacity-50 group-hover:opacity-100 transition-opacity"
                        style={{ backgroundColor: achievement.glowColor }}
                      />
                    )}
                    <motion.div
                      animate={{
                        rotateY: spinningId === achievement.id ? 360 : 0
                      }}
                      transition={{
                        duration: 0.6,
                        ease: 'easeInOut'
                      }}
                      style={{ transformStyle: 'preserve-3d' }}
                    >
                      <Icon 
                        name={achievement.isUnlocked ? achievement.icon : 'lock'} 
                        filled={achievement.isUnlocked}
                        className={`text-3xl relative z-10 ${
                          achievement.isUnlocked 
                            ? achievement.color 
                            : 'text-white/20'
                        }`}
                        style={achievement.isUnlocked ? {
                          filter: `drop-shadow(0 0 8px ${achievement.glowColor})`
                        } : {}}
                      />
                    </motion.div>
                  </div>

                  {/* Name */}
                  <h3 className={`text-xs font-bold text-center mb-1 ${
                    achievement.isUnlocked ? 'text-white' : 'text-white/30'
                  }`}>
                    {achievement.name}
                  </h3>

                  {/* Description */}
                  <p className={`text-[10px] text-center mb-2 line-clamp-2 min-h-[28px] ${
                    achievement.isUnlocked ? 'text-text-muted' : 'text-white/20'
                  }`}>
                    {achievement.description}
                  </p>

                  {/* Unlocked Date or Rarity Badge */}
                  {achievement.isUnlocked ? (
                    <div className="text-[9px] text-center text-text-muted/60 font-mono">
                      {achievement.unlockedDate}
                    </div>
                  ) : (
                    <div className="flex justify-center">
                      <span className="text-[8px] uppercase px-2 py-0.5 rounded-full bg-white/5 text-white/30 font-bold tracking-wider">
                        Locked
                      </span>
                    </div>
                  )}
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </main>
  );
};