import { Badge } from '@/app/components/atoms/Badge';

interface ModuleCardSmallProps {
  title: string;
  category: string;
  categoryColor?: string;
  progress: number;
  lessons: { completed: number; total: number };
  imageUrl: string;
  className?: string;
  onClick?: () => void;
}

export const ModuleCardSmall = ({
  title,
  category,
  categoryColor = 'primary',
  progress,
  lessons,
  imageUrl,
  className = '',
  onClick
}: ModuleCardSmallProps) => {
  return (
    <div
      className={`
        w-[180px] h-[180px] bg-surface-dark rounded-3xl relative overflow-hidden 
        group border border-white/5 shadow-lg cursor-pointer flex-shrink-0
        ${className}
      `}
      onClick={onClick}
    >
      <img
        src={imageUrl}
        alt={title}
        className="absolute inset-0 w-full h-full object-cover opacity-60 group-hover:scale-105 transition-transform duration-700"
      />
      <div className="absolute inset-0 bg-gradient-to-t from-bg-deep via-bg-deep/40 to-transparent" />
      
      <div className="absolute top-3 left-3">
        <Badge variant={categoryColor as any} className="text-[8px] px-2 py-0.5">{category}</Badge>
      </div>
      
      <div className="absolute bottom-3 left-3 right-3">
        <h3 className="font-title text-lg tracking-wide mb-1.5 text-white leading-tight">
          {title}
        </h3>
        <div className="flex items-center justify-between text-[9px] text-text-muted mb-1.5 font-medium tracking-wide">
          <span>{lessons.completed}/{lessons.total} Lessons</span>
          <span>{progress}%</span>
        </div>
        <div className="w-full h-1 bg-white/10 rounded-full overflow-hidden">
          <div 
            className="h-full bg-forge-fire rounded-full transition-all duration-300"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>
    </div>
  );
};