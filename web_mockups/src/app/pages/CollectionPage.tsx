import { useState } from 'react';
import { Icon } from '@/app/components/atoms/Icon';
import { GenericCard } from '@/app/components/organisms/GenericCard';
import { BeatTapCard } from '@/app/components/organisms/BeatTapCard';
import { TheoryCard } from '@/app/components/organisms/TheoryCard';
import { MovementCard } from '@/app/components/organisms/MovementCard';
import { ExperimentCard } from '@/app/components/organisms/ExperimentCard';
import { SwipeableCardScreen } from '@/app/components/templates/SwipeableCardScreen';
import { FloatingActionBar } from '@/app/components/molecules/FloatingActionBar';
import { motion, AnimatePresence } from 'motion/react';
import { cn } from '@/lib/utils';

interface CollectionPageProps {
  onNavigate?: (tab: string) => void;
}

type CardType = 'generic' | 'beat' | 'theory' | 'movement' | 'experiment';
type CategoryType = 'cards' | 'modules' | 'lessons';

// Mock data
const favoritedCards: Array<{ 
  type: CardType; 
  module: string; 
  lesson: string; 
  category: CategoryType;
  difficulty: string;
}> = [
  { type: 'generic', module: 'Hip Hop Basics', lesson: 'Lesson 1', category: 'cards', difficulty: 'beginner' },
  { type: 'beat', module: 'Rhythm Training', lesson: 'Lesson 2', category: 'modules', difficulty: 'intermediate' },
  { type: 'theory', module: 'Dance History', lesson: 'Lesson 3', category: 'lessons', difficulty: 'beginner' },
  { type: 'movement', module: 'Core Flow', lesson: 'Lesson 4', category: 'cards', difficulty: 'advanced' },
  { type: 'experiment', module: 'Freestyle', lesson: 'Lesson 5', category: 'modules', difficulty: 'intermediate' },
  { type: 'generic', module: 'Breaking Basics', lesson: 'Lesson 6', category: 'lessons', difficulty: 'beginner' },
  { type: 'beat', module: 'Beat Patterns', lesson: 'Lesson 7', category: 'cards', difficulty: 'advanced' },
  { type: 'movement', module: 'Footwork Flow', lesson: 'Lesson 8', category: 'modules', difficulty: 'intermediate' },
];

