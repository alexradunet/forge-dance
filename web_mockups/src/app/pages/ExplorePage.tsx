import { useState } from 'react';
import { Header } from '@/app/components/organisms/Header';
import { ModuleCard } from '@/app/components/molecules/ModuleCard';
import { ModuleCardLarge } from '@/app/components/molecules/ModuleCardLarge';
import { ModuleCardMedium } from '@/app/components/molecules/ModuleCardMedium';
import { ModuleCardSmall } from '@/app/components/molecules/ModuleCardSmall';
import { Badge } from '@/app/components/atoms/Badge';
import { Icon } from '@/app/components/atoms/Icon';
import { motion, AnimatePresence } from 'motion/react';

interface ExplorePageProps {
  onNavigate?: (tab: string) => void;
}

interface Filters {
  difficulty: string[];
  style: string[];
  type: string[];
}

export const ExplorePage = ({ onNavigate }: ExplorePageProps) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [showFilterModal, setShowFilterModal] = useState(false);
  const [filters, setFilters] = useState<Filters>({
    difficulty: [],
    style: [],
    type: [],
  });

  const toggleFilter = (category: keyof Filters, value: string) => {
    setFilters(prev => ({
      ...prev,
      [category]: prev[category].includes(value)
        ? prev[category].filter(v => v !== value)
        : [...prev[category], value]
    }));
  };

  const clearAllFilters = () => {
    setFilters({
      difficulty: [],
      style: [],
      type: [],
    });
  };

  const getActiveFilterCount = () => {
    return filters.difficulty.length + filters.style.length + filters.type.length;
  };

  return (
    <main className="w-full flex-1 flex flex-col relative overflow-y-auto scrollbar-hide">
      <Header
        title="Explore"
        subtitle="Discover"
        onBack={() => onNavigate?.('home')}
        onMore={() => console.log('More')}
      />

      {/* Search Bar */}
      <div className="px-6 py-4">
        <div className="relative flex items-center bg-surface-dark border border-white/10 rounded-2xl px-4 py-3 shadow-lg focus-within:border-forge-fire/50 transition-colors">
          <Icon name="search" className="text-text-muted mr-3" />
          <input
            className="bg-transparent w-full text-sm text-white placeholder-text-muted/60 focus:outline-none font-medium"
            placeholder="Explore styles, mentors, moves..."
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
          <button 
            className="relative p-1 bg-white/5 rounded-lg ml-2 hover:bg-white/10 active:scale-95 transition-all"
            onClick={() => setShowFilterModal(true)}
          >
            <Icon name="tune" className="text-[20px] text-text-muted" />
            {getActiveFilterCount() > 0 && (
              <div className="absolute -top-1 -right-1 w-4 h-4 bg-forge-fire rounded-full flex items-center justify-center text-[10px] font-bold text-white">
                {getActiveFilterCount()}
              </div>
            )}
          </button>
        </div>
      </div>

      {/* Fundamentals Section */}
      <section className="mt-4">
        <div className="flex items-center gap-4 px-6 mb-4">
          <h2 className="font-title text-xl tracking-wider text-forge-fire whitespace-nowrap drop-shadow-sm">
            Fundamentals
          </h2>
          <div className="h-[1px] w-full bg-gradient-to-r from-forge-fire/40 to-transparent" />
        </div>
        <div className="flex overflow-x-auto px-6 pb-4 gap-4 scrollbar-hide snap-x snap-mandatory">
          <div onClick={() => onNavigate?.('lesson-path')} className="cursor-pointer transition-transform active:scale-95">
            <ModuleCardLarge
              title="Body Control I"
              category="Rhythm"
              categoryColor="primary"
              progress={25}
              lessons={{ completed: 2, total: 8 }}
              imageUrl="https://images.unsplash.com/photo-1550525811-e5869dd03032?w=400&auto=format&fit=crop&q=80"
            />
          </div>
          <div className="cursor-pointer transition-transform active:scale-95">
            <ModuleCardLarge
              title="Isolations Master"
              category="Tech"
              categoryColor="secondary"
              progress={0}
              lessons={{ completed: 0, total: 5 }}
              imageUrl="https://images.unsplash.com/photo-1547153760-18fc86324498?w=400&auto=format&fit=crop&q=80"
            />
          </div>
          <div className="cursor-pointer transition-transform active:scale-95">
            <ModuleCardLarge
              title="Floor Work Intro"
              category="Technique"
              categoryColor="success"
              progress={0}
              lessons={{ completed: 0, total: 6 }}
              imageUrl="https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&auto=format&fit=crop&q=80"
            />
          </div>
        </div>
      </section>

      {/* Street Styles Section */}
      <section className="mt-6">
        <div className="flex items-center gap-4 px-6 mb-4">
          <h2 className="font-title text-xl tracking-wider text-electric-blue whitespace-nowrap drop-shadow-sm">
            Street Styles
          </h2>
          <div className="h-[1px] w-full bg-gradient-to-r from-electric-blue/40 to-transparent" />
        </div>
        <div className="flex overflow-x-auto px-6 pb-4 gap-4 scrollbar-hide snap-x snap-mandatory">
          <ModuleCardSmall
            title="Top Rock Foundations"
            category="Breaking"
            categoryColor="info"
            progress={60}
            lessons={{ completed: 3, total: 5 }}
            imageUrl="https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=400&auto=format&fit=crop&q=80"
          />
          <ModuleCardSmall
            title="The Boogaloo Technique"
            category="Popping"
            categoryColor="secondary"
            progress={0}
            lessons={{ completed: 0, total: 4 }}
            imageUrl="https://images.unsplash.com/photo-1547153760-18fc86324498?w=400&auto=format&fit=crop&q=80"
          />
          <ModuleCardSmall
            title="House Footwork"
            category="House"
            categoryColor="success"
            progress={35}
            lessons={{ completed: 2, total: 6 }}
            imageUrl="https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=400&auto=format&fit=crop&q=80"
          />
          <ModuleCardSmall
            title="Locking Basics"
            category="Funk Styles"
            categoryColor="primary"
            progress={0}
            lessons={{ completed: 0, total: 5 }}
            imageUrl="https://images.unsplash.com/photo-1547481887-a26e2cacb2f2?w=400&auto=format&fit=crop&q=80"
          />
        </div>
      </section>

      {/* Choreography Section */}
      <section className="mt-6 mb-8">
        <div className="flex items-center gap-4 px-6 mb-4">
          <h2 className="font-title text-xl tracking-wider text-purple-500 whitespace-nowrap drop-shadow-sm">
            Choreography
          </h2>
          <div className="h-[1px] w-full bg-gradient-to-r from-purple-500/40 to-transparent" />
        </div>
        <div className="flex overflow-x-auto px-6 pb-4 gap-4 scrollbar-hide snap-x snap-mandatory">
          <ModuleCardLarge
            title="Urban Flow Vol. 4"
            category="New Arrival"
            categoryColor="secondary"
            progress={0}
            lessons={{ completed: 0, total: 8 }}
            imageUrl="https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=400&auto=format&fit=crop&q=80"
          />
          <ModuleCardLarge
            title="Contemporary Fusion"
            category="Advanced"
            categoryColor="success"
            progress={15}
            lessons={{ completed: 1, total: 7 }}
            imageUrl="https://images.unsplash.com/photo-1518834107812-67b0b7c58434?w=400&auto=format&fit=crop&q=80"
          />
          <ModuleCardLarge
            title="Hip-Hop Classics"
            category="Foundations"
            categoryColor="primary"
            progress={50}
            lessons={{ completed: 4, total: 8 }}
            imageUrl="https://images.unsplash.com/photo-1547153760-18fc9498041f?w=400&auto=format&fit=crop&q=80"
          />
        </div>
      </section>

      {/* Filter Modal */}
      <AnimatePresence>
        {showFilterModal && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowFilterModal(false)}
              className="fixed inset-0 bg-black/80 backdrop-blur-sm z-[60]"
            />

            {/* Filter Modal Content */}
            <motion.div
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 50 }}
              transition={{ type: 'spring', damping: 25, stiffness: 300 }}
              className="fixed bottom-0 left-0 right-0 z-[70] max-w-[500px] mx-auto"
            >
              <div className="bg-surface-card border-t border-white/10 rounded-t-3xl shadow-2xl max-h-[80vh] overflow-hidden flex flex-col">
                {/* Header */}
                <div className="px-6 py-4 border-b border-white/10 flex items-center justify-between">
                  <h3 className="font-title text-lg text-white tracking-wide">Filters</h3>
                  <button
                    onClick={() => setShowFilterModal(false)}
                    className="w-8 h-8 rounded-full bg-white/5 hover:bg-white/10 flex items-center justify-center transition-colors"
                  >
                    <Icon name="close" className="text-xl text-text-muted" />
                  </button>
                </div>

                {/* Filter Content */}
                <div className="flex-1 overflow-y-auto p-6 space-y-6">
                  {/* Difficulty Filter */}
                  <div>
                    <h4 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3">
                      Difficulty
                    </h4>
                    <div className="flex flex-wrap gap-2">
                      {['beginner', 'intermediate', 'advanced'].map((level) => {
                        const isSelected = filters.difficulty.includes(level);
                        return (
                          <motion.button
                            key={level}
                            onClick={() => toggleFilter('difficulty', level)}
                            whileTap={{ scale: 0.95 }}
                            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                              isSelected
                                ? 'bg-forge-fire text-white shadow-lg'
                                : 'bg-white/5 text-text-muted hover:bg-white/10 border border-white/10'
                            }`}
                          >
                            {level.charAt(0).toUpperCase() + level.slice(1)}
                          </motion.button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Style Filter */}
                  <div>
                    <h4 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3">
                      Style
                    </h4>
                    <div className="flex flex-wrap gap-2">
                      {['hip-hop', 'breaking', 'contemporary', 'freestyle', 'general'].map((style) => {
                        const isSelected = filters.style.includes(style);
                        return (
                          <motion.button
                            key={style}
                            onClick={() => toggleFilter('style', style)}
                            whileTap={{ scale: 0.95 }}
                            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                              isSelected
                                ? 'bg-electric-blue text-white shadow-lg'
                                : 'bg-white/5 text-text-muted hover:bg-white/10 border border-white/10'
                            }`}
                          >
                            {style.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
                          </motion.button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Type Filter */}
                  <div>
                    <h4 className="text-xs uppercase text-text-muted tracking-widest font-bold mb-3">
                      Type
                    </h4>
                    <div className="flex flex-wrap gap-2">
                      {['drill', 'dance-step', 'concept'].map((type) => {
                        const isSelected = filters.type.includes(type);
                        return (
                          <motion.button
                            key={type}
                            onClick={() => toggleFilter('type', type)}
                            whileTap={{ scale: 0.95 }}
                            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                              isSelected
                                ? 'bg-mystic-purple text-white shadow-lg'
                                : 'bg-white/5 text-text-muted hover:bg-white/10 border border-white/10'
                            }`}
                          >
                            {type.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
                          </motion.button>
                        );
                      })}
                    </div>
                  </div>
                </div>

                {/* Footer Actions */}
                <div className="px-6 py-4 border-t border-white/10 flex gap-3">
                  <button
                    onClick={() => {
                      clearAllFilters();
                      setShowFilterModal(false);
                    }}
                    className="flex-1 py-3 rounded-xl bg-white/5 text-text-muted hover:bg-white/10 transition-colors font-medium text-sm"
                  >
                    Clear All
                  </button>
                  <button
                    onClick={() => setShowFilterModal(false)}
                    className="flex-1 py-3 rounded-xl bg-forge-fire text-white hover:bg-forge-fire/90 transition-colors font-bold text-sm shadow-lg"
                  >
                    Apply Filters
                  </button>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </main>
  );
};