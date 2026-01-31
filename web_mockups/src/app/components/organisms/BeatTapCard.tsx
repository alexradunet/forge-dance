import { AtomicCard } from '@/app/components/organisms/AtomicCard';
import { MiniCard } from '@/app/components/organisms/MiniCard';
import { Icon } from '@/app/components/atoms/Icon';

export function BeatTapCard({ 
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
            title="RHYTHM GAME"
            subtitle="Training"
            onClick={onClick}
            media={
                <div className="absolute inset-0 bg-neutral-900 flex flex-col items-center justify-center">
                    <div className="relative w-24 h-full border-x border-white/10 flex flex-col items-center overflow-hidden">
                        <div className="absolute inset-0 bg-gradient-to-b from-transparent via-white/5 to-transparent" />
                        <div className="absolute bottom-12 w-full h-0.5 bg-white/30" />
                        <div className="absolute top-[40%] w-12 h-4 rounded-full bg-forge-orange shadow-[0_0_10px_rgba(255,77,0,0.6)]" />
                        <div className="absolute top-[70%] w-12 h-4 rounded-full bg-white/20 border border-white/40" />
                    </div>
                </div>
            }
            footer={
                <div className="grid grid-cols-3 gap-1 w-full text-center">
                    <div className="border-r border-white/10">
                        <span className="text-[7px] text-white/40 block">SCORE</span>
                        <span className="text-[9px] font-bold text-forge-orange">1250</span>
                    </div>
                    <div className="border-r border-white/10">
                        <span className="text-[7px] text-white/40 block">COMBO</span>
                        <span className="text-[9px] font-bold text-white">x12</span>
                    </div>
                    <div>
                        <span className="text-[7px] text-white/40 block">ACC</span>
                        <span className="text-[9px] font-bold text-green-400">98%</span>
                    </div>
                </div>
            }
        />
      );
  }

  return (
    <AtomicCard
      variant="beat"
      title="RHYTHM GAME"
      subtitle="Training: Timing"
      interactiveLabel="Interactive: Tap"
      isFavorited={isFavorited}
      onToggleFavorite={onToggleFavorite}
      media={
        <>
          {/* Rhythm Game UI */}
          <div className="absolute inset-0 bg-neutral-900 flex flex-col items-center justify-center">
             {/* Lane */}
             <div className="relative w-48 h-full border-x border-white/10 flex flex-col items-center overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-b from-transparent via-white/5 to-transparent" />
                
                {/* Hit Line */}
                <div className="absolute bottom-24 w-full h-1 bg-white/30 shadow-[0_0_10px_rgba(255,255,255,0.5)] z-20" />
                
                {/* Falling Notes */}
                <div className="absolute top-[20%] w-24 h-8 rounded-full bg-forge-orange shadow-[0_0_15px_rgba(255,77,0,0.6)] z-10 animate-bounce" />
                <div className="absolute top-[50%] w-24 h-8 rounded-full bg-white/20 border border-white/40 z-10" />
                <div className="absolute top-[80%] w-24 h-8 rounded-full bg-forge-orange shadow-[0_0_15px_rgba(255,77,0,0.6)] z-10 opacity-50" />
             </div>
             
             {/* Tap Feedback */}
             <div className="absolute bottom-12">
                <div className="px-4 py-1 rounded-full bg-white/10 border border-white/20 backdrop-blur-md">
                    <span className="text-[10px] font-mono text-white tracking-widest uppercase">Tap to Beat</span>
                </div>
             </div>
          </div>
        </>
      }
      footer={
        <div className="grid grid-cols-3 gap-3">
            <div className="flex flex-col items-center justify-center gap-0.5 border-r border-white/10 pr-2">
                <span className="text-[9px] font-mono text-white/40 uppercase">Score</span>
                <span className="text-sm font-bold text-forge-orange">1,250</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-0.5 border-r border-white/10 px-2">
                <span className="text-[9px] font-mono text-white/40 uppercase">Combo</span>
                <span className="text-sm font-bold text-white">x12</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-0.5 pl-2">
                <span className="text-[9px] font-mono text-white/40 uppercase">Acc</span>
                <span className="text-sm font-bold text-green-400">98%</span>
            </div>
        </div>
      }
      actionLabel="Start Game"
      onAction={onNext}
      onFlip={() => console.log('Flip Beat')}
      onClose={onClose}
      backTitle="PATTERN INFO"
      backSubtitle="Rhythm Structure"
      backContent={
        <div className="w-full space-y-5">
           <p className="text-white/80 text-sm leading-relaxed">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
          </p>
          
          <div className="space-y-4 pt-2">
             <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-forge-orange/20 flex items-center justify-center">
                    <span className="font-mono text-xs text-forge-orange font-bold">1</span>
                </div>
                <div className="flex-1 h-1 bg-white/10 rounded-full overflow-hidden">
                    <div className="h-full w-full bg-gradient-to-r from-forge-orange to-transparent opacity-80" />
                </div>
                <span className="text-xs font-mono text-white/60">Kick</span>
             </div>
             <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-blue-500/20 flex items-center justify-center">
                    <span className="font-mono text-xs text-blue-400 font-bold">2</span>
                </div>
                <div className="flex-1 h-1 bg-white/10 rounded-full overflow-hidden">
                    <div className="h-full w-1/2 bg-gradient-to-r from-blue-400 to-transparent opacity-80" />
                </div>
                <span className="text-xs font-mono text-white/60">Snare</span>
             </div>
             <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-purple-500/20 flex items-center justify-center">
                    <span className="font-mono text-xs text-purple-400 font-bold">3</span>
                </div>
                <div className="flex-1 h-1 bg-white/10 rounded-full overflow-hidden">
                    <div className="h-full w-3/4 bg-gradient-to-r from-purple-400 to-transparent opacity-80" />
                </div>
                <span className="text-xs font-mono text-white/60">Hi-Hat</span>
             </div>
          </div>
        </div>
      }
      backFooter={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Time Sig</span>
                <span className="text-xs font-bold text-white">4/4</span>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Tempo</span>
                <span className="text-xs font-bold text-white">120 BPM</span>
            </div>
        </div>
      }
    />
  );
}