export function CollectionPage({ onNavigate }: CollectionPageProps) {
  const [selectedCard, setSelectedCard] = useState<CardType | null>(null);
  const [activeCategory, setActiveCategory] = useState<CategoryType | 'all'>('cards');
  const [isSearchActive, setIsSearchActive] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  const cardComponents = {
    generic: GenericCard,
    beat: BeatTapCard,
    theory: TheoryCard,
    movement: MovementCard,
    experiment: ExperimentCard,
  };

  const handleCardClick = (cardType: CardType) => {
    setSelectedCard(cardType);
  };

  const handleCloseModal = () => {
    setSelectedCard(null);
  };

  const SelectedCardComponent = selectedCard ? cardComponents[selectedCard] : null;

  // Filter Logic
  const filteredCards = favoritedCards.filter(card => {
    // Category Filter
    if (activeCategory !== 'all' && activeCategory !== 'cards') {
        // For now treating everything as cards, but simulated logic:
        if (card.category !== activeCategory) return false;
    }

    // Search Filter
    if (searchQuery.trim() !== '') {
        const query = searchQuery.toLowerCase();
        return (
            card.module.toLowerCase().includes(query) || 
            card.lesson.toLowerCase().includes(query)
        );
    }

    return true;
  });

  return (
    <SwipeableCardScreen
        title="YOUR COLLECTION"
        subtitle="Library"
        actionZone={
            <div className="flex flex-col gap-3">
                 {/* Search Input (Expandable) */}
                 <AnimatePresence>
                    {isSearchActive && (
                        <motion.div
                            initial={{ height: 0, opacity: 0, marginBottom: 0 }}
                            animate={{ height: 'auto', opacity: 1, marginBottom: 12 }}
                            exit={{ height: 0, opacity: 0, marginBottom: 0 }}
                            className="overflow-hidden"
                        >
                            <div className="flex items-center bg-white/10 border border-white/10 rounded-xl px-4 py-3">
                                <Icon name="search" className="text-text-muted mr-3" />
                                <input
                                    autoFocus
                                    className="bg-transparent w-full text-sm text-white placeholder-text-muted/60 focus:outline-none font-medium"
                                    placeholder="Search..."
                                    type="text"
                                    value={searchQuery}
                                    onChange={(e) => setSearchQuery(e.target.value)}
                                />
                                <button 
                                    onClick={() => {
                                        setSearchQuery('');
                                        setIsSearchActive(false);
                                    }}
                                    className="p-1 hover:bg-white/10 rounded-full"
                                >
                                    <Icon name="close" className="text-white/60 text-lg" />
                                </button>
                            </div>
                        </motion.div>
                    )}
                 </AnimatePresence>

                 {/* Main Controls */}
                 <FloatingActionBar>
                    <button 
                        onClick={() => setIsSearchActive(!isSearchActive)}
                        className={cn(
                            "w-12 h-12 rounded-full flex items-center justify-center transition-colors shrink-0",
                            isSearchActive ? "bg-white text-black" : "bg-white/5 text-white hover:bg-white/10"
                        )}
                    >
                        <Icon name="search" className="text-xl" />
                    </button>

                    <div className="h-8 w-[1px] bg-white/10 mx-1" />

                    <div className="flex-1 flex bg-white/5 rounded-full p-1 border border-white/5 relative">
                         {/* Animated Background Indicator */}
                         <div className="absolute inset-1 flex">
                            <motion.div 
                                className="bg-white/10 rounded-full h-full shadow-sm border border-white/5"
                                layoutId="activeTab"
                                transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                                style={{
                                    width: '33.33%',
                                    x: activeCategory === 'cards' ? '0%' : activeCategory === 'modules' ? '100%' : '200%'
                                }}
                            />
                         </div>

                        {(['cards', 'modules', 'lessons'] as const).map((cat) => (
                            <button
                                key={cat}
                                onClick={() => setActiveCategory(cat)}
                                className={cn(
                                    "flex-1 relative z-10 flex items-center justify-center text-xs font-bold uppercase tracking-wide transition-colors h-10 rounded-full",
                                    activeCategory === cat ? "text-white" : "text-white/50 hover:text-white/80"
                                )}
                            >
                                {cat}
                            </button>
                        ))}
                    </div>
                </FloatingActionBar>
            </div>
        }
    >
        {/* Grid Content */}
        {/* Added no-scrollbar utility to ensure width calculations are exact */}
        <div className="w-full h-full overflow-y-auto pb-[128px] -mx-6 px-6 scroll-smooth [scrollbar-width:none] [&::-webkit-scrollbar]:hidden pt-[0px] pr-[0px] pl-[24px]">
            {filteredCards.length === 0 ? (
                <div className="flex flex-col items-center justify-center pt-20 text-center px-8 opacity-50">
                    <Icon name="grid_view" className="text-6xl mb-4" />
                    <p className="text-sm">No items found</p>
                </div>
            ) : (
                <div className="flex flex-wrap gap-4 w-full justify-between">
                    {filteredCards.map((card, index) => {
                        const Component = cardComponents[card.type];
                        return (
                            <motion.div
                                key={`${card.type}-${index}`}
                                initial={{ opacity: 0, scale: 0.9 }}
                                animate={{ opacity: 1, scale: 1 }}
                                transition={{ delay: index * 0.05 }}
                                // Card width calculation: (100% - gap) / 2
                                className="h-[200px] w-[calc(50%-8px)] rounded-2xl overflow-hidden border border-white/10 relative group cursor-pointer"
                                onClick={() => handleCardClick(card.type)}
                            >
                                <Component mode="mini" />
                                {/* Hover Effect Overlay */}
                                <div className="absolute inset-0 bg-white/0 group-hover:bg-white/5 transition-colors pointer-events-none" />
                            </motion.div>
                        );
                    })}
                </div>
            )}
        </div>

        {/* Full Card Overlay */}
        <AnimatePresence>
            {selectedCard && SelectedCardComponent && (
                <motion.div
                    layoutId={`card-${selectedCard}`}
                    initial={{ opacity: 0, scale: 0.95, y: 10 }}
                    animate={{ opacity: 1, scale: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.95, y: 10 }}
                    transition={{ type: 'spring', damping: 25, stiffness: 300 }}
                    // Use inset-6 to respect parent padding (24px)
                    className="absolute inset-6 z-20 rounded-[24px] overflow-hidden shadow-2xl bg-[#0a0a0a]"
                >
                     <div className="w-full h-full">
                         <SelectedCardComponent 
                            onClose={handleCloseModal} 
                            onNext={handleCloseModal}
                        />
                     </div>
                </motion.div>
            )}
        </AnimatePresence>

    </SwipeableCardScreen>
  );
}
