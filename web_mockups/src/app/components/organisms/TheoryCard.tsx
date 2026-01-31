import { AtomicCard } from '@/app/components/organisms/AtomicCard';
import { MiniCard } from '@/app/components/organisms/MiniCard';
import { Icon } from '@/app/components/atoms/Icon';

export function TheoryCard({ 
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
  if (mode === 'mini') {
    return (
        <MiniCard
            title="DRILL SESSION"
            subtitle="Training"
            onClick={onClick}
            media={
                <div className="absolute inset-0 bg-neutral-900 overflow-hidden flex items-center justify-center">
                    <div className="absolute inset-0 opacity-20" style={{ backgroundImage: 'linear-gradient(45deg, #333 25%, transparent 25%, transparent 75%, #333 75%, #333), linear-gradient(45deg, #333 25%, transparent 25%, transparent 75%, #333 75%, #333)', backgroundSize: '20px 20px', backgroundPosition: '0 0, 10px 10px' }} />
                    <div className="relative w-20 h-20">
                        <div className="absolute inset-0 border-2 border-forge-orange/30 rounded-full" />
                        <div className="absolute inset-0 flex items-center justify-center">
                            <Icon name="fitness_center" className="text-3xl text-white" />
                        </div>
                    </div>
                </div>
            }
            footer={
                <div className="grid grid-cols-3 gap-1 w-full text-center">
                     <div className="border-r border-white/10">
                        <span className="text-[7px] text-white/40 block">SETS</span>
                        <span className="text-[9px] font-bold text-white">3</span>
                    </div>
                    <div className="border-r border-white/10">
                        <span className="text-[7px] text-white/40 block">REPS</span>
                        <span className="text-[9px] font-bold text-white">12</span>
                    </div>
                    <div>
                        <span className="text-[7px] text-white/40 block">REST</span>
                        <span className="text-[9px] font-bold text-white">60s</span>
                    </div>
                </div>
            }
        />
    );
  }

  return (
    <AtomicCard
      variant="theory"
      title="DRILL SESSION"
      subtitle="Training: Conditioning"
      interactiveLabel="Interactive: View Drill"
      isFavorited={isFavorited}
      onToggleFavorite={onToggleFavorite}
      media={
        <>
            {/* Drill Visual */}
            <div className="absolute inset-0 bg-neutral-900 overflow-hidden">
                <div className="absolute inset-0 opacity-20" style={{ backgroundImage: 'linear-gradient(45deg, #333 25%, transparent 25%, transparent 75%, #333 75%, #333), linear-gradient(45deg, #333 25%, transparent 25%, transparent 75%, #333 75%, #333)', backgroundSize: '20px 20px', backgroundPosition: '0 0, 10px 10px' }} />
                
                <div className="absolute inset-0 flex items-center justify-center">
                    <div className="relative w-40 h-40">
                         {/* Abstract Body Reps Animation */}
                        <div className="absolute inset-0 border-4 border-forge-orange/30 rounded-full animate-ping opacity-20" />
                        <div className="absolute inset-2 border-4 border-forge-orange/50 rounded-full animate-pulse" />
                        <div className="absolute inset-0 flex items-center justify-center">
                            <Icon name="fitness_center" className="text-5xl text-white" />
                        </div>
                    </div>
                </div>
                
                <div className="absolute bottom-8 w-full text-center">
                     <div className="inline-block px-3 py-1 rounded bg-black/50 border border-white/10 backdrop-blur-sm">
                        <span className="text-[10px] text-white/70 uppercase font-mono">Core Stability Drill</span>
                     </div>
                </div>
            </div>
        </>
      }
      footer={
        <div className="grid grid-cols-3 gap-3">
             <div className="flex flex-col items-center justify-center gap-0.5 border-r border-white/10 pr-2">
                <span className="text-[9px] font-mono text-white/40 uppercase">Sets</span>
                <span className="text-sm font-bold text-white">3</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-0.5 border-r border-white/10 px-2">
                <span className="text-[9px] font-mono text-white/40 uppercase">Reps</span>
                <span className="text-sm font-bold text-white">12</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-0.5 pl-2">
                <span className="text-[9px] font-mono text-white/40 uppercase">Rest</span>
                <span className="text-sm font-bold text-white">60s</span>
            </div>
        </div>
      }
      actionLabel="Start Drill"
      onAction={onNext}
      onFlip={() => console.log('Flip Theory')}
      onClose={onClose}
      backTitle="DRILL GUIDE"
      backSubtitle="Execution Details"
      backContent={
        <div className="w-full space-y-5">
           <p className="text-white/80 text-sm leading-relaxed">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
          </p>
          
          <div className="bg-white/5 border border-white/10 rounded-lg p-4 space-y-3">
            <div className="flex gap-3">
                <div className="w-6 h-6 rounded bg-forge-orange/20 flex items-center justify-center shrink-0 text-forge-orange text-xs font-bold">1</div>
                <p className="text-xs text-white/70">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.</p>
            </div>
            <div className="h-px bg-white/5 w-full" />
            <div className="flex gap-3">
                <div className="w-6 h-6 rounded bg-forge-orange/20 flex items-center justify-center shrink-0 text-forge-orange text-xs font-bold">2</div>
                <p className="text-xs text-white/70">Excepteur sint occaecat cupidatat non proident, sunt in culpa.</p>
            </div>
             <div className="h-px bg-white/5 w-full" />
            <div className="flex gap-3">
                <div className="w-6 h-6 rounded bg-forge-orange/20 flex items-center justify-center shrink-0 text-forge-orange text-xs font-bold">3</div>
                <p className="text-xs text-white/70">Mollit anim id est laborum sed ut perspiciatis unde omnis iste.</p>
            </div>
          </div>
        </div>
      }
      backFooter={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Intensity</span>
                <span className="text-xs font-bold text-forge-orange">High</span>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Focus</span>
                <span className="text-xs font-bold text-white">Strength</span>
            </div>
        </div>
      }
    />
  );
}