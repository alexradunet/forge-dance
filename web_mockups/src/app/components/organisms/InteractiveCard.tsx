import { ReactNode, useState } from 'react';
import { cn } from '@/lib/utils';
import { motion, AnimatePresence } from 'motion/react';
import { Icon } from '@/app/components/atoms/Icon';

interface InteractiveCardProps {
  title: string;
  category?: string;
  level?: string;
  backgroundImage: string;
  topRightSlot?: ReactNode;
  topLeftSlot?: ReactNode;
  tags?: string[];
  children?: ReactNode; // For the bottom detail section
  backContent?: ReactNode; // Content for the back of the card
  className?: string;
}

export function InteractiveCard({
  title,
  category,
  level,
  backgroundImage,
  topRightSlot,
  topLeftSlot,
  tags = [],
  children,
  backContent,
  className
}: InteractiveCardProps) {
  const [isFlipped, setIsFlipped] = useState(false);

  const handleFlip = () => {
    if (backContent) {
      setIsFlipped(!isFlipped);
    }
  };

  return (
    <div className={cn("relative w-full h-full z-20 perspective-1000", className)}>
      <motion.div
        initial={false}
        animate={{ rotateY: isFlipped ? 180 : 0 }}
        transition={{ duration: 0.6, type: "spring", stiffness: 260, damping: 20 }}
        className="relative w-full h-full transform-style-3d"
      >
        {/* Front Face */}
        <div className="absolute inset-0 backface-hidden w-full h-full bg-surface-card rounded-2xl border-2 border-primary/50 shadow-[0_0_20px_-2px_rgba(242,74,13,0.6)] overflow-hidden flex flex-col">
          {/* Background Image Layer */}
          <div className="absolute inset-0 bg-black">
             <div 
               className="w-full h-full bg-cover bg-center opacity-90 transition-transform duration-700 hover:scale-105"
               style={{ backgroundImage: `url(${backgroundImage})` }}
             />
             <div className="absolute inset-0 bg-gradient-to-t from-bg-deep via-transparent to-black/30" />
          </div>

          {/* Top Actions */}
          <div className="relative z-10 p-4 flex justify-between items-start">
            <div className="flex gap-2">
              {topLeftSlot}
            </div>
            <div className="flex gap-2">
              {topRightSlot}
              {backContent && (
                <button 
                  onClick={handleFlip}
                  className="flex items-center justify-center w-10 h-10 rounded-full bg-black/40 hover:bg-black/60 backdrop-blur-md border border-white/20 text-white transition-all active:scale-95"
                >
                  <Icon name="flip_camera_android" className="text-xl" />
                </button>
              )}
            </div>
          </div>

          {/* Spacer */}
          <div className="flex-1" />

          {/* Main Content Info */}
          <div className="relative z-10 px-5 pb-4 pointer-events-none">
            <div className="flex items-center gap-2 mb-2 pointer-events-auto">
              {tags.map((tag, i) => (
                <span 
                  key={i} 
                  className={cn(
                    "text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wider shadow-sm",
                    i === 0 ? "bg-primary/90 text-white" : "bg-white/20 text-white backdrop-blur-sm border border-white/10"
                  )}
                >
                  {tag}
                </span>
              ))}
              {level && (
                 <span className="bg-white/20 text-white text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wider backdrop-blur-sm border border-white/10">
                   {level}
                 </span>
              )}
            </div>
            <h1 className="font-title text-6xl text-white tracking-wide drop-shadow-lg leading-none">
              {title}
            </h1>
          </div>

          {/* Bottom Detail Section (Footer) */}
          <div className="relative z-20 bg-white/10 dark:bg-black/60 backdrop-blur-md border-t border-white/10 p-5 min-h-[28%] flex flex-col justify-center">
            {children}
          </div>
        </div>

        {/* Back Face */}
        {backContent && (
          <div 
            className="absolute inset-0 backface-hidden w-full h-full bg-surface-card rounded-2xl border-2 border-primary/50 shadow-glow-active overflow-hidden rotate-y-180"
          >
            <div className="h-full flex flex-col">
              <div className="p-4 flex justify-end">
                 <button 
                  onClick={handleFlip}
                  className="flex items-center justify-center w-10 h-10 rounded-full bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-white transition-all active:scale-95"
                >
                  <Icon name="flip_camera_android" className="text-xl" />
                </button>
              </div>
              <div className="flex-1 p-6 overflow-y-auto">
                {backContent}
              </div>
            </div>
          </div>
        )}
      </motion.div>
    </div>
  );
}
