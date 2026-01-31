interface ProgressBarProps {
  value: number;
  max?: number;
  variant?: 'primary' | 'blue' | 'gold';
  size?: 'sm' | 'md' | 'lg';
  showLabel?: boolean;
  className?: string;
}

export const ProgressBar = ({ 
  value, 
  max = 100,
  variant = 'primary',
  size = 'md',
  showLabel = false,
  className = '' 
}: ProgressBarProps) => {
  const percentage = Math.min((value / max) * 100, 100);
  
  const variantStyles = {
    primary: 'bg-forge-fire shadow-[0_0_10px_rgba(255,69,0,0.5)]',
    blue: 'bg-electric-blue shadow-[0_0_10px_rgba(0,191,255,0.5)]',
    gold: 'bg-legend-gold shadow-[0_0_10px_rgba(255,215,0,0.5)]'
  };
  
  const sizeStyles = {
    sm: 'h-1',
    md: 'h-1.5',
    lg: 'h-2'
  };
  
  return (
    <div className={className}>
      {showLabel && (
        <div className="flex justify-between text-[10px] text-text-muted mb-2 font-medium">
          <span>{value}</span>
          <span>{max}</span>
        </div>
      )}
      <div className={`w-full bg-white/10 rounded-full overflow-hidden ${sizeStyles[size]}`}>
        <div 
          className={`${sizeStyles[size]} ${variantStyles[variant]} rounded-full transition-all duration-500`}
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
};
