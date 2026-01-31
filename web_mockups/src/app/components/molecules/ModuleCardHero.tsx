import { Badge } from '@/app/components/atoms/Badge';
import { Icon } from '@/app/components/atoms/Icon';
import { Button } from '@/app/components/atoms/Button';

interface ModuleCardHeroProps {
  title: string;
  description?: string;
  category: string;
  categoryColor?: string;
  duration?: string;
  imageUrl: string;
  className?: string;
  onStart?: () => void;
  badge?: string;
}

export const ModuleCardHero = ({
  title,
  description,
  category,
  categoryColor = 'primary',
  duration,
  imageUrl,
  className = '',
  onStart,
  badge
}: ModuleCardHeroProps) => {
  return (
    <div
      className={`
        w-full h-[320px] bg-surface-dark rounded-3xl relative overflow-hidden 
        group border border-white/5 shadow-lg cursor-pointer
        ${className}
      `}
      onClick={onStart}
    >
      <img
        src={imageUrl}
        alt={title}
        className="absolute inset-0 w-full h-full object-cover opacity-70 group-hover:scale-105 transition-transform duration-700"
      />
      <div className="absolute inset-0 bg-gradient-to-t from-bg-deep via-bg-deep/60 to-transparent" />
      
      <div className="absolute top-4 left-4 flex items-center gap-2">
        <Badge variant={categoryColor as any}>{category}</Badge>
      </div>
      
      {badge && (
        <div className="absolute top-4 right-4 z-10 bg-forge-fire text-white text-[9px] font-bold uppercase px-2 py-1 rounded-full shadow-lg">
          {badge}
        </div>
      )}
      
      <div className="absolute bottom-6 left-6 right-6">
        {description && (
          <p className="text-xs text-gray-200 line-clamp-2 w-3/4 mb-1 font-medium">
            {description}
          </p>
        )}
        <h3 className="font-title text-5xl tracking-wide mb-2 text-white leading-tight drop-shadow-lg">
          {title}
        </h3>
        <Button 
          variant="primary" 
          size="md"
          className="mt-2 w-full"
          onClick={(e) => {
            e.stopPropagation();
            onStart?.();
          }}
        >
          <Icon name="play_arrow" className="text-lg" />
          START TRAINING{duration ? ` • ${duration}` : ''}
        </Button>
      </div>
    </div>
  );
};