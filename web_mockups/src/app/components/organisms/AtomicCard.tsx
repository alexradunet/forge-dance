import { ReactNode, useState } from 'react';
import { cn } from '@/lib/utils';
import { Icon } from '@/app/components/atoms/Icon';
import { motion } from 'motion/react';

interface AtomicCardProps {
  variant?: 'generic' | 'theory' | 'beat' | 'movement' | 'experiment';
  title: ReactNode;
  subtitle?: string;
  media: ReactNode;
  footer: ReactNode;
  actionLabel?: string;
  onAction?: () => void;
  onFlip?: () => void;
  interactiveLabel?: string;
  className?: string;
  // Back side content
  backTitle?: ReactNode;
  backSubtitle?: string;
  backContent?: ReactNode;
  backFooter?: ReactNode;
  // Favorite functionality
  isFavorited?: boolean;
  onToggleFavorite?: () => void;
  // Close functionality (for collection popup mode)
  onClose?: () => void;
  // Video playback state
  isVideoPlaying?: boolean;
}

export function AtomicCard({
  variant = 'generic',
  title,
  subtitle,
  media,
  footer,
  actionLabel,
  onAction,
  onFlip,
  interactiveLabel = 'Interactive: Reverse',
  className,
  backTitle,
  backSubtitle,
  backContent,
  backFooter,
  isFavorited = false,
  onToggleFavorite,
  onClose,
  isVideoPlaying = false
}: AtomicCardProps) {
  const [isFlipped, setIsFlipped] = useState(false);

  const handleFlip = () => {
    setIsFlipped(!isFlipped);
    onFlip?.();
  };

  const handleFavoriteClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    onToggleFavorite?.();
  };

  const handleCloseClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    onClose?.();
  };

  return (
    <div className={cn("relative w-full h-full flex flex-col", className)}>
      <div className="relative w-full h-full z-20 group flex-1" style={{ perspective: '1000px' }}>
        {/* Flip Container */}
        <motion.div
          className="relative w-full h-full"
          style={{ transformStyle: 'preserve-3d' }}
          animate={{ rotateY: isFlipped ? 180 : 0 }}
          transition={{ duration: 0.6, ease: 'easeInOut' }}
        >
          {/* FRONT SIDE */}
          <div 
            className="absolute inset-0 w-full h-full"
            style={{ 
              backfaceVisibility: 'hidden',
              WebkitBackfaceVisibility: 'hidden'
            }}
          >
            <div className="relative w-full h-full bg-[#121212] rounded-[24px] border border-white/10 overflow-hidden flex flex-col ring-1 ring-white/5 shadow-lg">
              
              {/* Main Content Area (Flex Grow) */}
              <div className="relative flex-1 w-full overflow-hidden bg-neutral-900">
                {/* Media Layer */}
                <div className="absolute inset-0 w-full h-full">
                    {media}
                    
                    {/* Overlay Gradient */}
                    <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-transparent to-black/90 pointer-events-none" />
                    
                    {/* Tech Pattern Overlay */}
                    <div className="absolute inset-0 opacity-20 pointer-events-none" style={{ backgroundImage: 'radial-gradient(circle, #444 1px, transparent 1px)', backgroundSize: '16px 16px' }} />
                </div>

                {/* Title Layer (Centered) */}
                <div 
                    className={cn(
                    "absolute inset-0 flex flex-col items-center justify-center pointer-events-none z-20 px-8 transition-opacity duration-500",
                    isVideoPlaying ? "opacity-0" : "opacity-100"
                    )}
                >
                    <div className="w-full relative">
                    {subtitle && (
                        <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-black/60 backdrop-blur-sm px-2 text-[9px] font-mono text-forge-orange border border-forge-orange/30 rounded mb-2 whitespace-nowrap">
                            {subtitle}
                        </div>
                    )}
                    <div className="font-title text-[3.5rem] leading-[0.9] text-center text-transparent bg-clip-text bg-gradient-to-b from-white via-white to-white/60 drop-shadow-lg tracking-wide opacity-90">
                        {title}
                    </div>
                    </div>
                </div>

                {/* Flip / Interactive Button - Lower Right Corner (Positioned relative to this container) */}
                {onFlip && (
                    <button 
                    onClick={handleFlip}
                    className="absolute bottom-4 right-4 z-30 w-12 h-12 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-all hover:border-forge-orange/50 active:scale-95 group/btn shadow-lg"
                    >
                    <Icon name="replay" className="text-[22px] group-hover/btn:rotate-180 transition-transform duration-500" />
                    </button>
                )}

                {/* Upper Right Corner Button - Favorite (lesson mode) or Close (collection mode) */}
                {onClose ? (
                    <button 
                    onClick={handleCloseClick}
                    className="absolute top-4 right-4 z-30 w-12 h-12 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-all hover:border-forge-fire/50 active:scale-95 group/close shadow-lg"
                    >
                    <Icon name="close" className="text-[22px] group-hover/close:scale-110 transition-transform duration-500" />
                    </button>
                ) : onToggleFavorite ? (
                    <button 
                    onClick={handleFavoriteClick}
                    className="absolute top-4 right-4 z-30 w-12 h-12 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-all hover:border-forge-fire/50 active:scale-95 group/fav shadow-lg"
                    >
                    <Icon 
                        name={isFavorited ? "favorite" : "favorite_border"} 
                        className={cn(
                        "text-[22px] transition-all",
                        isFavorited ? "text-forge-fire scale-110" : "text-white group-hover/fav:text-forge-fire"
                        )} 
                    />
                    </button>
                ) : null}
              </div>

              {/* Footer Strip (Fixed Height, Non-overlapping) */}
              <div className="shrink-0 z-30 bg-[#0f0f0f]/60 backdrop-blur-xl border-t border-white/10 pt-4 pb-6 px-4">
                {footer}
              </div>
            </div>
          </div>

          {/* BACK SIDE */}
          <div 
            className="absolute inset-0 w-full h-full"
            style={{ 
              backfaceVisibility: 'hidden',
              WebkitBackfaceVisibility: 'hidden',
              transform: 'rotateY(180deg)'
            }}
          >
            <div className="relative w-full h-full bg-[#121212] rounded-[24px] border border-white/10 overflow-hidden flex flex-col ring-1 ring-white/5 shadow-lg">
              {/* Back Background */}
              <div className="absolute inset-0 bg-gradient-to-br from-neutral-900 via-neutral-800 to-neutral-900 pointer-events-none">
                {/* Tech Grid Pattern */}
                <div className="absolute inset-0 opacity-10" style={{ backgroundImage: 'linear-gradient(#fff 1px, transparent 1px), linear-gradient(90deg, #fff 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
                
                {/* Radial Overlay */}
                <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-transparent to-black/90" />
              </div>

              {/* Flip Button (Back Side) */}
              <button 
                onClick={handleFlip}
                className="absolute bottom-[90px] right-4 z-30 w-12 h-12 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-all hover:border-forge-orange/50 active:scale-95 group/btn shadow-lg"
              >
                <Icon name="replay" className="text-[22px] group-hover/btn:rotate-180 transition-transform duration-500" />
              </button>

               {/* Upper Right Corner Button (Back Side) */}
               {onClose ? (
                <button 
                  onClick={handleCloseClick}
                  className="absolute top-4 right-4 z-30 w-12 h-12 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-all hover:border-forge-fire/50 active:scale-95 group/close shadow-lg"
                >
                  <Icon name="close" className="text-[22px] group-hover/close:scale-110 transition-transform duration-500" />
                </button>
              ) : onToggleFavorite ? (
                <button 
                  onClick={handleFavoriteClick}
                  className="absolute top-4 right-4 z-30 w-12 h-12 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition-all hover:border-forge-fire/50 active:scale-95 group/fav shadow-lg"
                >
                  <Icon 
                    name={isFavorited ? "favorite" : "favorite_border"} 
                    className={cn(
                      "text-[22px] transition-all",
                      isFavorited ? "text-forge-fire scale-110" : "text-white group-hover/fav:text-forge-fire"
                    )} 
                  />
                </button>
              ) : null}

              {/* Back Title Area (Flex Shrink) */}
              <div className="shrink-0 pt-8 px-8 z-20 pb-4">
                {backSubtitle && (
                  <div className="text-center mb-2">
                    <span className="bg-black/60 backdrop-blur-sm px-2 py-1 text-[9px] font-mono text-forge-orange border border-forge-orange/30 rounded">
                      {backSubtitle}
                    </span>
                  </div>
                )}
                {backTitle && (
                  <div className="font-title text-[2.5rem] leading-[0.9] text-center text-transparent bg-clip-text bg-gradient-to-b from-white via-white to-white/60 drop-shadow-lg tracking-wide">
                    {backTitle}
                  </div>
                )}
              </div>

              {/* Back Content Area (Flex Grow - Scrollable) */}
              <div className="flex-1 w-full overflow-y-auto px-8 z-20 custom-scrollbar">
                {backContent || (
                  <div className="text-center space-y-4 pt-8">
                    <Icon name="info" className="text-4xl text-forge-orange/70" />
                    <p className="text-white/80 text-sm leading-relaxed">
                      Additional information and details about this card will appear here.
                    </p>
                  </div>
                )}
              </div>

              {/* Back Footer Strip (Flex Shrink) */}
              <div className="shrink-0 z-30 bg-[#0f0f0f]/60 backdrop-blur-xl border-t border-white/10 pt-4 pb-6 px-4">
                {backFooter || (
                  <div className="flex items-center justify-center gap-2 text-white/50">
                    <Icon name="touch_app" className="text-sm" />
                    <span className="text-xs font-mono">Tap flip to return</span>
                  </div>
                )}
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
