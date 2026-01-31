import { useState } from 'react';
import { Icon } from '@/app/components/atoms/Icon';
import { GenericCard } from '@/app/components/organisms/GenericCard';
import { BeatTapCard } from '@/app/components/organisms/BeatTapCard';
import { TheoryCard } from '@/app/components/organisms/TheoryCard';
import { MovementCard } from '@/app/components/organisms/MovementCard';
import { ExperimentCard } from '@/app/components/organisms/ExperimentCard';
import { motion, useMotionValue, useTransform, animate, AnimatePresence } from 'motion/react';
import { SwipeableCardScreen } from '@/app/components/templates/SwipeableCardScreen';
import { FloatingActionBar } from '@/app/components/molecules/FloatingActionBar';

interface InteractiveCardsPageProps {
  onNavigate?: (tab: string) => void;
}

type CardType = 'generic' | 'beat' | 'theory' | 'movement' | 'experiment';

export function InteractiveCardsPage({ onNavigate }: InteractiveCardsPageProps) {
  // Carousel view only - grid view removed
  const [activeCard, setActiveCard] = useState<CardType>('generic');
  const [favoritedCards, setFavoritedCards] = useState<Set<CardType>>(new Set());
  const x = useMotionValue(0);

  // 5 Progress segments as requested.
  // Sequence: Generic (0) -> Beat (1) -> Theory (2) -> Movement (3) -> Experiment (4)
  const steps: CardType[] = ['generic', 'beat', 'theory', 'movement', 'experiment']; 
  const activeIndex = steps.indexOf(activeCard);
  
  const handleNext = () => {
    const nextIdx = (activeIndex + 1) % steps.length;
    setActiveCard(steps[nextIdx]);
  };

  const handlePrev = () => {
    const prevIdx = (activeIndex - 1 + steps.length) % steps.length;
    setActiveCard(steps[prevIdx]);
  };

  const handleToggleFavorite = (cardType: CardType) => {
    setFavoritedCards(prev => {
      const newSet = new Set(prev);
      if (newSet.has(cardType)) {
        newSet.delete(cardType);
      } else {
        newSet.add(cardType);
      }
      return newSet;
    });
  };

  const handleDragEnd = () => {
    const currentX = x.get();
    const threshold = 100;

    if (currentX < -threshold) {
      // Swiped left - go to next
      handleNext();
      animate(x, 0, { duration: 0 });
    } else if (currentX > threshold) {
      // Swiped right - go to previous
      handlePrev();
      animate(x, 0, { duration: 0 });
    } else {
      // Snap back to center
      animate(x, 0, { type: "spring", stiffness: 300, damping: 30 });
    }
  };

  const cardComponents = {
    generic: GenericCard,
    beat: BeatTapCard,
    theory: TheoryCard,
    movement: MovementCard,
    experiment: ExperimentCard,
  };

  const getPrevIndex = () => (activeIndex - 1 + steps.length) % steps.length;
  const getNextIndex = () => (activeIndex + 1) % steps.length;

  const CurrentCard = cardComponents[activeCard];
  const PrevCard = cardComponents[steps[getPrevIndex()]];
  const NextCard = cardComponents[steps[getNextIndex()]];

  const handleBack = () => {
    onNavigate?.('learn');
  };

  // Animation Transforms (Must be at top level, not inside JSX)
  // Previous Card
  const prevX = useTransform(x, [0, 300], [-60, 0]);
  const prevOpacity = useTransform(x, [50, 150], [0, 0.6]);
  const prevScale = useTransform(x, [0, 300], [0.85, 0.95]);

  // Current Card
  const currentOpacity = useTransform(x, [-150, -50, 50, 150], [0.6, 1, 1, 0.6]);

  // Next Card
  const nextX = useTransform(x, [-300, 0], [0, 60]);
  const nextOpacity = useTransform(x, [-150, -50], [0.6, 0]);
  const nextScale = useTransform(x, [-300, 0], [0.95, 0.85]);

  return (
    <SwipeableCardScreen
        title="Interactive Deck"
        subtitle="Atomic Design System"
        headerLeft={
            <button 
                onClick={handleBack}
                className="w-10 h-10 rounded-full bg-surface-dark border border-white/10 flex items-center justify-center hover:bg-white/10 transition-colors"
            >
                <Icon name="arrow_back" className="text-white text-[20px]" />
            </button>
        }
        progressSteps={steps.length}
        currentStep={activeIndex}
        actionZone={
            <FloatingActionBar>
                <button className="flex flex-col items-center justify-center gap-1 text-white/70 hover:text-white transition-colors">
                    <Icon name="favorite_border" className="text-2xl" />
                    <span className="text-[10px] uppercase tracking-wider">Save</span>
                </button>
                <button className="flex flex-col items-center justify-center gap-1 text-white/70 hover:text-white transition-colors">
                    <Icon name="share" className="text-2xl" />
                    <span className="text-[10px] uppercase tracking-wider">Share</span>
                </button>
                <div className="w-px h-8 bg-white/10" />
                <button className="flex flex-col items-center justify-center gap-1 text-white/70 hover:text-white transition-colors">
                    <Icon name="add_circle_outline" className="text-2xl" />
                    <span className="text-[10px] uppercase tracking-wider">Add</span>
                </button>
            </FloatingActionBar>
        }
    >
        <div className="relative w-full h-full max-w-md mx-auto">
            {/* Previous Card (Left) */}
            <motion.div
                className="absolute inset-0 w-full h-full pointer-events-none"
                style={{
                x: prevX,
                opacity: prevOpacity,
                scale: prevScale,
                }}
            >
                <PrevCard 
                onNext={handleNext} 
                isFavorited={favoritedCards.has(steps[getPrevIndex()])}
                onToggleFavorite={() => handleToggleFavorite(steps[getPrevIndex()])}
                />
            </motion.div>

            {/* Current Card (Center) - Draggable */}
            <motion.div
                className="absolute inset-0 w-full h-full cursor-grab active:cursor-grabbing z-10"
                style={{ 
                x,
                opacity: currentOpacity,
                }}
                drag="x"
                dragConstraints={{ left: -300, right: 300 }}
                dragElastic={0.2}
                onDragEnd={handleDragEnd}
            >
                <CurrentCard 
                onNext={handleNext} 
                isFavorited={favoritedCards.has(activeCard)}
                onToggleFavorite={() => handleToggleFavorite(activeCard)}
                />
            </motion.div>

            {/* Next Card (Right) */}
            <motion.div
                className="absolute inset-0 w-full h-full pointer-events-none"
                style={{
                x: nextX,
                opacity: nextOpacity,
                scale: nextScale,
                }}
            >
                <NextCard 
                onNext={handleNext} 
                isFavorited={favoritedCards.has(steps[getNextIndex()])}
                onToggleFavorite={() => handleToggleFavorite(steps[getNextIndex()])}
                />
            </motion.div>
        </div>
    </SwipeableCardScreen>
  );
}
