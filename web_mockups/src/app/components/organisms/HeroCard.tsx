import { Badge } from '@/app/components/atoms/Badge';
import { Icon } from '@/app/components/atoms/Icon';

interface HeroCardProps {
  title: string;
  description: string;
  category: string;
  duration: string;
  imageUrl: string;
  onStart?: () => void;
  className?: string;
}

export const HeroCard = ({
  title,
  description,
  category,
  duration,
  imageUrl,
  onStart,
  className = ''
}: HeroCardProps) => {
  return (
    <div 
      className={`
        relative w-full aspect-[2/1] rounded-3xl overflow-hidden shadow-lg group cursor-pointer
        ${className}
      `}
      onClick={onStart}
    >
      <img
        src={imageUrl}
        alt={title}
        className="absolute inset-0 w-full h-full object-cover opacity-80 group-hover:scale-105 transition-transform duration-700"
      />
      <div className="absolute inset-0 bg-gradient-to-t from-bg-deep via-bg-deep/40 to-transparent" />
      
      <div className="absolute inset-x-0 bottom-0 h-1/2 p-6 flex flex-col justify-between">
        <div className="flex justify-between items-start">
          <Badge variant="primary">{category}</Badge>
          <div className="bg-black/40 backdrop-blur-md px-3 py-1 rounded-full border border-white/10 flex items-center gap-1">
            <Icon name="timer" className="text-white text-[14px]" />
            <span className="text-[10px] font-bold uppercase tracking-wider text-white">
              {duration}
            </span>
          </div>
        </div>
        
        <div className="mb-2">
          <h2 className="font-title text-5xl leading-none text-white mb-2 drop-shadow-lg">
            {title}
          </h2>
          <p className="text-xs text-gray-200 line-clamp-2 w-3/4 mb-4">
            {description}
          </p>
        </div>
      </div>
    </div>
  );
};