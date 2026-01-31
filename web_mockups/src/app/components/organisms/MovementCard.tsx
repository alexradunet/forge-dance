import { AtomicCard } from '@/app/components/organisms/AtomicCard';
import { MiniCard } from '@/app/components/organisms/MiniCard';
import { Icon } from '@/app/components/atoms/Icon';

export function MovementCard({ 
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
            title="CREATIVE LAB"
            subtitle="Challenge"
            onClick={onClick}
            media={
                <div className="absolute inset-0 bg-neutral-900 overflow-hidden">
                    <div className="absolute inset-0 opacity-40 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-purple-900 via-black to-black" />
                    <div className="absolute top-1/4 left-1/4 w-16 h-16 bg-purple-500/20 rounded-full blur-xl" />
                    <div className="absolute bottom-1/4 right-1/4 w-20 h-20 bg-blue-500/20 rounded-full blur-xl" />
                    <div className="absolute inset-0 flex items-center justify-center">
                        <Icon name="lightbulb" className="text-2xl text-yellow-400 opacity-80" />
                    </div>
                </div>
            }
            footer={
                <div className="flex justify-between items-center w-full px-2">
                    <div className="flex flex-col gap-0.5">
                        <span className="text-[8px] uppercase text-purple-200/80 font-bold">Prompt</span>
                        <span className="text-[10px] text-white">Levels</span>
                    </div>
                    <div className="flex flex-col gap-0.5 text-right">
                        <span className="text-[8px] uppercase text-blue-200/80 font-bold">Type</span>
                        <span className="text-[10px] text-white">Free</span>
                    </div>
                </div>
            }
        />
    );
  }

  return (
    <AtomicCard
      variant="movement"
      title="CREATIVE LAB"
      subtitle="Challenge: Variations"
      interactiveLabel="Interactive: Explore"
      media={
        <>
           {/* Abstract Creativity Visual */}
           <div className="absolute inset-0 bg-neutral-900 overflow-hidden">
                <div className="absolute inset-0 opacity-40 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-purple-900 via-black to-black" />
                
                {/* Floating Shapes */}
                <div className="absolute top-1/4 left-1/4 w-32 h-32 bg-purple-500/20 rounded-full blur-xl animate-pulse" />
                <div className="absolute bottom-1/4 right-1/4 w-40 h-40 bg-blue-500/20 rounded-full blur-xl animate-pulse delay-700" />
                
                <div className="absolute inset-0 flex items-center justify-center">
                    <div className="relative border border-white/20 p-6 rounded-xl bg-white/5 backdrop-blur-sm max-w-[200px] text-center">
                        <Icon name="lightbulb" className="text-3xl text-yellow-400 mb-2 mx-auto" />
                        <p className="text-xs font-mono text-white/80">
                            "Think outside the box. How else can this move be used?"
                        </p>
                    </div>
                </div>
           </div>
        </>
      }
      footer={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <div className="flex items-center gap-1.5 text-white/70">
                    <Icon name="palette" className="text-[10px] text-purple-300" />
                    <h3 className="text-[9px] font-bold uppercase tracking-widest text-purple-200/80">Prompt</h3>
                </div>
                <p className="text-xs font-medium text-white/95 leading-snug">
                    Levels
                </p>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <div className="flex items-center gap-1.5 text-white/70">
                    <Icon name="extension" className="text-[10px] text-blue-300" />
                    <h3 className="text-[9px] font-bold uppercase tracking-widest text-blue-200/80">Type</h3>
                </div>
                <p className="text-xs font-medium text-white/95 leading-snug">
                    Freestyle
                </p>
            </div>
        </div>
      }
      actionLabel="Try It"
      onAction={onNext}
      onFlip={() => console.log('Flip Movement')}
      onClose={onClose}
      backTitle="EXPANSION"
      backSubtitle="Creative Prompts"
      backContent={
        <div className="w-full space-y-5">
          <p className="text-white/80 text-sm leading-relaxed">
             Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
          
          <div className="grid grid-cols-2 gap-3">
             <div className="p-3 rounded-lg bg-purple-500/10 border border-purple-500/20 text-center">
                <Icon name="height" className="text-purple-400 mb-1" />
                <h4 className="text-xs font-bold text-white mb-1">Change Height</h4>
                <p className="text-[10px] text-white/60">Ut enim ad minim veniam.</p>
             </div>
             <div className="p-3 rounded-lg bg-blue-500/10 border border-blue-500/20 text-center">
                <Icon name="speed" className="text-blue-400 mb-1" />
                <h4 className="text-xs font-bold text-white mb-1">Change Speed</h4>
                <p className="text-[10px] text-white/60">Quis nostrud exercitation.</p>
             </div>
             <div className="p-3 rounded-lg bg-pink-500/10 border border-pink-500/20 text-center col-span-2">
                <Icon name="loop" className="text-pink-400 mb-1" />
                <h4 className="text-xs font-bold text-white mb-1">Reverse It</h4>
                <p className="text-[10px] text-white/60">Duis aute irure dolor in reprehenderit in voluptate velit.</p>
             </div>
          </div>
        </div>
      }
      backFooter={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Mode</span>
                <span className="text-xs font-bold text-white">Exploration</span>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Goal</span>
                <span className="text-xs font-bold text-white">Originality</span>
            </div>
        </div>
      }
      isFavorited={isFavorited}
      onToggleFavorite={onToggleFavorite}
    />
  );
}