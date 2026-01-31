import { Icon } from '@/app/components/atoms/Icon';

interface StatCardProps {
  icon: string;
  value: string | number;
  label: string;
  iconColor?: string;
  className?: string;
}

export const StatCard = ({ 
  icon, 
  value, 
  label, 
  iconColor = 'text-forge-fire',
  className = '' 
}: StatCardProps) => {
  return (
    <div className={`
      bg-surface-dark/80 backdrop-blur-sm border border-white/5 
      rounded-2xl p-4 flex flex-col items-center justify-center gap-2 shadow-lg
      ${className}
    `}>
      <span className="text-[10px] uppercase text-text-muted tracking-widest font-bold">
        {label}
      </span>
      <div className="flex items-center gap-2 text-white">
        <Icon name={icon} className={`text-xl filled ${iconColor}`} />
        <span className="font-mono text-2xl font-bold">{value}</span>
      </div>
    </div>
  );
};
