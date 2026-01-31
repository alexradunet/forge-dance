import { Icon } from '@/app/components/atoms/Icon';

interface SessionCompleteCardProps {
  title?: string;
  subtitle?: string;
  stats?: {
    label: string;
    value: string | number;
    icon?: string;
  }[];
}

export function SessionCompleteCard({ 
  title = "SESSION COMPLETE", 
  subtitle = "Great work! You crushed it.",
  stats = [
    { label: "Time", value: "25:00", icon: "timer" },
    { label: "Exercises", value: "5", icon: "fitness_center" },
    { label: "XP Gained", value: "+350", icon: "bolt" }
  ]
}: SessionCompleteCardProps) {
  return (
    <div className="w-full h-full bg-surface-dark border border-white/10 rounded-[24px] p-8 flex flex-col items-center text-center relative overflow-hidden">
      {/* Background decoration */}
      <div className="absolute top-0 left-0 w-full h-full bg-gradient-to-b from-forge-fire/10 via-transparent to-transparent pointer-events-none" />
      
      {/* Confetti/Sparkles effect (Static SVG representation or just icons) */}
      <div className="absolute top-10 right-10 text-forge-fire/20"><Icon name="star" className="text-2xl" /></div>
      <div className="absolute top-20 left-10 text-forge-fire/20"><Icon name="star" className="text-xl" /></div>
      <div className="absolute bottom-32 right-8 text-forge-fire/20"><Icon name="star" className="text-3xl" /></div>

      <div className="relative z-10 flex-1 flex flex-col items-center justify-center gap-6 w-full">
        
        {/* Trophy Icon */}
        <div className="w-24 h-24 rounded-full bg-forge-fire/20 border-2 border-forge-fire flex items-center justify-center shadow-[0_0_30px_rgba(255,77,0,0.3)]">
            <Icon name="emoji_events" className="text-5xl text-forge-fire" />
        </div>
        
        <div className="space-y-2">
            <h2 className="font-title text-3xl text-white uppercase tracking-wider">{title}</h2>
            <p className="text-white/70 text-lg">{subtitle}</p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 gap-3 w-full mt-6">
            {stats.map((stat, i) => (
                <div key={i} className="flex items-center justify-between bg-white/5 border border-white/10 rounded-xl px-4 py-3">
                    <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center">
                            <Icon name={stat.icon || "check"} className="text-white text-sm" />
                        </div>
                        <span className="text-text-muted text-sm uppercase tracking-wider">{stat.label}</span>
                    </div>
                    <span className="font-title text-xl text-white">{stat.value}</span>
                </div>
            ))}
        </div>
      </div>
    </div>
  );
}
