import { useState, useEffect, useRef } from 'react';
import { Icon } from '@/app/components/atoms/Icon';
import { Button } from '@/app/components/atoms/Button';
import { motion, AnimatePresence, useMotionValue, useTransform, animate, PanInfo } from 'motion/react';
import { BeatTapCard } from '@/app/components/organisms/BeatTapCard';
import { WorkoutIntroCard } from '@/app/components/organisms/WorkoutIntroCard';
import { SessionCompleteCard } from '@/app/components/organisms/SessionCompleteCard';
import { SwipeableCardScreen } from '@/app/components/templates/SwipeableCardScreen';
import { FloatingActionBar } from '@/app/components/molecules/FloatingActionBar';
import { cn } from '@/lib/utils';

interface TrainingSessionPageProps {
  onNavigate?: (tab: string) => void;
  onComplete?: () => void;
}

interface Exercise {
  id: string;
  name: string;
  type: 'warmup' | 'exercise' | 'cooldown';
  duration: number; // in seconds
  description: string;
  reps?: string;
  completed: boolean;
}

const mockExercises: Exercise[] = [
  {
    id: '1',
    name: 'Dynamic Stretching',
    type: 'warmup',
    duration: 300, // 5 min
    description: 'Warm up your muscles with dynamic movements',
    completed: false,
  },
  {
    id: '2',
    name: 'Hip Opener Flow',
    type: 'exercise',
    duration: 420, // 7 min
    description: 'Deep hip mobility sequence',
    reps: '3 sets',
    completed: false,
  },
  {
    id: '3',
    name: 'Core Stability',
    type: 'exercise',
    duration: 360, // 6 min
    description: 'Plank variations and core engagement',
    reps: '4 sets',
    completed: false,
  },
  {
    id: '4',
    name: 'Isolation Drills',
    type: 'exercise',
    duration: 480, // 8 min
    description: 'Body control and isolation techniques',
    reps: '2 sets',
    completed: false,
  },
  {
    id: '5',
    name: 'Cool Down Stretch',
    type: 'cooldown',
    duration: 240, // 4 min
    description: 'Gentle stretches to prevent soreness',
    completed: false,
  },
];

