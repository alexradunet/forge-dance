interface PaginationDotProps {
  active?: boolean;
  variant?: 'circle' | 'bar';
  className?: string;
}

export const PaginationDot = ({ 
  active = false, 
  variant = 'circle',
  className = '' 
}: PaginationDotProps) => {
  if (variant === 'bar') {
    return (
      <div 
        className={`
          h-1.5 flex-1 rounded-full transition-all duration-300
          ${active ? 'bg-forge-fire shadow-[0_0_8px_rgba(255,69,0,0.5)]' : 'bg-white/20'}
          ${className}
        `}
      />
    );
  }
  
  return (
    <div 
      className={`
        w-2 h-2 rounded-full transition-all duration-300
        ${active ? 'bg-forge-fire shadow-[0_0_6px_rgba(255,69,0,0.3)]' : 'bg-neutral-700'}
        ${className}
      `}
    />
  );
};
