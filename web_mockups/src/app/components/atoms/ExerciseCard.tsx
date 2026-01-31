import { Icon } from '@/app/components/atoms/Icon';
import { MiniCard } from '@/app/components/organisms/MiniCard';
import { ReactNode } from 'react';

interface ExerciseCardProps {
  type: 'warmup' | 'exercise' | 'cooldown';
  name: string;
  description: string;
  duration: string;
  reps?: string;
  stepNumber: number;
  variant?: 'active' | 'queued';
  locked?: boolean;
  media?: ReactNode;
  onCardClick?: () => void;
}

export function ExerciseCard({
  type,
  name,
  description,
  duration,
  reps,
  stepNumber,
  variant = 'active',
  locked = false,
  media,
  onCardClick,
}: ExerciseCardProps) {
  const getTypeColor = (exerciseType: string) => {
    switch (exerciseType) {
      case 'warmup':
        return 'text-electric-blue';
      case 'exercise':
        return 'text-forge-fire';
      case 'cooldown':
        return 'text-mystic-purple';
      default:
        return 'text-white';
    }
  };

  const getTypeIcon = (exerciseType: string) => {
    switch (exerciseType) {
      case 'warmup':
        return 'whatshot';
      case 'exercise':
        return 'fitness_center';
      case 'cooldown':
        return 'self_improvement';
      default:
        return 'circle';
    }
  };

  const isQueued = variant === 'queued';

  return (
    <div 
      className={`
        rounded-2xl p-4 shadow-xl
        ${isQueued 
          ? 'bg-surface-card/40 border border-white/5 opacity-60' 
          : 'bg-gradient-to-br from-surface-card to-surface-dark border border-white/10'
        }
      `}
    >
      <div className="flex items-start gap-4">
        {/* Exercise Info - Left Side */}
        <div className="flex-1">
          <div className={`text-[10px] font-bold uppercase tracking-wider mb-1 ${isQueued ? 'opacity-60' : ''} ${getTypeColor(type)}`}>
            {type}
          </div>
          <h3 className={`font-title text-2xl leading-none mb-2 ${isQueued ? 'text-white/80' : 'text-white'}`}>
            {name}
          </h3>
          <p className={`text-xs mb-3 ${isQueued ? 'text-text-muted/60' : 'text-text-muted'}`}>
            {description}
          </p>
          
          <div className="flex items-center gap-2">
            <div className={`px-2 py-1 rounded-lg flex items-center gap-1 ${isQueued ? 'bg-white/5' : 'bg-white/5'}`}>
              <Icon name="timer" className={`text-sm ${isQueued ? 'text-electric-blue/60' : 'text-electric-blue'}`} />
              <span className={`text-[10px] font-bold ${isQueued ? 'text-white/60' : 'text-white'}`}>{duration}</span>
            </div>
            {reps && (
              <div className={`px-2 py-1 rounded-lg ${isQueued ? 'bg-white/5' : 'bg-white/5'}`}>
                <span className={`text-[10px] font-bold ${isQueued ? 'text-white/60' : 'text-white'}`}>{reps}</span>
              </div>
            )}
          </div>
        </div>
        
        {/* Card Thumbnail - Right Side */}
        <div className="w-24 shrink-0 relative">
          {locked ? (
            <div className="w-full h-24 rounded-lg bg-surface-dark/50 border border-white/5 flex items-center justify-center">
              <Icon name="lock" className="text-white/30 text-2xl" />
            </div>
          ) : (
            <MiniCard
              title={name.split(' ')[0]}
              subtitle={`Step ${stepNumber}`}
              onClick={onCardClick}
              media={media}
              footer={
                <div className="flex items-center gap-1">
                  <Icon name={getTypeIcon(type)} className={`text-xs ${getTypeColor(type)}`} />
                  <span className="text-[8px] text-white uppercase">{type}</span>
                </div>
              }
            />
          )}
        </div>
      </div>
    </div>
  );
}
