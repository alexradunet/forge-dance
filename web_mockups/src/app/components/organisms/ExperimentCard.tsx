import { AtomicCard } from '@/app/components/organisms/AtomicCard';
import { MiniCard } from '@/app/components/organisms/MiniCard';
import { Icon } from '@/app/components/atoms/Icon';

export function ExperimentCard({ 
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
            title="CONNECTIONS"
            subtitle="Flow"
            onClick={onClick}
            media={
                <div className="absolute inset-0 bg-neutral-900 flex items-center justify-center overflow-hidden">
                    <div className="absolute inset-0 opacity-10 bg-[conic-gradient(at_bottom_right,_var(--tw-gradient-stops))] from-blue-900 via-slate-900 to-black" />
                    <div className="relative flex items-center gap-1 z-10 scale-75">
                         <div className="w-8 h-8 rounded-lg bg-white/10 border border-white/20 flex items-center justify-center">
                           <span className="font-bold text-[10px] text-white/50">A</span>
                       </div>
                       <Icon name="link" className="text-white/40 text-[10px]" />
                       <div className="w-8 h-8 rounded-lg bg-forge-orange/20 border border-forge-orange flex items-center justify-center shadow-[0_0_5px_rgba(255,77,0,0.3)]">
                           <span className="font-bold text-[10px] text-forge-orange">B</span>
                       </div>
                    </div>
                </div>
            }
            footer={
                <div className="flex justify-between items-center w-full px-2">
                    <div className="flex flex-col gap-0.5">
                        <span className="text-[8px] uppercase text-orange-200/80 font-bold">From</span>
                        <span className="text-[10px] text-white">Top Rock</span>
                    </div>
                    <div className="flex flex-col gap-0.5 text-right">
                        <span className="text-[8px] uppercase text-cyan-200/80 font-bold">To</span>
                        <span className="text-[10px] text-white">Footwork</span>
                    </div>
                </div>
            }
        />
    );
  }

  return (
    <AtomicCard
      variant="experiment"
      title="CONNECTIONS"
      subtitle="Flow: Integration"
      interactiveLabel="Interactive: Link"
      media={
        <>
           {/* Flow Connection Visual */}
           <div className="absolute inset-0 bg-neutral-900 flex items-center justify-center overflow-hidden">
               <div className="absolute inset-0 opacity-10 bg-[conic-gradient(at_bottom_right,_var(--tw-gradient-stops))] from-blue-900 via-slate-900 to-black" />
               
               {/* Diagram */}
               <div className="relative flex items-center gap-4 z-10">
                   {/* Step A */}
                   <div className="flex flex-col items-center gap-2">
                       <div className="w-16 h-16 rounded-lg bg-white/10 border border-white/20 flex items-center justify-center backdrop-blur-sm">
                           <span className="font-bold text-white/50">A</span>
                       </div>
                       <span className="text-[10px] font-mono text-white/40 uppercase">Previous</span>
                   </div>
                   
                   {/* Arrow */}
                   <div className="flex flex-col items-center gap-1">
                        <div className="w-12 h-0.5 bg-gradient-to-r from-white/10 via-forge-orange to-white/10" />
                        <Icon name="link" className="text-white/40 text-xs" />
                   </div>
                   
                   {/* Step B */}
                   <div className="flex flex-col items-center gap-2">
                       <div className="w-16 h-16 rounded-lg bg-forge-orange/20 border border-forge-orange flex items-center justify-center backdrop-blur-sm shadow-[0_0_15px_rgba(255,77,0,0.3)]">
                           <span className="font-bold text-forge-orange">B</span>
                       </div>
                       <span className="text-[10px] font-mono text-white/40 uppercase">New Move</span>
                   </div>
               </div>
               
               {/* Background Flow Lines */}
               <svg className="absolute inset-0 w-full h-full pointer-events-none opacity-20">
                   <path d="M0,100 C100,50 200,150 300,100" stroke="white" strokeWidth="1" fill="none" strokeDasharray="5,5" />
                   <path d="M0,200 C150,150 150,250 300,200" stroke="white" strokeWidth="1" fill="none" strokeDasharray="5,5" />
               </svg>
           </div>
        </>
      }
      footer={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <div className="flex items-center gap-1.5 text-white/70">
                    <Icon name="call_split" className="text-[10px] text-orange-300" />
                    <h3 className="text-[9px] font-bold uppercase tracking-widest text-orange-200/80">From</h3>
                </div>
                <p className="text-xs font-medium text-white/95 leading-snug">
                    Top Rock
                </p>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <div className="flex items-center gap-1.5 text-white/70">
                    <Icon name="call_merge" className="text-[10px] text-cyan-300" />
                    <h3 className="text-[9px] font-bold uppercase tracking-widest text-cyan-200/80">To</h3>
                </div>
                <p className="text-xs font-medium text-white/95 leading-snug">
                    Footwork
                </p>
            </div>
        </div>
      }
      actionLabel="Connect"
      onAction={onNext}
      onFlip={() => console.log('Flip Experiment')}
      onClose={onClose}
      backTitle="FLOW GUIDE"
      backSubtitle="Transition Tips"
      backContent={
        <div className="w-full space-y-5">
          <p className="text-white/80 text-sm leading-relaxed">
             Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque.
          </p>
          
          <div className="relative pl-4 border-l-2 border-white/10 space-y-6">
             <div className="relative">
                <div className="absolute -left-[21px] top-0 w-3 h-3 rounded-full bg-white/20 ring-4 ring-black" />
                <h4 className="text-xs font-bold text-white mb-1">Exit Step A</h4>
                <p className="text-[11px] text-white/60">Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.</p>
             </div>
             
             <div className="relative">
                <div className="absolute -left-[21px] top-0 w-3 h-3 rounded-full bg-forge-orange ring-4 ring-black" />
                <h4 className="text-xs font-bold text-forge-orange mb-1">The Transition</h4>
                <p className="text-[11px] text-white/60">Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur.</p>
             </div>
             
             <div className="relative">
                <div className="absolute -left-[21px] top-0 w-3 h-3 rounded-full bg-white/20 ring-4 ring-black" />
                <h4 className="text-xs font-bold text-white mb-1">Enter Step B</h4>
                <p className="text-[11px] text-white/60">Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit.</p>
             </div>
          </div>
        </div>
      }
      backFooter={
        <div className="grid grid-cols-2 gap-4">
             <div className="flex flex-col gap-0.5 justify-center border-r border-white/10 pr-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Smoothness</span>
                <span className="text-xs font-bold text-white">Critical</span>
            </div>
            <div className="flex flex-col gap-0.5 justify-center pl-4">
                <span className="text-[9px] font-mono text-white/40 uppercase">Energy</span>
                <span className="text-xs font-bold text-white">Flow</span>
            </div>
        </div>
      }
      isFavorited={isFavorited}
      onToggleFavorite={onToggleFavorite}
    />
  );
}