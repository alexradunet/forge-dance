import { ReactNode } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { cn } from '@/lib/utils';
import { Header } from '@/app/components/organisms/Header';

interface SwipeableCardScreenProps {
  title: string;
  subtitle?: string;
  headerLeft?: ReactNode;
  headerRight?: ReactNode;
  progressSteps?: number;
  currentStep?: number;
  onStepClick?: (index: number) => void;
  children: ReactNode;
  actionZone?: ReactNode;
  className?: string;
}

export function SwipeableCardScreen({
  title,
  subtitle,
  headerLeft,
  headerRight,
  progressSteps = 0,
  currentStep = 0,
  children,
  actionZone,
  className
}: SwipeableCardScreenProps) {
  return (
    <main className={cn("absolute inset-0 w-full h-full flex flex-col z-10 overflow-hidden bg-neutral-900", className)}>
      {/* Header */}
      <Header 
        title={title}
        subtitle={subtitle}
        leftSlot={headerLeft}
        rightSlot={headerRight}
      />

      {/* Progress Segments */}
      {progressSteps > 0 && (
        <div className="w-full px-6 py-2 flex gap-1 z-20 shrink-0 bg-black/20 backdrop-blur-sm border-b border-white/5">
          {Array.from({ length: progressSteps }).map((_, i) => (
            <div 
              key={i} 
              className={cn(
                "h-1 rounded-full flex-1 transition-all duration-500",
                i === currentStep 
                  ? "bg-forge-orange shadow-[0_0_10px_rgba(255,77,0,0.5)]" 
                  : i < currentStep 
                    ? "bg-white/40" 
                    : "bg-white/10"
              )}
            />
          ))}
        </div>
      )}

      {/* Main Content / Deck Area */}
      {/* Takes available space. Flex column to center content if needed */}
      <div className="flex-1 relative w-full min-h-0 flex flex-col">
        <div className="flex-1 w-full max-w-md m-[0px] px-6 py-6 relative mx-[22px] my-[0px]">
            {children}
        </div>
      </div>

      {/* Action Zone - Flex item (not absolute) to prevent overlap */}
      <AnimatePresence>
        {actionZone && (
          <motion.div 
            initial={{ height: 0, opacity: 0, y: 20 }}
            animate={{ height: 'auto', opacity: 1, y: 0 }}
            exit={{ height: 0, opacity: 0, y: 20 }}
            transition={{ type: "spring", duration: 0.4, bounce: 0 }}
            className="w-full z-30 shrink-0"
          >
            {/* Constrain action zone to match content width */}
            <div className="w-full max-w-md mx-auto px-6">
                {actionZone}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
      
      {/* Spacer for Bottom Navigation (approx 80px) */}
      <div className="h-[90px] w-full shrink-0" />
    </main>
  );
}
