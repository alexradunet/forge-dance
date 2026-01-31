interface BadgeProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'info';
  size?: 'sm' | 'md';
  className?: string;
}

export const Badge = ({ 
  children, 
  variant = 'primary', 
  size = 'md',
  className = '' 
}: BadgeProps) => {
  const variantStyles = {
    primary: 'bg-forge-fire text-white',
    secondary: 'bg-white/10 text-white border border-white/20',
    success: 'bg-green-500/20 text-green-400 border border-green-500/30',
    warning: 'bg-yellow-500/20 text-yellow-400 border border-yellow-500/30',
    info: 'bg-blue-500/20 text-blue-400 border border-blue-500/30'
  };
  
  const sizeStyles = {
    sm: 'text-[9px] px-2 py-0.5',
    md: 'text-[10px] px-2.5 py-1'
  };
  
  return (
    <span className={`
      inline-block font-bold uppercase tracking-wider rounded
      ${variantStyles[variant]} 
      ${sizeStyles[size]} 
      ${className}
    `}>
      {children}
    </span>
  );
};