export function TrainingSessionPage({ onNavigate, onComplete }: TrainingSessionPageProps) {
  const [exercises, setExercises] = useState<Exercise[]>(mockExercises);
  const [currentExerciseIndex, setCurrentExerciseIndex] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [timeRemaining, setTimeRemaining] = useState(mockExercises[0].duration);
  const [showCompletion, setShowCompletion] = useState(false);
  const [hasStarted, setHasStarted] = useState(false);

  // Motion values for swipe gestures
  const x = useMotionValue(0);
  const containerRef = useRef<HTMLDivElement>(null);
  const screenWidth = typeof window !== 'undefined' ? window.innerWidth : 375;

  const currentExercise = exercises[currentExerciseIndex];
  
  // Timer logic
  useEffect(() => {
    let interval: NodeJS.Timeout;
    
    if (isPlaying && timeRemaining > 0) {
      interval = setInterval(() => {
        setTimeRemaining((prev) => {
          if (prev <= 1) {
            handleNextExercise();
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }

    return () => clearInterval(interval);
  }, [isPlaying, timeRemaining]);

  const handleNextExercise = () => {
    if (currentExerciseIndex < exercises.length - 1) {
      // Mark current as complete
      const updatedExercises = [...exercises];
      updatedExercises[currentExerciseIndex].completed = true;
      setExercises(updatedExercises);

      // Move to next
      setCurrentExerciseIndex(prev => prev + 1);
      setTimeRemaining(exercises[currentExerciseIndex + 1].duration);
      setIsPlaying(false);
      
      // Reset position immediately
      x.set(0);
    } else {
      // Complete
      setShowCompletion(true);
      setIsPlaying(false);
    }
  };

  const handlePreviousExercise = () => {
    if (currentExerciseIndex > 0) {
      setCurrentExerciseIndex(prev => prev - 1);
      setTimeRemaining(exercises[currentExerciseIndex - 1].duration);
      setIsPlaying(false);
      x.set(0);
    }
  };

  const handlePlayPause = () => {
    setIsPlaying(!isPlaying);
  };

  const handleDragEnd = async (event: MouseEvent | TouchEvent | PointerEvent, info: PanInfo) => {
    if (!hasStarted) return;
    
    const offset = info.offset.x;
    const velocity = info.velocity.x;
    const swipeThreshold = screenWidth * 0.25;

    if (offset < -swipeThreshold || velocity < -500) {
      // Swipe Left -> Next
      await animate(x, -screenWidth, { duration: 0.2, ease: "easeIn" });
      handleNextExercise();
    } else if ((offset > swipeThreshold || velocity > 500) && currentExerciseIndex > 0) {
      // Swipe Right -> Prev
      await animate(x, screenWidth, { duration: 0.2, ease: "easeIn" });
      handlePreviousExercise();
    } else {
      // Snap back to center
      animate(x, 0, { type: "spring", stiffness: 500, damping: 30 });
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  // Animation Transforms
  const prevX = useTransform(x, [0, screenWidth], [-50, 0]);
  const prevOpacity = useTransform(x, [0, screenWidth * 0.5], [0, 1]);
  const prevScale = useTransform(x, [0, screenWidth], [0.9, 1]);

  const currentOpacity = useTransform(x, [-screenWidth/2, 0, screenWidth/2], [0.5, 1, 0.5]);
  const currentRotate = useTransform(x, [-screenWidth, screenWidth], [-15, 15]);

  const nextX = useTransform(x, [-screenWidth, 0], [0, 50]);
  const nextOpacity = useTransform(x, [-screenWidth * 0.5, 0], [1, 0]);
  const nextScale = useTransform(x, [-screenWidth, 0], [1, 0.9]);

  // Determine which Action Zone Content to show
  let actionZoneContent;

  if (showCompletion) {
     actionZoneContent = (
        <FloatingActionBar>
             <button
                onClick={() => onNavigate?.('home')}
                className="w-full h-16 rounded-full bg-forge-fire text-white flex items-center justify-center gap-2 font-title text-xl tracking-wide shadow-[0_0_20px_rgba(255,77,0,0.4)] hover:shadow-[0_0_30px_rgba(255,77,0,0.6)] transition-all"
            >
                <Icon name="check" className="text-2xl" />
                COMPLETE
            </button>
        </FloatingActionBar>
     );
  } else if (!hasStarted) {
      actionZoneContent = (
        <FloatingActionBar>
            <button
                onClick={() => {
                    setHasStarted(true);
                    setIsPlaying(true);
                }}
                className="w-full h-16 rounded-full bg-forge-fire text-white flex items-center justify-center gap-2 font-title text-xl tracking-wide shadow-[0_0_20px_rgba(255,77,0,0.4)] hover:shadow-[0_0_30px_rgba(255,77,0,0.6)] transition-all"
            >
                <Icon name="play_arrow" className="text-2xl" />
                START WORKOUT
            </button>
        </FloatingActionBar>
      );
  } else {
      actionZoneContent = (
        <FloatingActionBar>
            <button
                onClick={handlePreviousExercise}
                disabled={currentExerciseIndex === 0}
                className="w-14 h-14 rounded-full bg-white/5 border border-white/10 flex items-center justify-center hover:bg-white/10 disabled:opacity-30 disabled:cursor-not-allowed transition-colors shrink-0"
            >
                <Icon name="skip_previous" className="text-white text-xl" />
            </button>

            <button
                onClick={handlePlayPause}
                className={cn(
                    "flex-1 h-16 rounded-full flex items-center justify-center transition-all border",
                    isPlaying 
                        ? "bg-white/5 border-white/10 text-white" 
                        : "bg-white text-black border-white hover:bg-white/90"
                )}
            >
                {isPlaying ? (
                    <span className="font-title text-3xl tabular-nums tracking-wide">
                        {formatTime(timeRemaining)}
                    </span>
                ) : (
                    <div className="flex items-center gap-2">
                        <Icon name="play_arrow" className="text-2xl" />
                        <span className="font-title text-xl tracking-wide">RESUME</span>
                    </div>
                )}
            </button>

            <button
                onClick={handleNextExercise}
                className="w-14 h-14 rounded-full bg-white/5 border border-white/10 flex items-center justify-center hover:bg-white/10 transition-colors shrink-0"
            >
                <Icon 
                    name={currentExerciseIndex === exercises.length - 1 ? "check" : "skip_next"} 
                    className="text-white text-xl" 
                />
            </button>
        </FloatingActionBar>
      );
  }

  return (
    <SwipeableCardScreen
        title="DAILY PRACTICE"
        subtitle={showCompletion ? "Completed" : (hasStarted ? exercises[currentExerciseIndex].name : "Today's WOD")}
        headerRight={
            <div className="w-10 h-10 rounded-full bg-surface-dark border border-white/10 flex items-center justify-center">
                <Icon name="more_vert" className="text-white text-[20px]" />
            </div>
        }
        progressSteps={exercises.length}
        currentStep={showCompletion ? exercises.length : currentExerciseIndex}
        actionZone={actionZoneContent}
    >
        <div className="relative w-full h-full max-w-md mx-auto" ref={containerRef}>
            <AnimatePresence mode="wait">
                {showCompletion ? (
                    /* Completion State */
                    <motion.div
                        key="completion"
                        className="absolute inset-0 w-full h-full z-20"
                        initial={{ opacity: 0, scale: 0.9 }}
                        animate={{ opacity: 1, scale: 1 }}
                        exit={{ opacity: 0 }}
                        transition={{ duration: 0.4 }}
                    >
                         <SessionCompleteCard 
                            stats={[
                                { label: "Time", value: "25:00", icon: "timer" },
                                { label: "Exercises", value: `${exercises.length}`, icon: "fitness_center" },
                                { label: "XP Gained", value: "+350", icon: "bolt" }
                            ]}
                         />
                    </motion.div>
                ) : !hasStarted ? (
                    /* Preview Card (Start State) */
                    <motion.div
                        key="preview"
                        className="absolute inset-0 w-full h-full z-20"
                        exit={{ opacity: 0, scale: 0.9 }}
                        transition={{ duration: 0.3 }}
                    >
                        <WorkoutIntroCard 
                            title="Body Control"
                            duration="25 min"
                            intensity="Medium"
                            description="Master your movement with this fundamental sequence designed to improve awareness and stability."
                        />
                    </motion.div>
                ) : (
                    /* Active Deck Stack */
                    <motion.div 
                        key="active-deck"
                        className="absolute inset-0 w-full h-full"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                    >
                        {/* Next Card (Right/Behind) */}
                        {currentExerciseIndex < exercises.length - 1 && (
                            <motion.div
                                key="next"
                                className="absolute inset-0 w-full h-full pointer-events-none"
                                style={{
                                    x: nextX,
                                    opacity: nextOpacity,
                                    scale: nextScale,
                                    zIndex: 0
                                }}
                            >
                                <BeatTapCard />
                            </motion.div>
                        )}

                        {/* Previous Card (Left/Behind) */}
                        {currentExerciseIndex > 0 && (
                            <motion.div
                                key="prev"
                                className="absolute inset-0 w-full h-full pointer-events-none"
                                style={{
                                    x: prevX,
                                    opacity: prevOpacity,
                                    scale: prevScale,
                                    zIndex: 0
                                }}
                            >
                                <BeatTapCard />
                            </motion.div>
                        )}

                        {/* Current Card (Center - Draggable) */}
                        <motion.div
                            key={currentExercise.id}
                            className="absolute inset-0 w-full h-full cursor-grab active:cursor-grabbing z-10"
                            style={{ 
                                x,
                                    opacity: currentOpacity,
                                    rotate: currentRotate
                            }}
                            drag="x"
                            dragConstraints={{ left: -screenWidth, right: screenWidth }}
                            dragElastic={0.05}
                            dragMomentum={false}
                            onDragEnd={handleDragEnd}
                        >
                            <BeatTapCard />
                        </motion.div>
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    </SwipeableCardScreen>
  );
}
