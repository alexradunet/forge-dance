import { Icon } from '@/app/components/atoms/Icon';

interface LessonNodeProps {
  title: string;
  type: 'theory' | 'movement' | 'drill' | 'experiment';
  status: 'completed' | 'active' | 'locked';
  duration?: string;
  className?: string;
  onClick?: () => void;
}

export const LessonNode = ({
  title,
  type,
  status,
  duration,
  className = '',
  onClick
}: LessonNodeProps) => {
  const iconMap = {
    theory: 'menu_book',
    movement: 'directions_run',
    drill: 'fitness_center',
    experiment: 'science'
  };
  
  const typeColors = {
    theory: 'text-electric-blue',
    movement: 'text-forge-fire',
    drill: 'text-green-500',
    experiment: 'text-purple-500'
  };
  
  const statusStyles = {
    completed: 'bg-forge-fire shadow-[0_0_20px_rgba(255,69,0,0.4)]',
    active: 'bg-bg-deep border-2 border-forge-fire shadow-[0_0_30px_rgba(255,69,0,0.6)] ring-4 ring-forge-fire/20',
    locked: 'bg-zinc-800 border border-white/10 opacity-40'
  };
  
  return (
    <div className={`relative flex flex-col items-center ${className}`}>
      <div
        className={`
          w-14 h-14 rounded-full flex items-center justify-center 
          transition-transform cursor-pointer hover:scale-110
          ${statusStyles[status]}
        `}
        onClick={status !== 'locked' ? onClick : undefined}
      >
        <Icon
          name={iconMap[type]}
          className={`text-2xl ${status === 'locked' ? 'text-white/50' : 'text-white'}`}
        />
        {status === 'completed' && (
          <div className="absolute -right-1 -bottom-1 w-6 h-6 rounded-full bg-green-500 border-4 border-bg-deep flex items-center justify-center">
            <Icon name="check" className="text-white text-[12px] font-bold" />
          </div>
        )}
        {status === 'locked' && (
          <div className="absolute -right-1 -top-1 w-6 h-6 rounded-full bg-bg-deep border border-white/10 flex items-center justify-center">
            <Icon name="lock" className="text-white/50 text-[14px]" />
          </div>
        )}
      </div>
      
      <div className="mt-4 text-center">
        {status === 'active' && (
          <span className="text-[10px] font-bold uppercase tracking-widest text-forge-fire block mb-1">
            Current
          </span>
        )}
        <h3 className={`text-sm font-bold uppercase ${status === 'locked' ? 'text-white/50' : 'text-white'}`}>
          {title}
        </h3>
        {duration && (
          <p className="text-[10px] text-text-muted mt-1">{duration}</p>
        )}
      </div>
    </div>
  );
};
