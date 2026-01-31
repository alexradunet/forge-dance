import { Icon } from '@/app/components/atoms/Icon';

interface WorkoutIntroCardProps {
  title: string;
  duration: string;
  intensity: 'Low' | 'Medium' | 'High';
  description: string;
}

export function WorkoutIntroCard({ title, duration, intensity, description }: WorkoutIntroCardProps) {
  return (
    <div className="w-full h-full bg-surface-dark border border-white/10 rounded-[24px] p-8 flex flex-col items-center text-center relative overflow-hidden">
      {/* Background decoration */}
      <div className="absolute top-0 left-0 w-full h-1/2 bg-gradient-to-b from-forge-fire/20 to-transparent opacity-50 pointer-events-none" />
      
      <div className="relative z-10 flex-1 flex flex-col items-center justify-center gap-6">
        <div className="w-20 h-20 rounded-full bg-forge-fire/20 border border-forge-fire/50 flex items-center justify-center">
            <Icon name="fitness_center" className="text-4xl text-forge-fire" />
        </div>
        
        <div className="space-y-2">
            <h2 className="font-title text-3xl text-white uppercase tracking-wider">{title}</h2>
            <div className="flex items-center justify-center gap-4 text-sm text-text-muted">
                <span className="flex items-center gap-1">
                    <Icon name="timer" className="text-lg" />
                    {duration}
                </span>
                <span className="w-1 h-1 rounded-full bg-white/20" />
                <span className="flex items-center gap-1">
                    <Icon name="bolt" className="text-lg" />
                    {intensity} Intensity
                </span>
            </div>
        </div>

        <p className="text-white/70 leading-relaxed max-w-xs">
            {description}
        </p>

        <div className="grid grid-cols-3 gap-4 w-full pt-6 border-t border-white/10 mt-2">
             <div className="flex flex-col items-center gap-1">
                <span className="text-2xl font-bold text-white">5</span>
                <span className="text-[10px] uppercase text-text-muted tracking-wider">Exercises</span>
             </div>
             <div className="flex flex-col items-center gap-1 border-x border-white/10">
                <span className="text-2xl font-bold text-white">350</span>
                <span className="text-[10px] uppercase text-text-muted tracking-wider">Cal</span>
             </div>
             <div className="flex flex-col items-center gap-1">
                <span className="text-2xl font-bold text-white">EXP</span>
                <span className="text-[10px] uppercase text-text-muted tracking-wider">Level Up</span>
             </div>
        </div>
      </div>
    </div>
  );
}
