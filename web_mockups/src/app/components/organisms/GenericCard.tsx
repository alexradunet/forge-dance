import { AtomicCard } from '@/app/components/organisms/AtomicCard';
import { MiniCard } from '@/app/components/organisms/MiniCard';
import { Icon } from '@/app/components/atoms/Icon';
import { useState } from 'react';

export function GenericCard({ 
  onNext, 
  mode = 'full', 
  onClick,
  onClose,
  isFavorited,
  onToggleFavorite
}: { 
  onNext?: () => void; 
  mode?: 'full' | 'mini'; 
  onClick?: () => void;
  onClose?: () => void;
  isFavorited?: boolean;
  onToggleFavorite?: () => void;
}) {
  const [isPlaying, setIsPlaying] = useState(false);

  const handlePlayClick = () => {
    setIsPlaying(true);
  };

  const handleVideoClick = () => {
    setIsPlaying(false);
  };

  if (mode === 'mini') {
    return (
      <MiniCard
        title="BASIC BOUNCE"
        subtitle="Lesson 1"
        onClick={onClick}
        media={
          <>
            <div className="absolute inset-0 bg-neutral-900">
                <img 
                    src="https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=400&auto=format&fit=crop&q=80" 
                    alt="Dance Step"
                    className="w-full h-full object-cover opacity-60"
                />
                <div className="absolute inset-0 flex items-center justify-center">
                    <div className="w-10 h-10 rounded-full bg-white/10 backdrop-blur-md border border-white/30 flex items-center justify-center pl-0.5">
                        <Icon name="play_arrow" className="text-xl text-white" />
                    </div>
                </div>
            </div>
          </>
        }
        footer={
           <div className="flex justify-between items-center w-full">
               <div className="flex flex-col gap-0.5">
                   <span className="text-[8px] uppercase text-blue-200/80 font-bold">Style</span>
                   <span className="text-[10px] text-white">Hip Hop</span>
               </div>
               <div className="flex flex-col gap-0.5 text-right">
                   <span className="text-[8px] uppercase text-green-200/80 font-bold">Diff</span>
                   <span className="text-[10px] text-white">Easy</span>
               </div>
           </div>
        }
      />
    );
  }

  return (
    <AtomicCard
      variant="generic"
      title="BASIC BOUNCE"
      subtitle="Lesson 1: Foundation"
      interactiveLabel="Interactive: Watch"
      isFavorited={isFavorited}
      onToggleFavorite={onToggleFavorite}
      isVideoPlaying={isPlaying}
      media={
        <>
            {/* Video Player */}
            <div className="absolute inset-0 bg-neutral-900 flex flex-col">
                {/* Video/Image Container */}
                <div className="flex-1 relative overflow-hidden h-full w-full">
                  {!isPlaying ? (
                    <>
                      <img 
                          src="https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=800&auto=format&fit=crop&q=80" 
                          alt="Dance Step"
                          className="w-full h-full object-cover opacity-60"
                      />
                      <div 
                          className="absolute inset-0 flex items-center justify-center cursor-pointer"
                          onClick={handlePlayClick}
                      >
                          <div className="w-16 h-16 rounded-full bg-white/10 backdrop-blur-md border border-white/30 flex items-center justify-center pl-1 hover:scale-110 hover:bg-white/20 transition-all">
                              <Icon name="play_arrow" className="text-3xl text-white" />
                          </div>
                      </div>
                    </>
                  ) : (
                    <div 
                      className="w-full h-full relative cursor-pointer"
                      onClick={handleVideoClick}
                    >
                      <video
                        src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
                        autoPlay
                        className="w-full h-full object-cover"
                        onEnded={() => setIsPlaying(false)}
                      />
                    </div>
                  )}
                </div>
                
                {/* Progress Bar - Only show when not playing */}
                {!isPlaying && (
                  <div className="absolute bottom-0 left-0 right-0 h-1 bg-white/10 z-10">
                      <div className="h-full w-1/3 bg-forge-orange relative">
                          <div className="absolute right-0 top-1/2 -translate-y-1/2 w-2 h-2 rounded-full bg-white shadow-sm" />
                      </div>
                  </div>
                )}
            </div>
        </>
      }
      footer={
        <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <div className="flex items-center gap-1.5 text-white/70">
                    <Icon name="style" className="text-[10px] text-blue-300" />
                    <h3 className="text-[9px] font-bold uppercase tracking-widest text-blue-200/80">Style</h3>
                </div>
                <p className="text-xs font-medium text-white/95 leading-snug">
                    Hip Hop
                </p>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <div className="flex items-center gap-1.5 text-white/70">
                    <Icon name="signal_cellular_alt" className="text-[10px] text-green-300" />
                    <h3 className="text-[9px] font-bold uppercase tracking-widest text-green-200/80">Difficulty</h3>
                </div>
                <p className="text-xs font-medium text-white/95 leading-snug">
                    Easy
                </p>
            </div>
        </div>
      }
      actionLabel="Start Lesson"
      onAction={onNext}
      onFlip={() => console.log('Flip Generic')}
      onClose={onClose}
      backTitle="STEP DETAILS"
      backSubtitle="Technique Breakdown"
      backContent={
        <div className="w-full space-y-5">
          <p className="text-white/80 text-sm leading-relaxed">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.
          </p>
          
          <div className="space-y-3">
             <div className="flex items-start gap-3 p-3 rounded-lg bg-white/5 border border-white/10">
                <div className="mt-0.5"><Icon name="check_circle" className="text-forge-orange text-sm" /></div>
                <div>
                    <h4 className="text-xs font-bold text-white mb-1">Key Focus</h4>
                    <p className="text-[11px] text-white/60">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia.</p>
                </div>
             </div>
             
             <div className="flex items-start gap-3 p-3 rounded-lg bg-white/5 border border-white/10">
                <div className="mt-0.5"><Icon name="do_not_touch" className="text-red-400 text-sm" /></div>
                <div>
                    <h4 className="text-xs font-bold text-white mb-1">Common Mistake</h4>
                    <p className="text-[11px] text-white/60">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore.</p>
                </div>
             </div>
          </div>
        </div>
      }
      backFooter={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Duration</span>
                <span className="text-xs font-bold text-white">2:15</span>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">BPM</span>
                <span className="text-xs font-bold text-white">95</span>
            </div>
        </div>
      }
    />
  );
}
