import { Badge } from '@/app/components/atoms/Badge';
import { ProgressBar } from '@/app/components/atoms/ProgressBar';

interface ModuleCardMediumProps {
  title: string;
  category: string;
  categoryColor?: string;
  progress: number;
  lessons: { completed: number; total: number };
  imageUrl: string;
  className?: string;
  onClick?: () => void;
}

export const ModuleCardMedium = ({
  title,
  category,
  categoryColor = 'primary',
  progress,
  lessons,
  imageUrl,
  className = '',
  onClick
}: ModuleCardMediumProps) => {
  return (
    <div
      className={`
        w-[280px] h-[90px] bg-surface-dark rounded-2xl relative overflow-hidden 
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
      <div className="absolute inset-0 bg-gradient-to-t from-bg-deep via-bg-deep/60 to-transparent" />
      
      <div className="absolute top-2 left-3">
        <Badge variant={categoryColor as any} className="text-[8px] px-2 py-0.5">{category}</Badge>
      </div>
      
      <div className="absolute bottom-2 left-3 right-3">
        <h3 className="font-title text-sm tracking-wide mb-1 text-white truncate">
          {title}
        </h3>
        <div className="flex items-center justify-between text-[8px] text-text-muted mb-1 font-medium tracking-wide">
          <span>{lessons.completed}/{lessons.total} Lessons</span>
          <span>{progress}%</span>
        </div>
        <ProgressBar value={progress} variant="primary" size="sm" />
      </div>
    </div>
  );
};
