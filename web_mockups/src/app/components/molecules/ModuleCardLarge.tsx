import { Badge } from '@/app/components/atoms/Badge';
import { ProgressBar } from '@/app/components/atoms/ProgressBar';

interface ModuleCardLargeProps {
  title: string;
  category: string;
  categoryColor?: string;
  progress: number;
  lessons: { completed: number; total: number };
  imageUrl: string;
  className?: string;
  onClick?: () => void;
  badge?: string;
}

export const ModuleCardLarge = ({
  title,
  category,
  categoryColor = 'primary',
  progress,
  lessons,
  imageUrl,
  className = '',
  onClick,
  badge
}: ModuleCardLargeProps) => {
  return (
    <div
      className={`
        w-[280px] h-[180px] bg-surface-dark rounded-3xl relative overflow-hidden 
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
      
      <div className="absolute top-4 left-4">
        <Badge variant={categoryColor as any}>{category}</Badge>
      </div>
      
      {badge && (
        <div className="absolute top-4 right-4 z-10 bg-forge-fire text-white text-[9px] font-bold uppercase px-2 py-1 rounded-full shadow-lg">
          {badge}
        </div>
      )}
      
      <div className="absolute bottom-4 left-4 right-4">
        <h3 className="font-title text-2xl tracking-wide mb-2 text-white">
          {title}
        </h3>
        <div className="flex items-center justify-between text-[10px] text-text-muted mb-2 font-medium tracking-wide">
          <span>{lessons.completed}/{lessons.total} Lessons</span>
          <span>{progress}%</span>
        </div>
        <ProgressBar value={progress} variant="primary" size="md" />
      </div>
    </div>
  );
};